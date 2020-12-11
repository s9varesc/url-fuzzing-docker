#!/bin/bash

echo "generating URLs"
/home/resources/runtribbleAll.sh

echo "fuzzing languages"
/home/resources/fuzzlanguages.sh
echo "fuzzing chromium"
/home/resources/fuzzchr.sh

echo "fuzzing firefox"
/home/resources/fuzzff.sh

echo "finalizing output"
/home/resources/finalizeoutputAll.sh #TODO