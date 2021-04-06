#!/bin/bash

# expected arguments: fuzz_target grammar tribble_mode tribble_out_dir

fuzz_target="$1"
grammar="$2"
tribble_mode="$3"
tribble_out_dir="$4"

# check which representations should be produced / which grammar is used; component representations only available for livingstandard-url.scala

representations="onlyPlain"
if [[ "$fuzz_target" == "all" ]]
then
	representations="allRepresentations"
fi

if [[ "$fuzz_target" == "firefox" ]]
then
	representations="onlyFirefoxComponents"
fi

if [[ "$fuzz_target" == "chromium" ]]
then
	representations="onlyChromiumComponents"
fi

comp_created="yes"
if [[ "$grammar" != "/home/url-fuzzing/grammars/livingstandard-url.scala" ]]  #TODO create grammar dir, move grammars
then
	comp_created="no"
	representations="onlyPlain"
fi
echo "prepare result locations"
if [ -d "/home/coverageReports/Exceptions" ]
then
	rm -r /home/coverageReports/Exceptions
fi
if [ -d "/home/coverageReports/evaldata" ]
then
	rm -r /home/coverageReports/evaldata
fi
rm /home/coverageReports/*overview.html

mkdir -p /home/coverageReports/Exceptions
mkdir -p /home/coverageReports/evaldata

echo "generate inputs"
mkdir -p /home/tmp/output
cd /home/resources
./runtribble.sh $grammar $representations $tribble_mode $tribble_out_dir

echo "fuzzing targets $fuzz_target "

if [[ "$fuzz_target" == "all" || "$fuzz_target" == "firefox" ]]
then
	echo "fuzzing firefox"
	cd /home/resources
	./fuzzff.sh $comp_created $tribble_out_dir
fi

if [[ "$fuzz_target" == "all" || "$fuzz_target" == "chromium" ]]
then
	echo "fuzzing chromium"
	cd /home/resources
	./fuzzchr.sh $comp_created $tribble_out_dir
fi

if [[ "$fuzz_target" == "all" || "$fuzz_target" == "languages" ]]
then
	echo "fuzzing languages"
	cd /home/resources
	./fuzzlanguages.sh $tribble_out_dir
fi

cd /home/resources
./finalizeOutput.sh



