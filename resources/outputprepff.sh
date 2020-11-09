#!/bin/bash


mkdir -p /home/coverageReports/firefox/
mkdir -p /tmp/output/
mkdir -p /home/firefoxfuzzing/URLTestFiles

echo "removing previous coverage data"
cd /home/mozilla-unified
echo "delete .gcda files"
find . -type f -name '*.gcda'  -delete 
rm -r /home/mozilla-unified/netwerk/test/URLTestFiles

