#!/bin/bash

cd /home
mkdir url-fuzzing/languagefuzzing/JavaCoverage/libs/
cp jcov-build/jcov_30_built_jar/jcov.jar url-fuzzing/languagefuzzing/JavaCoverage/libs/

apt-get install -y unzip
cd  /usr/lib/jvm/openjdk-8
unzip src.zip

cd /home/url-fuzzing/languagefuzzing/JavaCoverage
java -Xmx128M -jar libs/jcov.jar JREInstr -im java.net -implantrt libs/jcov.jar /usr/lib/jvm/java-8-openjdk-*/jre/ 
