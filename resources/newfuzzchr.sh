#!/bin/bash


#expected arguments: comp-created input-dir

PATH=$PATH:/home/depot_tools
cd /home/url-fuzzing/chromium

comp-created=$1
input-dir=$2

if [[ "$comp-created" == "yes" ]]
then
	python urlfileconversion.py -dir "$input-dir"/chromium
else
	python urlfileconversion_NO_components.py -dir "$input-dir"/plain
fi


cp /home/url-fuzzing/chromium/BUILD.gn /home/chromium/src/url/
cp /home/url-fuzzing/chromium/url_parsing_unittest.cc /home/chromium/src/url/

cd /home/chromium/src

python tools/code_coverage/coverage.py url_unittests -b out/coverage -o out/report -c 'out/coverage/url_unittests --gtest_filter=URLParser.Parsing' -f url/
#cp -r out/report/ /home/coverageReports/chromium/coverageReport/ full report
cp out/report/linux/home/chromium/src/url/third_party/mozilla/* /home/coverageReports/chromium
cp out/report/linux/logs/url_unittests_output.log /home/coverageReports/chromium
cp /home/url-fuzzing/chromium/url_parsing_unittest.cc /home/coverageReports/chromium