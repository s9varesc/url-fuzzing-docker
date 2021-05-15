#!/bin/bash

# create a nice representation of the results

echo "finalizing results"

cd /home/url-fuzzing/evaluation-tools
pip3 install markdown bs4 lxml -q 

python3 exceptioneval.py -dir /home/coverageReports/Exceptions
python3 produceResultPresentation.py -data /home/coverageReports/evaldata
cp style.css /home/coverageReports/

echo "done"
