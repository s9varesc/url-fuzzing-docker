#!/bin/bash


mkdir -p /home/coverageReport/


cd /home/url-fuzzing/
git pull

cp -r /home/url-fuzzing/tribble-additions/* /home/tribble/src/main/scala/saarland/cispa/se/tribble/execution

echo "building tribble"
cd /home/tribble
./gradlew build >>/tmp/output/tribblebuild.txt
mv ./build/libs/tribble-0.1.jar tribble.jar

java -jar tribble.jar generate --mode=2-path-30 --suffix=.md --grammar-file=/home/grammar/livingstandard-url.scala --out-dir=/home/firefoxfuzzing/URLTestFiles >>/tmp/output/tribblegen.txt

cd /home/url-fuzzing/firefox
python urlfileconversion.py -dir /home/firefoxfuzzing/URLTestFiles

cp -r /home/firefoxfuzzing/URLTestFiles /mozilla-unified/netwerk/test/URLTestFiles
cd /mozilla-unified

./mach test ./netwerk/test/URLTestFiles
grcov ./mozilla-unified -t lcov >lcov.info
genhtml -o /home/coverageReport --show-details --highlight --ignore-errors source --legend lcov.info
