#!/bin/bash

cd /home
mkdir url-fuzzing/languagefuzzing/JavaCoverage/libs/
cp jcov-build/jcov_30_built_jar/jcov.jar url-fuzzing/languagefuzzing/JavaCoverage/libs/

update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
update-alternatives --set javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac

cd /home/url-fuzzing/languagefuzzing/JavaCoverage
java -jar libs/jcov.jar JREInstr  -implantrt libs/jcov.jar -im java.net  /usr/lib/jvm/java-8-openjdk-amd64/jre/  
