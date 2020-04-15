#!/bin/bash


cd /usr/src/gtest
cmake CMakeLists.txt >>/home/coverageReports/output/gtestcmake.txt
make >>/home/coverageReports/output/gtestmake.txt
cp *.a /usr/lib/


cd /home/uriparser
./configure >>/home/coverageReports/output/uriparserconfigure.txt
cmake -DCMAKE_BUILD_TYPE=Debug -DURIPARSER_BUILD_TESTS=OFF -DCMAKE_C_FLAGS=--coverage >>/home/coverageReports/output/uriparsercmake.txt
make install >>/home/coverageReports/output/uriparsermake.txt

