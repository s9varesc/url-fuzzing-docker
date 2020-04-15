#!/bin/bash

cd /home/poco
mkdir cmake-build
cd cmake-build
make ..
cmake -H/home/poco -B/home/poco/cmake-build -DCMAKE_CXX_FLAGS=-coverage -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_FLAGS=-coverage

cmake --build . --target install
LD_LIBRARY_PATH=/usr/local/lib
export LD_LIBRARY_PATH
