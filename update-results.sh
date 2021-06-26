#!/bin/bash

prev_location=$pwd
cd /home/url-fuzzing-results
git add ./
git commit -m "update results"
git pull
git push
cd $prev_location