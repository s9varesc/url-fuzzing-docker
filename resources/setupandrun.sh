#!/bin/bash

# expected arguments: fuzz_target 

fuzz_target="$1"
task="$2"

cd /home/url-fuzzing
git pull
cd /home/resources

if [[ "$task" == "generateAndTest" ]]
then
	# interpret remaining args as grammar and mode
	grammar="$3"
	tribble_mode="$4" 
	tribble_out_dir="/home/URLTestFilesRaw"
	/home/resources/generateAndExecuteFuzzing.sh $fuzz_target $grammar "$tribble_mode" $tribble_out_dir | ts -s '[%H:%M:%S]'
elif [[ "$task" == "test" ]]
then 
	# interpret remaining args as components and test_dir
	components_created="$3"
	test_dir="/home/test-files"
	/home/resources/executeFuzzing.sh $fuzz_target $components_created $test_dir | ts -s '[%H:%M:%S]'
else
	# unkown task
	echo "unkown value \"$task\", possible values are \"generateAndTest\" or \"test\" "
fi






