#!/bin/bash

echo "preparing"
/home/resources/outputpreplanguages.sh

echo "generating URLs"
/home/resources/runtribblelanguages.sh

echo "fuzzing"
/home/resources/fuzzlanguages.sh

echo "finalizing output"
/home/resources/finalizeoutputlanguages.sh