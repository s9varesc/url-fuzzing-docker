#!/bin/bash


mkdir -p /mountdir/coverageReport/

cd /home/url-fuzzing/
git pull

### TODO change to chromium tests!!!!!!!!!!!!!!!!!
cp -r /home/url-fuzzing/tribble-additions/* /home/tribble/src/main/scala/saarland/cispa/se/tribble/execution 

echo "building tribble"
cd /home/tribble
./gradlew build >>/tmp/output/tribblebuild.txt
mv ./build/libs/tribble-0.1.jar tribble.jar

java -jar tribble.jar generate --mode=2-path-30 --suffix=.md --grammar-file=/home/url-fuzzing/livingstandard-url.scala --out-dir=/home/firefoxfuzzing/URLTestFilesRaw >>/tmp/output/tribblegen.txt

cd /home/url-fuzzing/firefox
python urlfileconversion.py -dir /home/firefoxfuzzing/URLTestFilesRaw

cp -r /home/firefoxfuzzing/URLTestFiles /mozilla-unified/netwerk/test/URLTestFiles
cd /mozilla-unified
####

##TODO run generated tests
cd /home/chromium/src
python tools/code_coverage/coverage.py url_unittests -b out/coverage -o out/report -c 'out/coverage/url_unittests --gtest_filter=URLParser.Parsing' -f url/
cp -r out/report/ /mountdir/coverageReport/
