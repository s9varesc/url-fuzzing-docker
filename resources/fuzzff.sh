#!/bin/bash


cd /home/url-fuzzing/firefox
python urlfileconversion.py -dir /home/firefoxfuzzing/URLTestFilesRaw/firefox

echo "executing tests"
cargo install grcov
PATH=$PATH:/root/.cargo/bin
cp -r /home/url-fuzzing/firefox/URLTestFiles /mozilla-unified/netwerk/test/URLTestFiles
mkdir -p /mozilla-unified/obj-x86_64-pc-linux-gnu/_tests/xpcshell/netwerk/test/URLTestFiles

cp -r /home/url-fuzzing/firefox/URLTestFiles /mozilla-unified/obj-x86_64-pc-linux-gnu/_tests/xpcshell/netwerk/test/
cp /home/url-fuzzing/firefox/moz.build /mozilla-unified/netwerk/test/
cd /mozilla-unified

./mach test ./netwerk/test/URLTestFiles

cd ..
echo "generating reports"
grcov ./mozilla-unified -t lcov >lcov.info
genhtml -o /mountdir/coverageReport --show-details --highlight --ignore-errors source --legend lcov.info >genhtmlout.txt
