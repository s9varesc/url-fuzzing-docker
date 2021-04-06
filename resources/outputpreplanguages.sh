#!/bin/bash

if [ -d "/home/coverageReports/Python" ]
then
	rm -r /home/coverageReports/Python
fi
mkdir -p /home/coverageReports/Python
if [ -d "/home/coverageReports/C" ]
then
	rm -r /home/coverageReports/C
fi
mkdir -p /home/coverageReports/C
if [ -d "/home/coverageReports/Cpp" ]
then
	rm -r /home/coverageReports/Cpp
fi
mkdir -p /home/coverageReports/Cpp
if [ -d "/home/coverageReports/Java" ]
then
	rm -r /home/coverageReports/Java
fi
mkdir -p /home/coverageReports/Java
if [ -d "/home/coverageReports/JavaScript" ]
then
	rm -r /home/coverageReports/JavaScript
fi
mkdir -p /home/coverageReports/JavaScript/urijs
mkdir -p /home/coverageReports/JavaScript/whatwg-url
if [ -d "/home/coverageReports/Ruby" ]
then
	rm -r /home/coverageReports/Ruby
fi
mkdir -p /home/coverageReports/Ruby
if [ -d "/home/coverageReports/Go" ]
then
	rm -r /home/coverageReports/Go
fi
mkdir -p /home/coverageReports/Go
if [ -d "/home/coverageReports/PHP" ]
then
	rm -r /home/coverageReports/PHP
fi
mkdir -p /home/coverageReports/PHP
mkdir -p /home/coverageReports/output



rm /home/coverageReports/output/*.txt
