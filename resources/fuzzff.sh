#!/bin/bash

#expected arguments: comp-created input-dir

comp-created="$1"
input-dir="$2"

cd /home/url-fuzzing/firefox

if [[ "$comp-created" == "yes" ]]
then
	python urlfileconversion.py -dir "$input-dir"/firefox
else
	python urlfileconversion_NO_components.py -dir "$input-dir"/plain
fi


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
