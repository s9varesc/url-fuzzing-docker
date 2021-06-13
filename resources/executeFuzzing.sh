#!/bin/bash

# expected arguments: fuzz_target comp_created test_dir
fuzz_target="$1"
comp_created="$2"
test_dir="$3"



./runtests.sh $fuzz_target $comp_created $test_dir 

cd /home/resources
./finalizeOutput.sh






