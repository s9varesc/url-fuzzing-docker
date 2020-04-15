#!/bin/bash

cd /home/poco
mkdir cmake-build
cd cmake-build
make .. >>/home/coverageReports/output/pocomake.txt
cmake -H/home/poco -B/home/poco/cmake-build -DCMAKE_CXX_FLAGS=-coverage -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_FLAGS=-coverage >>/home/coverageReports/output/pococmake.txt

cmake --build . --target install >>/home/coverageReports/output/pococmake2.txt
LD_LIBRARY_PATH=/usr/local/lib
export LD_LIBRARY_PATH
