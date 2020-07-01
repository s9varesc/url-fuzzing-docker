#!/bin/bash


#mkdir -p /mountdir/coverageReport/
mkdir -p /tmp/output/

cd /home/url-fuzzing/
git pull


#cp -r /home/url-fuzzing/tribble-additions/* /home/tribble/src/main/scala/saarland/cispa/se/tribble/execution 
#TODO:change back to tribble-additions/comp... after folder set up is fixed
cp -r /home/url-fuzzing/tribble-additions/testnewversion/componentExtraction /home/tribble/src/main/scala/saarland/cispa/se/tribble/execution/componentExtraction
cp /home/url-fuzzing/tribble-additions/onlyChromiumComponents/* /home/tribble/src/main/scala/saarland/cispa/se/tribble/execution

echo "building tribble"
cd /home/tribble
./gradlew build >/tmp/output/tribblebuild.txt
mv ./build/libs/tribble-0.1.jar tribble.jar

java -jar tribble.jar generate --mode=2-path-30 --suffix=.md --grammar-file=/home/url-fuzzing/livingstandard-url.scala --out-dir=/home/URLTestFilesRaw >/tmp/output/tribblegen.txt

cd /home/url-fuzzing/chromium
python urlfileconversion.py -dir /home/URLTestFilesRaw/chromium

cp /home/url-fuzzing/chromium/BUILD.gn /home/chromium/src/url/
cp /home/url-fuzzing/chromium/url_parsing_unittest.cc /home/chromium/src/url/

cd /home/chromium/src
python tools/code_coverage/coverage.py url_unittests -b out/coverage -o out/report -c 'out/coverage/url_unittests --gtest_filter=URLParser.Parsing' -f url/
#cp -r out/report/ /mountdir/coverageReport/ full report
cp out/report/linux/home/chromium/src/url/third_party/mozilla/* /mountdir
cp out/report/linux/logs/url_unittests_output.log /mountdir
