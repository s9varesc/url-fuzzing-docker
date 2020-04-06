#!/bin/bash


cd /usr/src/gtest
cmake CMakeLists.txt
make
cp *.a /usr/lib/


cd /home/uriparser
./configure
cmake -DCMAKE_BUILD_TYPE=Debug -DURIPARSER_BUILD_TESTS=OFF -DCMAKE_C_FLAGS=--coverage

