#!/bin/bash


cd /home/url-fuzzing/chromium
python urlfileconversion.py -dir /home/URLTestFilesRaw/chromium

cp /home/url-fuzzing/chromium/BUILD.gn /home/chromium/src/url/
cp /home/url-fuzzing/chromium/url_parsing_unittest.cc /home/chromium/src/url/

cd /home/chromium/src
mkdir -p ./out/report
python3 tools/code_coverage/coverage.py url_unittests -b out/coverage -o out/report -c 'out/coverage/url_unittests --gtest_filter=URLParser.Parsing' -f url/
#cp -r out/report/ /home/coverageReports/chromium/coverageReport/ full report
cp out/report/linux/home/chromium/src/url/third_party/mozilla/* /home/coverageReports/chromium
cp out/report/linux/logs/url_unittests_output.log /home/coverageReports/chromium
cp /home/url-fuzzing/chromium/url_parsing_unittest.cc /home/coverageReports/chromium