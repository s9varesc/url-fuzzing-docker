import argparse
import os
import subprocess
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
	elif parser=="javascripturijs" or parser=="javascriptwhatwgurl":
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
parsers["javascriptwhatwgurl"]="JavaScript/whatwg-url/whatwg-url/dist/url-state-machine.js.html"
parsers["php"]="PHP/index.html"
parsers["python"]="Python/_usr_lib_python3_6_urllib_parse_py.html"
parsers["ruby"]="Ruby/index.html"




	
	
parser = argparse.ArgumentParser()
parser.add_argument("-grammar")
parser.add_argument("-stages")
parser.add_argument("-runs_per_stage")
parser.add_argument("-result_dir")

args = parser.parse_args()

grammar=args.grammar
nr_stages=int(args.stages)
runs_per_stage=int(args.runs_per_stage)
result_dir=args.result_dir    

if result_dir[-1:] != "/":
	result_dir+="/"


# stage = test set size = equal nr of test inputs  
# runs per stage = docker image executions
# result dir = will be mounted do docker, holds reports after execution

stages=[]
for i in range(1, nr_stages+1):
	stages+=[str(i) +"-path-30"]

print(stages)

stagecoverages={}
avgstagecoverages={}
for stage in stages:
	avgstagecoverages[stage]={}
	stagecoverage={}
	addedcov={}
	for parser in parsers:
		addedcov[parser]=0
	for run_nr in range(0, runs_per_stage):
		runcoverage={}
#		execute docker image
		print("docker run -v "+result_dir+":/home/coverageReports -t combined "+grammar+" "+stage)
		os.system("docker run -v "+result_dir+":/home/coverageReports -t combined "+grammar+" "+stage+" y y")
		for parser in parsers:
			html=""
			with open(result_dir+parsers[parser], encoding='utf-8') as f:
					html=f.read()

			parsed_report=BeautifulSoup(html, "lxml")
			
			cov=extractCoverage(parser, parsed_report)
			runcoverage[parser]=cov
			addedcov[parser]+=cov
#
#
		stagecoverage[run_nr]=runcoverage
	
	for parser in parsers:
		avgstagecoverages[stage][parser]=addedcov[parser]/runs_per_stage
	print(avgstagecoverages[stage])	
	
	stagecoverages[stage]=stagecoverage		


#print(stagecoverages)
print(avgstagecoverages)




			
