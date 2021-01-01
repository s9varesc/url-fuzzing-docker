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

echo "generate inputs"
mkdir -p /home/tmp/output
./runtribble.sh $grammar $representations $tribble_mode $tribble_out_dir

echo "fuzzing targets $fuzz_targets "

if [[ "$fuzz_targets" == "all" || "$fuzz_targets" == "firefox" ]]
then
	./fuzzff.sh $comp_created $tribble_out_dir
fi

if [[ "$fuzz_targets" == "all" || "$fuzz_targets" == "chromium" ]]
then
	./fuzzchr.sh $comp_created $tribble_out_dir
fi

if [[ "$fuzz_targets" == "all" || "$fuzz_targets" == "languages" ]]
then
	./fuzzlanguages.sh $tribble_out_dir
fi

./finalizeOutput.sh



