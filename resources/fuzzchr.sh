#!/bin/bash


#expected arguments: comp_created input_dir

PATH=$PATH:/home/depot_tools
mkdir -p /home/coverageReports/chromium
cd /home/url-fuzzing/chromium

comp_created="$1"
input_dir="$2"

if [[ "$comp_created" == "yes" ]]
then
	python urlfileconversion.py -dir "$input_dir"/chromium
else
	python urlfileconversion_NO_components.py -dir "$input_dir"/plain
fi

cp /home/url-fuzzing/chromium/allinputURLs /home/coverageReports/Exceptions/
cp /home/url-fuzzing/chromium/BUILD.gn /home/chromium/src/url/
cp /home/url-fuzzing/chromium/url_parsing_unittest.cc /home/chromium/src/url/

cd /home/chromium/src

python tools/code_coverage/coverage.py url_unittests -b out/coverage -o out/report -c 'out/coverage/url_unittests --gtest_filter=URLParser.Parsing' -f url/
#cp -r out/report/ /home/coverageReports/chromium/coverageReport/ full report
cp out/report/linux/home/chromium/src/url/third_party/mozilla/* /home/coverageReports/chromium
cp out/report/linux/logs/url_unittests_output.log /home/coverageReports/chromium
cp /home/url-fuzzing/chromium/url_parsing_unittest.cc /home/coverageReports/chromium
cp /home/url-fuzzing/chromium/style.css /home/coverageReports/chromium
mv /home/coverageReports/chromium/url_unittests_output.log /home/coverageReports/chromium/chromiumoutput.log 

cd /home/url-fuzzing/chromium
python stylefix.py -dir /home/coverageReports/chromium
