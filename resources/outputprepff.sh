#!/bin/bash


mkdir -p /home/coverageReports/firefox/
mkdir -p /tmp/output/

rm -r /home/mozilla-unified/netwerk/test/URLTestFiles
rm -r /home/url-fuzzing/firefox/URLTestFiles
mkdir -p /home/firefoxfuzzing/URLTestFiles

echo "removing previous coverage data"
cd /home/mozilla-unified
find . -type f -name '*.gcda'  -delete 



