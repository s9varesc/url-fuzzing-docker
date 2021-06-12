#!/bin/bash

# expected arguments: fuzz_target grammar tribble_mode tribble_out_dir evaluate

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


comp_created="y"
if [[ "$grammar" != "/home/url-fuzzing/grammars/livingstandard-url.scala" ]]  
then
	comp_created="n"
	representations="onlyPlain"
fi


echo "generate inputs"
mkdir -p /home/tmp/output
cd /home/resources
./runtribble.sh $grammar $representations "$tribble_mode" $tribble_out_dir

#./runtests.sh $fuzz_target $comp_created $tribble_out_dir 
./executeFuzzing.sh $fuzz_target $comp_created $tribble_out_dir








