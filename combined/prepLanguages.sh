#!/bin/bash

## C   
echo "preparing C"
cd /home
apt-get install -y lcov
git clone https://github.com/uriparser/uriparser.git 
cd /home/uriparser
git checkout a50e789733c105765fbae413f040c2178added34
cd /
apt-get install -y cmake libgtest-dev doxygen graphviz


## C++
echo "preparing C++"
cd /home
git clone https://github.com/pocoproject/poco.git
cd /home/poco
git checkout 3fc3e5f5b8462f7666952b43381383a79b8b5d92

## Java
echo "preparing Java"
cd /home
apt-get install -y openjdk-8-jdk openjdk-8-source --fix-missing
git clone https://github.com/wrobelm/jcov-build.git
cd /home/jcov-build
git checkout 084adeae975d1eb1bc93a6b0083876daf0800309

## Ruby
echo "preparing Ruby"
apt-get install -y ruby ruby-bundler

## JavaScript
echo "preparing JavaScript"
apt-get install -y nodejs npm node-gyp nodejs-dev
npm install -g n
n 10
PATH="$PATH"
cd /home/url-fuzzing/languagefuzzing/JavaScriptCoverage

npm install -g istanbul nyc mocha

npm install whatwg-url urijs

PATH="$PATH"
export PATH

##Python
apt-get install -y python3 python3-pip
pip3 install coverage

## PHP
echo "preparing PHP"
cd /home
DEBIAN_FRONTEND=noninteractive apt-get install -y php7.2-cli php-xdebug phpunit composer
cd /home/url-fuzzing/languagefuzzing/PHPCoverage
sh -c "echo 'precedence ::ffff:0:0/96 100'>> /etc/gai.conf"
composer --prefer-source require league/uri

## Go
echo "preparing Go" 
cd /home
apt-get install -y golang-go

## instrument and prepare libs that can't be (easily) instrumented on the fly
/home/instrumenting/instrumentC.sh
/home/instrumenting/instrumentCpp.sh 
/home/instrumenting/instrumentRuby.sh
