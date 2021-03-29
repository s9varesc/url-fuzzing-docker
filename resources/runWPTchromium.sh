#!/bin/bash

cd /home/chromium
pip install requests

PATH=$PATH:/home/depot_tools   #TODO check location

#TODO copy altered file

coverage.py blink_tests -wt='web_tests/external/wpt/url/url-constructor.any.js' -b out/coverage -o out/report -f url/		#TODO check everything again


# copy reports and logs to mounted dir
cp out/report/linux/home/chromium/src/url/third_party/mozilla/* /home/coverageReports/chromium		#TODO check location and structure
cp out/report/linux/logs/url_unittests_output.log /home/coverageReports/chromium		#TODO find actual log file
cp /home/url-fuzzing/chromium/style.css /home/coverageReports/chromium

cd /home/url-fuzzing/chromium
python stylefix.py -dir /home/coverageReports/chromium
