#!/bin/bash


mkdir -p /home/coverageReports/Python
mkdir -p /home/coverageReports/C
mkdir -p /home/coverageReports/Cpp
mkdir -p /home/coverageReports/Java
mkdir -p /home/coverageReports/JavaScript
mkdir -p /home/coverageReports/Ruby
mkdir -p /home/coverageReports/Go
mkdir -p /home/coverageReports/PHP
mkdir -p /home/coverageReports/Exceptions


cd /home/url-fuzzing/
git pull

cp -r /home/url-fuzzing/tribble-additions/* /home/tribble/src/main/scala/saarland/cispa/se/tribble/execution

cd /home/tribble
./gradlew build
mv ./build/libs/tribble-0.1.jar tribble.jar
mkdir /home/test
java -jar tribble.jar generate --mode=2-path-30 --suffix=.md --grammar-file=/home/url-fuzzing/livingstandard-url.scala --out-dir=/home/url-fuzzing/languagefuzzing/urls

cd /home/url-fuzzing/languagefuzzing/
python generatePlainURLs.py


echo "fuzzing Python"
cd /home/url-fuzzing/languagefuzzing/PythonCoverage
coverage run -L TestPythonMain.py
coverage html

cp -r htmlcov/* /home/coverageReports/Python/
cp ./PythonExceptions.txt /home/coverageReports/Exceptions/

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
/home/instrumenting/instrumentJava.sh
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



