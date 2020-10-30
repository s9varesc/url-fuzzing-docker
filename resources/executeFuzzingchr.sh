#!/bin/bash

echo "preparing"
/home/resources/outputprepchr.sh

echo "generating URLs"
/home/resources/runtribblechr.sh

echo "fuzzing"
/home/resources/fuzzchr.sh

echo "finalizing output"
/home/resources/finalizeoutputchr.sh