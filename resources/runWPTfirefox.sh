#!/bin/bash


echo "removing old coverage data"
cd /home/mozilla-unified
find -name "*.gcda" -type f -delete


cd /home/mozilla-unified/testing/web-platform/tests
./wpt make-hosts-file | tee -a /etc/hosts

cp /home/resources/altered-url-constructor.any.js /home/mozilla-unified/testing/web-platform/tests/url/url-constructor.any.js

cd /home/mozilla-unified 

./mach wpt --headless --no-install-fonts --log-wptreport wptlog.json testing/web-platform/tests/url/url-constructor.any.js



cp wptlog.json /home/coverageReports


cd ..
echo "generating reports"
grcov ./mozilla-unified --ignore *.rs -t lcov >lcov.info
genhtml -o /home/reports/firefox --show-details --highlight --ignore-errors source --legend lcov.info >genhtmlout.txt 2> /dev/null
