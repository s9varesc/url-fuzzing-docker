import argparse
import os
import subprocess
import json
import datetime
import pandas as pd


def selectTestFiles(test_file_dir, nr_tests):
	if test_file_dir[-1:]!="/":
		test_file_dir+="/"
	selectedFiles=[]
	testsubdir=""
	for sdir in ["chromium/", "firefox/", "plain/"]:	
		if os.path.isdir(test_file_dir+sdir):
			testsubdir=sdir
	for filename in os.listdir(test_file_dir+testsubdir):	
		if len(selectedFiles) < nr_tests:
			selectedFiles+=[filename.rsplit("_", 1)[0]]
		else:
			break
	return selectedFiles

def moveSelectedTests(origin_dir, destination_dir, selected_files):
	# expected directory structure:
	# test_file_dir/
	#		| chromium/
	#			| components_fileXY
	#		| firefox
	#			| components_fileXY
	#		| plain
	#			| fileXY


	if origin_dir[-1:]!= "/":
		origin_dir+="/"
	if destination_dir[-1:]!="/":
		destination_dir+="/"
	subdirs=[]
	for sdir in ["chromium/", "firefox/", "plain/"]:	# only use existing dirs
		if os.path.isdir(origin_dir+sdir):
			subdirs+=[sdir]
			os.system("mkdir -p "+destination_dir+sdir) #prepare new location
	
	os.system("cp "+origin_dir+"*seed* "+destination_dir+"used_seed")
	
	for filename in selected_files:
		for subdir in subdirs:
			#print("mv "+origin_dir+subdir+"*"+filename +"*_* "+destination_dir+subdir) #for testing
			os.system("mv "+origin_dir+subdir+"*"+filename  +"*_* "+destination_dir+subdir)
	return




def extractRunData(logfile):
	rundata={}
	f=open(logfile, "r")
	#print(logfile)
	log=f.read()
	f.close()
	full_time=""
	fuzz_start=""
	fuzz_end=""
	used_seed=""
	for line in log.split("\n"):
		if "] done" in line:
			full_time=line.replace("done", "")
		if "fuzzing targets" in line:
			fuzz_start=line.replace("fuzzing targets", "")
			for t in ["firefox", "chromium", "languages", "all"]:
				fuzz_start=fuzz_start.replace(t, "")
		if "finalizing results" in line:
			fuzz_end=line.replace("finalizing results", "")
		if "seed:" in line:
			used_seed=line.split("seed:")[1]

	rundata["full_execution_time"]=full_time.replace("[", "").replace("]", "").replace(" ","")
	rundata["prep_time"]=fuzz_start.replace("[", "").replace("]", "").replace(" ","")
	fuzz_end=fuzz_end.replace("[", "").replace("]", "").replace(" ","")
	fuzz_start=fuzz_start.replace("[", "").replace("]", "").replace(" ","")
	fb=datetime.datetime.strptime(fuzz_start, '%H:%M:%S')
	fe=datetime.datetime.strptime(fuzz_end, '%H:%M:%S')
	ft=fe-fb
	rundata["fuzzing_time"]=str(ft)
	#rundata["seed"]=used_seed
	#print(rundata)
	return rundata
			



parsers=[]
pre_parsers=["chromium", "firefox", "c", "cpp", "go", "java", "javascripturijs", "javascriptwhatwg-url", "php", "python", "ruby"]

  

parser = argparse.ArgumentParser()
parser.add_argument("-t", default=10, type=int)	# nr of tests selected for each run
parser.add_argument("-i", default="combined") 	# which docker image to use, values: combined, firefox, chromium, languages
parser.add_argument("-dir")		# test file dir
parser.add_argument("-components", default="n") 	# do the test files contain components
parser.add_argument("-max_runs", default=10000, type=int) 
parser.add_argument("-exp_result_dir", default="./")
parser.add_argument("-update_rate", default=10, type=int)




args = parser.parse_args()

test_set_size=args.t
test_dir=args.dir
if test_dir[-1:]!="/":
	test_dir+="/"
