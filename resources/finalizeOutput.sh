#!/bin/bash

# create a nice representation of the results

echo "finalizing results"

cd /home/url-fuzzing/evaluation-tools
pip3 install markdown -q

if [ -d "/home/coverageReports/firefox" ]
then
	python browseroutputcleanup.py -dir /home/coverageReports/firefox
	mv /home/coverageReports/firefox/firefoxExceptions.txt /home/coverageReports/Exceptions/			#TODO check naming, robustness: missing file, fuzzy naming ie *firefox*Exceptions.txt
	mv /home/coverageReports/firefox/firefoxErrors.txt /home/coverageReports/Exceptions/
fi

if [ -d "/home/coverageReports/chromium" ]
then 
	python browseroutputcleanup.py -dir /home/coverageReports/chromium
	mv /home/coverageReports/chromium/chromiumExceptions.txt /home/coverageReports/Exceptions/			#TODO see above
	mv /home/coverageReports/chromium/chromiumErrors.txt /home/coverageReports/Exceptions/
fi

python3 exceptioneval.py -dir /home/coverageReports/Exceptions
python3 produceResultPresentation.py -data /home/coverageReports/evaldata
cp style.css /home/coverageReports/

