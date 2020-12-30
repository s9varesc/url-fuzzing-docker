#!/bin/bash

# expected arguments: grammar representations tribble-mode tribble-out-dir
grammar="$1"
representations="$2"
tribble-mode="$3"
tribble-out-dir="$4"

cd /home/url-fuzzing/

cp -r /home/url-fuzzing/tribble-additions/componentExtraction /home/tribble/src/main/scala/saarland/cispa/se/tribble/execution/componentExtraction
cp /home/url-fuzzing/tribble-additions/$representations/* /home/tribble/src/main/scala/saarland/cispa/se/tribble/execution

echo "building tribble"
cd /home/tribble
./gradlew build >>/home/tmp/output/tribblebuild.txt
mv ./build/libs/tribble-0.1.jar tribble.jar

java -jar tribble.jar generate --mode=$tribble-mode --suffix=.md --grammar-file=$grammar --out-dir=$tribble-out-dir >>/home/tmp/output/tribblegen.txt


