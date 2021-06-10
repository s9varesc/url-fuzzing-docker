import argparse
import os
import subprocess
import json
import datetime
from bs4 import BeautifulSoup

def selectTestFiles(test_file_dir, nr_tests):
	if test_file_dir[-1]!="/":
		test_file_dir+="/"
	selectedFiles=[]
	for filename in os.listdir(test_file_dir+"plain"):
		if len(selectedFiles) < nr_tests:
			selectedFiles+=[filename.rsplit("_", 1)]
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


	if origin_dir[-1]!= "/":
		origin_dir+="/"
	if destination_dir[-1]!="/":
		destination_dir+="/"
	subdirs=["chromium/", "firefox/", "plain/"]
	for filename in selected_files:
		for subdir in subdirs:
			print("mv "+origin_dir+subdir+"*"+filename +"*_* "+destination_dir+subdir) #for testing
			os.system("mv "+origin_dir+subdir+"*"+filename  +"*_* "+destination_dir+subdir)
	return


def extractParsedCoverage(parser, parsed_report):
	if parser=="firefox" or parser=="c" or parser=="cpp":
		return extractLCOV(parsed_report)
	elif parser=="chromium":
		tbody=parsed_report.find("tbody").find("tr", attrs={"class", "light-row"})
		td=tbody.find_all("td")
		percent=td[1].find("pre")
		cov=float((percent.text).split("%")[0])
		return cov
	elif parser=="go":
		op=parsed_report.find("option")
		cov=float(op.text.split("(")[1].split("%")[0])
		return cov
	elif parser=="java":
		tds=parsed_report.find_all("td", attrs={"class", "reportValue"})
		cov=float(tds[3].find("b").text)
		return cov
	elif parser=="javascripturijs" or parser=="javascriptwhatwg-url":
		return extractNYC(parsed_report)
	elif parser=="php":
		tbody=parsed_report.find("tbody")
		cov=float(tbody.find("div").find("span").text.split("%")[0])
		return cov
	elif parser=="python":
		cov=float(parsed_report.find("title").text.split(":")[1][:-1])
		return cov
	elif parser=="ruby":
		h=parsed_report.find("h2").find("span", attrs={"class", "covered_percent"})
		span=h.find("span").text.split("%")[0]
		cov=float(span)
		return cov
	else:
		return 0

def extractNYC(parsed_report):
	maindiv=parsed_report.find("div", attrs={"class", "pad1"})
	divs=maindiv.find_all("div")

	for div in divs:
		qspan=div.find("span",attrs={"class", "quiet"})
		if qspan.text == "Lines":
			cov=div.find("span",attrs={"class", "strong"})
			return float(cov.text[:-2])

def extractLCOV(parsed_report):
	table=parsed_report.find("table")
	table_data=table.find_all("tr")

	for row in table_data:
	#print(row)
		if row.find("tr") is not None:
		#print(row.find_all("tr"))
			pass
		else:
			headers=row.find_all("td", attrs={"class", "headerItem"})
			thisrow=False
			for header in headers:
				if header.text=="Lines:":
					thisrow=True
			if thisrow:
				coverage=0.0
				attr=["headerCovTableEntryHi", "headerCovTableEntryMed", "headerCovTableEntryLo"]
				for att in attr:
					content=row.find("td", attrs={"class",att })
					if content is not None:
						coverage+=float(content.text[:-1])
				return coverage

def extractCoverage(parser, result_dir):
	cov=0
	try:
		html=""
		with open(result_dir+parsers[parser], encoding='utf-8') as f: 
				html=f.read()

		parsed_report=BeautifulSoup(html, "lxml")
		
		cov=extractCoverage(parser, parsed_report)
		
	except Exception as e:
		#print(e)
		cov=0
	return cov

def extractRunData(logfile):
	rundata={}
	f=open(logfile, "r")
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
	rundata["seed"]=used_seed
	return run_data
			



