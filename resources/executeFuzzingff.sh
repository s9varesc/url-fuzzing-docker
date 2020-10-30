#!/bin/bash

echo "preparing"
/home/resources/outputprepff.sh

echo "generating URLs"
/home/resources/runtribbleff.sh

echo "fuzzing"
/home/resources/fuzzff.sh

echo "finalizing output"
/home/resources/finalizeoutputff.sh