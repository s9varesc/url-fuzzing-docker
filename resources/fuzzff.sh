#!/bin/bash

#expected arguments: comp_created input_dir

comp_created="$1"
input_dir="$2"

mkdir -p /home/coverageReports/firefox
cd /home/url-fuzzing/firefox


if [[ "$comp_created" == "yes" ]]
then
	python3 urlfileconversion.py -dir "$input_dir"/firefox
else
	python3 urlfileconversion_NO_components.py -dir "$input_dir"/plain
fi

echo "removing old coverage data"
cd /home/mozilla-unified
find -name "*.gcda" -type f -delete

if [ -d "/home/coverageReports/firefox" ]
then
	rm -r /home/coverageReports/firefox
fi
mkdir -p /home/coverageReports/firefox


cd /home/url-fuzzing/firefox

echo "executing tests"
#cargo install --version 0.5.15 grcov
PATH=$PATH:/root/.cargo/bin
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

cp /home/url-fuzzing/firefox/allinputURLs /home/coverageReports/Exceptions/
cp -r /home/url-fuzzing/firefox/URLTestFiles /home/mozilla-unified/netwerk/test/URLTestFiles
mkdir -p /home/mozilla-unified/obj-x86_64-pc-linux-gnu/_tests/xpcshell/netwerk/test/URLTestFiles

cp -r /home/url-fuzzing/firefox/URLTestFiles /home/mozilla-unified/obj-x86_64-pc-linux-gnu/_tests/xpcshell/netwerk/test/
cp /home/url-fuzzing/firefox/moz.build /home/mozilla-unified/netwerk/test/
cd /home/mozilla-unified

SHELL=/bin/bash ./mach test --headless ./netwerk/test/URLTestFiles >/home/coverageReports/firefox/firefoxoutput.log

cd ..
echo "generating reports"

grcov ./mozilla-unified --ignore *.rs -t lcov >lcov.info
genhtml -o /home/reports/firefox --show-details --highlight --ignore-errors source --legend lcov.info >genhtmlout.txt 2> /dev/null
cp /home/reports/firefox/netwerk/base/nsURL*.html /home/coverageReports/firefox
cp /home/reports/firefox/netwerk/base/index.html /home/coverageReports/firefox

cd /home/url-fuzzing/evaluation-tools
python3 browseroutputcleanup.py -dir /home/coverageReports/firefox
mv /home/coverageReports/firefox/firefoxExceptions.txt /home/coverageReports/Exceptions/			
mv /home/coverageReports/firefox/firefoxErrors.txt /home/coverageReports/Exceptions/