parsers={}
parsers["chromium"]="chromium/report.html"
parsers["firefox"]="firefox/nsURLParsers.cpp.gcov.html" 
parsers["c"]="C/src/UriParse.c.gcov.html"
parsers["cpp"]="Cpp/src/URI.cpp.gcov.html"
parsers["go"]="Go/index.html"
parsers["java"]="Java/java/net/URL.html" 
parsers["javascripturijs"]="JavaScript/urijs/URI.js.html"
parsers["javascriptwhatwg-url"]="JavaScript/whatwg-url/whatwg-url/dist/url-state-machine.js.html"
parsers["php"]="PHP/index.html"
parsers["python"]="Python/_usr_lib_python3_6_urllib_parse_py.html"
parsers["ruby"]="Ruby/index.html"
  

parser = argparse.ArgumentParser()
parser.add_argument("-t", default=10, type=int)	# nr of tests selected for each run
parser.add_argument("-dir")		# test file dir
parser.add_argument("-components", default=False) 	# do the test files contain components
parser.add_argument("-max_runs", default=10000, type=int) #TODO use a reasonable default value
parser.add_argument("-exp_result_dir", default="./")




args = parser.parse_args()

test_set_size=args.t
test_dir=args.dir
if test_dir[-1]!="/":
	test_dir+="/"
comp=args.components
components=""
if comp:
	components="y"
else:
	components="n"
stopcriteria=args.max_runs

mounting_dir_tests="/home/URLTestFiles/"	# test files will be gradually moved here
mounting_dir_reports="/home/reports/"		# the docker image writes its results here
logfile=mounting_dir_reports+"dockerlog.log"
max_reports_dir=args.exp_result_dir
if max_reports_dir[:-1]!="/":
	max_reports_dir+="/"

run_details=[]	# execution time, inputs, coverages
coverages={} 	# list of coverages per parser
max_coverages={}	# keep track of the max coverage
for p in parsers:
	max_coverages[p]={}
	max_coverages[p]["coverage"]=-1
	max_coverages[p]["run"]=-1
	coverages[p]=[]
	os.system("mkdir -p "+max_reports_dir+"p")

print("coverages")	# only for testing
print(coverages)
print("max_coverages")
print(max_coverages)





run_nr=0
while run_nr<=stopcriteria:
	# select test files
	tests=selectTestFiles(test_dir, test_set_size)
	moveSelectedTests(test_dir, mounting_dir_tests, tests)
	# run the docker image
	print("docker run -v "+mounting_dir_reports+":/home/coverageReports -v "+mounting_dir_tests+":/home/test-files -t combined test "+components+" /home/test-files/ >"+logfile)
	os.system("docker run -v "+mounting_dir_reports+":/home/coverageReports -v "+mounting_dir_tests+":/home/test-files -t combined test "+components+" /home/test-files/ >"+logfile)

	run_data={}
	run_data["id"]=run_nr
	run_data["nr_inputs"]=test_set_size*(run_nr + 1) #TODO last run could be different
	# extract the coverages
	for p in parsers:
		coverage=extractCoverage(p, mounting_dir_reports)
		coverages[p]+=[coverage]
		# check if this is a new maximum
		if coverage> max_coverages[p]["coverage"]:
			# update max_coverages
			max_coverages[p]["coverage"]=coverage
			max_coverages[p]["run"]=run_nr
			# update max report
			os.system("rm -r "+ max_reports_dir+p+"/*")
			os.system("cp -r "+mounting_dir_reports+"/*"+" "+max_reports_dir+p+"/")
			
		run_data[p]=coverage
	# collect some more run data
	logdetails=extractRunData(logfile)
	run_data.update(logdetails)

	run_details+=[run_data]

	# write result files
	f=open(max_reports_dir+"runDetails", "w")
	f.write(str(run_details))
	f.close()
	f=open(max_reports_dir+"allCoverages", "w")
	f.write(str(coverages))
	f.close()
	f=open(max_reports_dir+"maxCoverages", "w")
	f.write(str(max_coverages))
	f.close()

	run_nr+=1











			
