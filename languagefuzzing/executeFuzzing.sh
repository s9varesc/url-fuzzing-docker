#!/bin/bash


mkdir /home/coverageReports/Python
mkdir /home/coverageReports/C
mkdir /home/coverageReports/Cpp
mkdir /home/coverageReports/Java
mkdir /home/coverageReports/JavaScript
mkdir /home/coverageReports/Ruby
mkdir /home/coverageReports/Go
mkdir /home/coverageReports/PHP


cd /home/url-fuzzing/
git pull

cp -r /home/url-fuzzing/tribble-additions/* /home/tribble/src/main/scala/saarland/cispa/se/tribble/execution
cd /home/tribble
./gradlew build
mv ./build/libs/tribble-0.1.jar tribble.jar
java -jar tribble.jar --help


echo "fuzzing Python"
cd /home/url-fuzzing/languagefuzzing/PythonCoverage
coverage run -L TestPythonMain.py
coverage html

cp -r htmlcov/* /home/coverageReports/Python/

echo "fuzzing C"
cd /home/url-fuzzing/languagefuzzing/CCoverage
cd src
gcc --coverage -L /home/uriparser TestCMain.c -o TestCMain -luriparser
LD_LIBRARY_PATH=/usr/local/lib
export LD_LIBRARY_PATH
./TestCMain
lcov -c --directory /home/uriparser/CMakeFiles/uriparser.dir/src/ --output-file main_coverage.info
genhtml main_coverage.info --output-directory coverage

cp -r coverage/* /home/coverageReports/C/

echo "fuzzing Cpp"
cd /home/url-fuzzing/languagefuzzing/CppCoverage
g++ -g -coverage -o TestCppMain TestCppMain.cpp -lPocoFoundationd
LD_LIBRARY_PATH=/usr/local/lib
export LD_LIBRARY_PATH
./TestCppMain
lcov -c --directory /home/poco/cmake-build/Foundation/CMakeFiles/Foundation.dir/src/ --output-file=main_coverage.info
genhtml main_coverage.info --output-directory coverage

cp -r coverage/* /home/coverageReports/Cpp/ 

echo "fuzzing Java"
cd /home/url-fuzzing/languagefuzzing/JavaCoverage
mkdir classes
javac TestJavaMain.java  -d ./classes
java -javaagent:/home/url-fuzzing/languagefuzzing/JavaCoverage/libs/jcov.jar=im=java.net -cp ./classes TestJavaMain
java -cp /home/url-fuzzing/languagefuzzing/JavaCoverage/libs/jcov.jar com.sun.tdk.jcov.RepGen -include java.net.* -src /usr/lib/jvm/openjdk-8/src -format html -output report result.xml

cp -r report/* /home/coverageReports/Java/

echo "fuzzing Ruby"
cd /home/url-fuzzing/languagefuzzing/RubyCoverage
ruby -W0 test_helper.rb

cp -r coverage/* /home/coverageReports/Ruby/

echo "fuzzing JavaScript"
cd /home/url-fuzzing/languagefuzzing/JavaScriptCoverage
istanbul cover --report=html --no-default-excludes -x TestJavaScriptMain.js TestJavaScriptMain.js

cp -r coverage/* /home/coverageReports/JavaScript/

echo "fuzzing PHP"
cd /home/url-fuzzing/languagefuzzing/PHPCoverage
phpunit --whitelist ./vendor/league/uri/src/UriString.php --coverage-html coverage PHPMainTest.php

cp -r coverage/* /home/coverageReports/PHP/

echo "fuzzing Go"
cd /home/url-fuzzing/languagefuzzing/GoCoverage
mkdir coverage
go test -coverprofile=urlcoverage.out net/url
go tool cover -html=urlcoverage.out -o coverage/index.html

cp -r coverage/* /home/coverageReports/Go/

ls /home/coverageReports/*

