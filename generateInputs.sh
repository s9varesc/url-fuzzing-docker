#!/bin/bash

# expected arguments: grammar representations tribble_mode tribble_out_dir
# available representations: allRepresentations onlyPlain onlyFirefox onlyChromium
grammar="$1"
representations="$2"
tribble_mode="$3"
tribble_out_dir="$4"

mkdir -p /home/tmp/output
apt-get install -y openjdk-11-jdk openjdk-11-source git
cd /home/url-fuzzing/
git pull

#check if there is a  tribble version available or install one
if [ ! -d "/home/tribble" ]; then
  echo "pulling tribble"
  cd /home
  git clone https://github.com/havrikov/tribble.git
  cd /home/tribble
  git checkout a1cf8cf8d46d5cd5d7e533ada96746bfac50dcc6
  update-alternatives --set java /usr/lib/jvm/java-11-openjdk-amd64/bin/java && update-alternatives --set javac /usr/lib/jvm/java-11-openjdk-amd64/bin/javac
fi

# remove previously used code additions
# first removing them and then adding them back makes a rebuild necessary for each run, but this allows to always use the newest versions of the component extraction code
# the experiment plan also relies on a single tribble run
# in case of multiple runs without changing the implementation, checking for the tribble jar and only rebuilding if its not there is favourable
if [ -d "/home/tribble/tribble-tool/src/main/scala/de/cispa/se/tribble/componentExtraction" ]; then
	rm -r /home/tribble/tribble-tool/src/main/scala/de/cispa/se/tribble/componentExtraction
fi

mkdir -p /home/tribble/tribble-tool/src/main/scala/de/cispa/se/tribble/componentExtraction
cp -r /home/url-fuzzing/tribble-additions/componentExtraction/* /home/tribble/tribble-tool/src/main/scala/de/cispa/se/tribble/componentExtraction
cp /home/url-fuzzing/tribble-additions/$representations/* /home/tribble/tribble-tool/src/main/scala/de/cispa/se/tribble
cp /home/url-fuzzing/tribble-additions/Main.scala /home/tribble/tribble-tool/src/main/scala/de/cispa/se/tribble

echo "building tribble"
cd /home/tribble
update-alternatives --set java /usr/lib/jvm/java-11-openjdk-amd64/bin/java && update-alternatives --set javac /usr/lib/jvm/java-11-openjdk-amd64/bin/javac
./gradlew build  >>/home/tmp/output/tribblebuild.txt
mv ./tribble-tool/build/libs/tribble*.jar tribble.jar


echo "create inputs from $grammar "
java -jar tribble.jar generate --mode=$tribble_mode --suffix=.md --grammar-file=$grammar --out-dir=$tribble_out_dir >>/home/tmp/output/tribblegen.txt


