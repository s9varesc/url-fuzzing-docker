#!/bin/bash

echo "fuzzing languages"
/home/resources/executeFuzzinglanguages.sh
echo "fuzzing chromium"
/home/resources/executeFuzzingchr.sh
echo "fuzzing firefox"
/home/resources/executeFuzzingff.sh

