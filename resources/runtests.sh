#!/bin/bash


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


#expected inputs: fuzz_target comp_created test_dir

fuzz_target="$1"
comp_created="$2"
test_dir="$3"

echo "fuzzing targets $fuzz_target "

if [[ "$fuzz_target" == "all" || "$fuzz_target" == "firefox" ]]
then
	echo "fuzzing firefox"
	cd /home/resources
	./fuzzff.sh $comp_created $test_dir
fi

if [[ "$fuzz_target" == "all" || "$fuzz_target" == "chromium" ]]
then
	echo "fuzzing chromium"
	cd /home/resources
	./fuzzchr.sh $comp_created $test_dir
fi

if [[ "$fuzz_target" == "all" || "$fuzz_target" == "languages" ]]
then
	echo "fuzzing languages"
	cd /home/resources
	./fuzzlanguages.sh $test_dir
fi