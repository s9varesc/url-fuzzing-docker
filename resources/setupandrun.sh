#!/bin/bash

# expected arguments: fuzz_target grammar tribble_mode evaluate time

fuzz_target="$1"
grammar="$2"
tribble_mode="$3"
tribble_out_dir="/home/URLTestFilesRaw"
eval="${4:-n}"
time="${5:-y}"


if [[ "$time" == "y" ]]
then
	./executeFuzzing.sh $fuzz_target $grammar $tribble_mode $tribble_out_dir $eval | ts -s '[%H:%M:%S]'
else
	./executeFuzzing.sh $fuzz_target $grammar $tribble_mode $tribble_out_dir $eval
fi