import argparse
import os
import subprocess
import json
import datetime
from bs4 import BeautifulSoup


def extractCoverage(parser, parsed_report):
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
parser.add_argument("-i", default="combined")
parser.add_argument("-g")
parser.add_argument("-m", nargs='+')
parser.add_argument("-s", default=None)
parser.add_argument("-r", type=int, default=2)

args = parser.parse_args()
image=args.i
grammar = args.g
#grammar="/home/url-fuzzing/grammars/livingstandard-url.scala"
	# also use ls wo ui, rfc for other stages
# list of modes to use
modes=args.m
seed=""
if args.s is not None:
	seed="--random-seed="+args.s
stages=modes 

runs_per_stage=args.r
result_dir="/vagrant/multiple_results/"
 
# runs per stage = docker image executions
# result dir = will be mounted do docker, holds reports after execution


stagecoverages=[]
for stage in stages:
	for run_nr in range(0, runs_per_stage):
		run_name="Run_"+str(run_nr)
		logfile=result_dir+stage+run_name+".log"
		run_results=result_dir+stage+run_name+"/"
		runcoverage={}
		runcoverage["sum"]=0
#		execute docker image
		print("docker run -v "+run_results+":/home/coverageReports -v /root:/home/mountedtribble -t "+image+" "+grammar+" "+stage+ seed +" y y >"+logfile)
		os.system("docker run -v "+run_results+":/home/coverageReports -v /root:/home/mountedtribble  -t "+image+" "+grammar+" "+stage+ seed +" y y >"+logfile )
		#extract coverages
		for parser in parsers:
			try:
				html=""
				with open(run_results+parsers[parser], encoding='utf-8') as f: 
						html=f.read()

				parsed_report=BeautifulSoup(html, "lxml")
				
				cov=extractCoverage(parser, parsed_report)
			except:
				cov=0
			runcoverage[parser]=cov
			runcoverage["sum"]+=cov
		# extract nr of inputs
		f=open(run_results+"resultoverview.html", "r")
		inputs=""
		for i in range(0,5):
			line=f.readline().replace("\n", "")
			if "Total number of URLs" in line:
				inputs=line.replace("<p>Total number of URLs: ", "").replace("</p>","")
				break
		f.close()
		runcoverage["nr_inputs"]=inputs
		# extract execution time + seed
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

		runcoverage["full_execution_time"]=full_time.replace("[", "").replace("]", "").replace(" ","")
		runcoverage["generation_time"]=fuzz_start.replace("[", "").replace("]", "").replace(" ","")
		fuzz_end=fuzz_end.replace("[", "").replace("]", "").replace(" ","")
		fuzz_start=fuzz_start.replace("[", "").replace("]", "").replace(" ","")
		fb=datetime.datetime.strptime(fuzz_start, '%H:%M:%S')
		fe=datetime.datetime.strptime(fuzz_end, '%H:%M:%S')
		ft=fe-fb
		runcoverage["fuzzing_time"]=str(ft)
		runcoverage["seed"]=used_seed
		runcoverage["run_id"]=stage+run_name
		print(runcoverage)
		
	stagecoverages+=[runcoverage]	

	

f=open(result_dir+"runexpResults", "w")
f.write(str(sorted(stagecoverages, key = lambda item: (item['firefox'], item['javascriptwhatwg-url'], item['sum']))))
f.close()





			
