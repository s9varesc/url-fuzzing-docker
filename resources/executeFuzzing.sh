#!/bin/bash

# expected arguments: fuzz-target grammar tribble-mode tribble-out-dir

fuzz-target="$1"
grammar="$2"
tribble-mode="$3"
tribble-out-dir="$4"

# check which representations should be produced / which grammar is used; component representations only available for livingstandard-url.scala

representations="onlyPlain"
if [[ "$fuzz-target" == "all" ]]
then
	representations="allRepresentations"
fi

if [[ "$fuzz-target" == "firefox" ]]
then
	representations="onlyFirefoxComponents"
fi

if [[ "$fuzz-target" == "chromium" ]]
then
	representations="onlyChromiumComponents"
fi

comp-created="yes"
if [[ "$grammar" != "/home/url-fuzzing/grammars/livingstandard-url.scala" ]]  #TODO create grammar dir, move grammars
then
	comp-created="no"
	representations="onlyPlain"
fi

echo "generate inputs"
mkdir -p /home/tmp/output
./runtribble.sh $grammar $representations $tribble-mode $tribble-out-dir

echo "fuzzing targets $fuzz-targets "

if [[ "$fuzz-targets" == "all" || "$fuzz-targets" == "firefox" ]]
then
	./fuzzff.sh $comp-created $tribble-out-dir
fi

if [[ "$fuzz-targets" == "all" || "$fuzz-targets" == "chromium" ]]
then
	./fuzzchr.sh $comp-created $tribble-out-dir
fi

if [[ "$fuzz-targets" == "all" || "$fuzz-targets" == "languages" ]]
then
	./fuzzlanguages.sh $tribble-out-dir
fi

./finalizeOutput.sh



