#!/bin/bash


SHELL=/bin/bash
export SHELL

cd /home/url-fuzzing/
git pull

cp -r /home/url-fuzzing/tribble-additions/componentExtraction /home/tribble/src/main/scala/saarland/cispa/se/tribble/execution/componentExtraction
cp /home/url-fuzzing/tribble-additions/onlyFirefoxComponents/* /home/tribble/src/main/scala/saarland/cispa/se/tribble/execution

echo "building tribble"
cd /home/tribble
./gradlew build >>/tmp/output/tribblebuild.txt
mv ./build/libs/tribble-0.1.jar tribble.jar

echo "generating test files"
java -jar tribble.jar generate --mode=2-path-30 --suffix=.md --grammar-file=/home/url-fuzzing/livingstandard-url.scala --out-dir=/home/firefoxfuzzing/URLTestFilesRaw >>/tmp/output/tribblegen.txt
