#!/bin/bash

#expected arguments: comp_created input_dir

comp_created="$1"
input_dir="$2"

cd /home/url-fuzzing/firefox

if [[ "$comp_created" == "yes" ]]
then
	python urlfileconversion.py -dir "$input_dir"/firefox
else
	python urlfileconversion_NO_components.py -dir "$input_dir"/plain
fi

echo "removing old coverage data"
cd /home/mozilla-unified
find -name "*.gcda" -type f -delete
cd /home/url-fuzzing/firefox

echo "executing tests"
cargo install --version 0.5.15 grcov
PATH=$PATH:/root/.cargo/bin

cp -r /home/url-fuzzing/firefox/URLTestFiles /home/mozilla-unified/netwerk/test/URLTestFiles
mkdir -p /home/mozilla-unified/obj-x86_64-pc-linux-gnu/_tests/xpcshell/netwerk/test/URLTestFiles

cp -r /home/url-fuzzing/firefox/URLTestFiles /home/mozilla-unified/obj-x86_64-pc-linux-gnu/_tests/xpcshell/netwerk/test/
cp /home/url-fuzzing/firefox/moz.build /home/mozilla-unified/netwerk/test/
cd /home/mozilla-unified

SHELL=/bin/bash ./mach test ./netwerk/test/URLTestFiles >/home/coverageReports/firefox/firefoxoutput.log

cd ..
echo "generating reports"
grcov ./mozilla-unified -t lcov >lcov.info
genhtml -o /home/coverageReports/firefox --show-details --highlight --ignore-errors source --legend lcov.info >genhtmlout.txt
