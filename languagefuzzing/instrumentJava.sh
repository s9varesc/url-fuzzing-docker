#!/bin/bash

cd /home
mkdir url-fuzzing/languagefuzzing/JavaCoverage/libs/
cp jcov-build/jcov_30_built_jar/jcov.jar url-fuzzing/languagefuzzing/JavaCoverage/libs/

cd /home/url-fuzzing/languagefuzzing/JavaCoverage
java -Xmx128M -jar libs/jcov.jar JREInstr -im java.net -implant libs/jcov.jar /usr/lib/jvm/java-8-openjdk-*/jre/ 
