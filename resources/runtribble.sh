#!/bin/bash

# expected arguments: grammar representations tribble_mode tribble_out_dir
grammar="$1"
representations="$2"
tribble_mode="$3"
tribble_out_dir="$4"

cd /home/url-fuzzing/
git pull

#check if there is a different tribble version available in the mounted dir /home/mountedtribble
if [ -d "/home/mountedtribble/tribble" ]; then
  # use this version instead: allows to use experimental features
  echo "using alternative tribble version"
  rm -r /home/tribble
  cp -r /home/mountedtribble/tribble /home/tribble 
fi


mkdir -p /home/tribble/tribble-tool/src/main/scala/de/cispa/se/tribble/componentExtraction
cp -r /home/url-fuzzing/tribble-additions/componentExtraction/* /home/tribble/tribble-tool/src/main/scala/de/cispa/se/tribble/componentExtraction
cp /home/url-fuzzing/tribble-additions/$representations/* /home/tribble/tribble-tool/src/main/scala/de/cispa/se/tribble
cp /home/url-fuzzing/tribble-additions/Main.scala /home/tribble/tribble-tool/src/main/scala/de/cispa/se/tribble

echo "building tribble"
cd /home/tribble
./gradlew build  >>/home/tmp/output/tribblebuild.txt
mv ./tribble-tool/build/libs/tribble*.jar tribble.jar


echo "create inputs from $grammar "
java -jar tribble.jar generate --mode=$tribble_mode --suffix=.md --grammar-file=$grammar --out-dir=$tribble_out_dir >>/home/tmp/output/tribblegen.txt


