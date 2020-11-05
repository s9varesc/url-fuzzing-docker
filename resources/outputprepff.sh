#!/bin/bash


mkdir -p /home/coverageReports/firefox/
mkdir -p /tmp/output/
mkdir -p /home/firefoxfuzzing/URLTestFiles

echo "removing previous coverage data"
cd /home/mozilla-unified
find . -type f -name '*.gcda' -print  -delete
rm -r /home/mozilla-unified/netwerk/test/URLTestFiles