components=args.components
stopcriteria=args.max_runs
update_rate=args.update_rate

mounting_dir_tests="/home/URLTestFiles/"	# test files will be gradually moved here
os.system("rm -r "+mounting_dir_tests+"*") #remove test files from previous experimments
os.system("mkdir -p "+mounting_dir_tests)
#os.system("mkdir -p "+mounting_dir_tests+"firefox")	#will be created during mv
#os.system("mkdir -p "+mounting_dir_tests+"chromium")
os.system("mkdir -p "+mounting_dir_tests+"plain")
mounting_dir_reports="/home/reports/"		# the docker image writes its results here
os.system("mkdir -p "+mounting_dir_reports)
logfile=mounting_dir_reports+"dockerlog.log"
max_reports_dir=args.exp_result_dir
if max_reports_dir[-1:]!="/":
	max_reports_dir+="/"





image=args.i
# only check results of contained parsers
if image == "combined":
	parsers=pre_parsers
elif image in ["firefox", "chromium"]:
	parsers+=image
elif image == "languages":
	for p in pre_parsers:
		if p not in ["firefox", "chromium"]:
			parsers+=p
else:
	print("bad image value")
	exit()


full_csv=pd.DataFrame()
full_components_csv=pd.DataFrame()

max_coverages={}	# keep track of the max coverage
for p in parsers:
	max_coverages[p]=-1
	os.system("mkdir -p "+max_reports_dir+p)

run_nr=0	
nr_inputs=0
while run_nr +1 <=stopcriteria:
	# select test files
	tests=selectTestFiles(test_dir, test_set_size)	
	if len(tests) < 1:
		print("no more inputs to use, stopping")
		break
	nr_inputs+=len(tests)
	moveSelectedTests(test_dir, mounting_dir_tests, tests)
	# run the docker image
	#print("docker run -v "+mounting_dir_reports+":/home/coverageReports -v "+mounting_dir_tests+":/home/test-files --rm -t "+image+" test "+components+" >"+logfile)
	exit_val=os.system("docker run -v "+mounting_dir_reports+":/home/coverageReports -v "+mounting_dir_tests+":/home/test-files --rm -t "+image+" test "+components+" >"+logfile)
	if exit_val != 0 :
		print("docker execution did not result in success, stopping")
		break

	result_data=pd.read_csv(mounting_dir_reports+"mainresults.csv")
	result_data.insert(0, "run_nr", run_nr, False)
	comp_result_data=pd.read_csv(mounting_dir_reports+"component_results.csv")
	comp_result_data.insert(0, "run_nr", run_nr, False)
	comp_result_data.insert(1, "nr_inputs", nr_inputs, False)

	# extract the coverages
	for p in parsers:
		coverage=result_data.iloc[0][p+"-cov"]
	
		# check if this is a new maximum				
		if coverage> max_coverages[p]:	
			# update max_coverages
			max_coverages[p]=coverage
			# update max report
			os.system("rm -r "+ max_reports_dir+p+"/*")
			os.system("cp -r "+mounting_dir_reports+"*"+" "+max_reports_dir+p+"/")
			
	
	# collect some more run data
	logdetails=extractRunData(logfile)	
	for logkey in logdetails:	# add log details to dataframe
		result_data[logkey]=logdetails[logkey]
	
	

	full_csv=pd.concat([full_csv, result_data], ignore_index=True)
	
	full_components_csv=pd.concat([full_components_csv, comp_result_data], ignore_index=True)
	
	# write result files 						
	full_csv.to_csv(max_reports_dir+"experimentResultsMain.csv", index=False, na_rep=0)
	full_components_csv.to_csv(max_reports_dir+"experimentResultsComponents.csv", index=False, na_rep=0)

	
	if run_nr % update_rate == 0:
		update_success=True
		try:
			exit_val=os.system("/home/url-fuzzing-docker/update-results.sh")
			if exit_val!=0:
				update_success=False
		except Exception as e:
			update_success=False
		
		if not update_success:
			print("updating the results repository failed ")
			print("will try again after the next "+update_rate+" runs")

	run_nr+=1











			
