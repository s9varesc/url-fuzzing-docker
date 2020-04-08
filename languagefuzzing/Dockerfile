FROM ubuntu:18.04


RUN apt-get update





## Python
RUN apt-get install -y python3 python-pip
RUN pip install coverage

## Git
RUN apt-get install -y git

##clone url-fuzzing repository
WORKDIR /home
RUN git clone https://github.com/s9varesc/url-fuzzing.git
WORKDIR /

## C
WORKDIR /home
RUN apt-get install -y lcov
RUN git clone https://github.com/uriparser/uriparser.git 
WORKDIR /home/uriparser
RUN git checkout a50e789733c105765fbae413f040c2178added34
WORKDIR /
RUN apt-get install -y cmake libgtest-dev doxygen graphviz


## C++
WORKDIR /home
RUN git clone https://github.com/pocoproject/poco.git
WORKDIR /home/poco
RUN git checkout 3fc3e5f5b8462f7666952b43381383a79b8b5d92

## Java
WORKDIR /home
RUN apt-get install -y openjdk-8-jdk openjdk-8-source
RUN git clone https://github.com/wrobelm/jcov-build.git
WORKDIR /home/jcov-build
RUN git checkout 084adeae975d1eb1bc93a6b0083876daf0800309

## Ruby
RUN apt-get install -y ruby ruby-bundler

## JavaScript
RUN apt-get install -y npm
WORKDIR /home/url-fuzzing/languagefuzzing/JavaScriptCoverage
RUN npm install urijs

RUN npm install -g istanbul

## PHP
WORKDIR /home
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y php7.2-cli php-xdebug phpunit composer
WORKDIR /home/url-fuzzing/languagefuzzing/PHPCoverage
RUN sh -c "echo 'precedence ::ffff:0:0/96 100'>> /etc/gai.conf"
RUN composer --prefer-source require league/uri

## Go
WORKDIR /home
RUN apt-get install -y golang-go

## Prepare Tribble  TODO

## instrument and prepare libs that can't be (easily) instrumented on the fly				
WORKDIR /home/instrumenting
COPY *.sh /home/instrumenting/

RUN chmod a+rx /home/instrumenting/*.sh  
RUN /home/instrumenting/instrumentC.sh
RUN /home/instrumenting/instrumentCpp.sh ##TODO include again
RUN /home/instrumenting/instrumentJava.sh
RUN /home/instrumenting/instrumentRuby.sh


VOLUME ["/home/coverageReports"]

ENTRYPOINT ["/home/instrumenting/executeFuzzing.sh"]


