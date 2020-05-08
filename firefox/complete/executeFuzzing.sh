#!/bin/bash


mkdir -p /mountdir/coverageReport/

echo "building tribble"
cd /home/tribble
./gradlew build >>/tmp/output/tribblebuild.txt
mv ./build/libs/tribble-0.1.jar tribble.jar

java -jar tribble.jar generate --mode=2-path-30 --suffix=.md --grammar-file=/home/url-fuzzing/livingstandard-url.scala --out-dir=/home/firefoxfuzzing/URLTestFilesRaw >>/tmp/output/tribblegen.txt

cd /home/url-fuzzing/firefox
python urlfileconversion.py -dir /home/firefoxfuzzing/URLTestFilesRaw

cp -r /home/firefoxfuzzing/URLTestFiles /mozilla-unified/netwerk/test/URLTestFiles
cd /mozilla-unified

./mach test ./netwerk/test/URLTestFiles
grcov ./mozilla-unified -t lcov >lcov.info
genhtml -o /mountdir/coverageReport --show-details --highlight --ignore-errors source --legend lcov.info