#!/bin/bash

# expected argument: input_dir
input_dir="$1"

/home/resources/outputpreplanguages.sh
cd /home/url-fuzzing/languagefuzzing/
python generatePlainURLs.py -dir "$input_dir"/plain			
cp ./urls/plainURLs /home/coverageReports/Exceptions/

echo "fuzzing Python"
apt-get update
apt-get install -y python3-pip 
pip3 install coverage
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
lcov -c --directory /home/uriparser/CMakeFiles/uriparser.dir/src/ --output-file main_coverage.info >>/home/coverageReports/output/lcovcout.txt
genhtml main_coverage.info --output-directory coverage >>/home/coverageReports/output/lcovcout.txt


cp -r coverage/* /home/coverageReports/C/
cp ./CExceptions.txt /home/coverageReports/Exceptions/

echo "fuzzing Cpp"
cd /home/url-fuzzing/languagefuzzing/CppCoverage
g++ -g -coverage -o TestCppMain TestCppMain.cpp -lPocoFoundationd
LD_LIBRARY_PATH=/usr/local/lib
export LD_LIBRARY_PATH
./TestCppMain
lcov -c --directory /home/poco/cmake-build/Foundation/CMakeFiles/Foundation.dir/src/ --output-file=main_coverage.info >>/home/coverageReports/output/lcovcppout.txt
genhtml main_coverage.info --output-directory coverage >>/home/coverageReports/output/genhtmlcppout.txt

cp -r coverage/* /home/coverageReports/Cpp/ 
cp ./CppExceptions.txt /home/coverageReports/Exceptions/


echo "fuzzing Java"
/home/instrumenting/instrumentJava.sh 
cd /home/url-fuzzing/languagefuzzing/JavaCoverage
mkdir classes
javac TestJavaMain.java  -d ./classes
java -javaagent:/home/url-fuzzing/languagefuzzing/JavaCoverage/libs/jcov.jar=include=java.net -cp ./classes TestJavaMain

java -cp /home/url-fuzzing/languagefuzzing/JavaCoverage/libs/jcov.jar com.sun.tdk.jcov.RepGen -src /usr/lib/jvm/java-8-openjdk-amd64/src.zip -include java.net.*  -format html -output report/ result.xml


cp -r report/* /home/coverageReports/Java/

cp ./JavaExceptions.txt /home/coverageReports/Exceptions/

echo "fuzzing Ruby"
cd /home/url-fuzzing/languagefuzzing/RubyCoverage
ruby -W0 test_helper.rb

cp -r coverage/* /home/coverageReports/Ruby/
cp ./RubyExceptions.txt /home/coverageReports/Exceptions/

echo "fuzzing JavaScript"

cd /home/url-fuzzing/languagefuzzing/JavaScriptCoverage


nyc --reporter=html --exclude-node-modules=false -x TestJavaScriptMainurijs.js mocha ./TestJavaScriptMainurijs.js >>/home/coverageReports/output/nycurijs.txt


cp -r coverage/* /home/coverageReports/JavaScript/urijs/
rm -r coverage/

nyc --reporter=html --exclude-node-modules=false -x TestJavaScriptMainWhatwg.js mocha ./TestJavaScriptMainWhatwg.js >>/home/coverageReports/output/nycwhatwg.txt

cp -r coverage/* /home/coverageReports/JavaScript/whatwg-url/

cp ./JavaScriptExceptionsurijs.txt /home/coverageReports/Exceptions/
cp ./JavaScriptExceptionswhatwg-url.txt /home/coverageReports/Exceptions/

echo "fuzzing PHP"
cd /home/url-fuzzing/languagefuzzing/PHPCoverage
phpunit --whitelist ./vendor/league/uri/src/UriString.php --coverage-html coverage PHPMainTest.php >>/home/coverageReports/output/phpout.txt

cp -r coverage/* /home/coverageReports/PHP/
cp ./PHPExceptions.txt /home/coverageReports/Exceptions/

echo "fuzzing Go"
cd /home/url-fuzzing/languagefuzzing/GoCoverage
cp TestGoMain_test.go /usr/lib/go/src/net/url/
mkdir coverage
go test >>/home/coverageReports/output/gotest.txt
go test -coverprofile=urlcoverage.out net/url >>/home/coverageReports/output/gocovertest.txt
go tool cover -html=urlcoverage.out -o coverage/index.html >>/home/coverageReports/output/gocover.txt


cp -r coverage/* /home/coverageReports/Go/
cp /usr/lib/go/src/net/url/GoExceptions.txt /home/coverageReports/Exceptions/
