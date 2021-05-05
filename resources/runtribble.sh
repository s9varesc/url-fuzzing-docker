#!/bin/bash

# expected arguments: grammar representations tribble_mode tribble_out_dir
grammar="$1"
representations="$2"
tribble_mode="$3"
tribble_out_dir="$4"

cd /home/url-fuzzing/
git pull

mkdir -p /home/tribble/tribble-tool/src/main/scala/de/cispa/se/tribble/componentExtraction
cp -r /home/url-fuzzing/tribble-additions/componentExtraction/* /home/tribble/tribble-tool/src/main/scala/de/cispa/se/tribble/componentExtraction
cp /home/url-fuzzing/tribble-additions/allRepresentations/* /home/tribble/tribble-tool/src/main/scala/de/cispa/se/tribble
echo "building tribble"
cd /home/tribble
JAVA_HOME='/usr/lib/jvm/jdk-9.0.4' ./gradlew assemble  >>/home/tmp/output/tribblebuild.txt
mv ./tribble-tool/build/libs/tribble*.jar tribble.jar


echo "create inputs from $grammar "
java -jar tribble.jar generate --mode=$tribble_mode --suffix=.md --grammar-file=$grammar --out-dir=$tribble_out_dir >>/home/tmp/output/tribblegen.txt


