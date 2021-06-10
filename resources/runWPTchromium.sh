#!/bin/bash

cd /home/chromium
pip install requests

PATH=$PATH:/home/depot_tools   

# copy altered url-constructor file if necessary
cd /home/chromium/src
python tools/code_coverage/coverage.py blink_tests -wt='--driver-logging web_tests/external/wpt/url/url-constructor.any.js' -b out/coverage -o out/report -f url/	


# copy reports and logs to mounted dir
cp out/report/linux/home/chromium/src/url/third_party/mozilla/* /home/coverageReports/chromium		
cp out/report/linux/logs/blink_tests_output.log /home/coverageReports/chromium		
cp /home/url-fuzzing/chromium/style.css /home/coverageReports/chromium

cd /home/url-fuzzing/chromium
python stylefix.py -dir /home/coverageReports/chromium
