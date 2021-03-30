#!/bin/bash

apt-get update

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
apt-get install -y --fix-missing ruby=1:2.5.1 ruby-bundler=1.16.1-1

## JavaScript
echo "preparing JavaScript"
curl -sL https://deb.nodesource.com/setup_15.x | bash -
apt-get install -y  nodejs --fix-missing
npm install -g n
n 10
PATH="$PATH"
cd /home/url-fuzzing/languagefuzzing/JavaScriptCoverage

npm install -g --save-dev istanbul@0.4.5 nyc@15.1.0 mocha@8.3.2

npm install  whatwg-url@8.5.0 urijs@1.19.6
 

PATH="$PATH"
export PATH

##Python
pip3 install coverage

## PHP
echo "preparing PHP"
cd /home
DEBIAN_FRONTEND=noninteractive apt-get install -y php7.2-cli php-xdebug=2.6.0-0ubuntu1 phpunit=6.5.5-1ubuntu2 composer=1.6.3-1 php7.2-intl
cd /home/url-fuzzing/languagefuzzing/PHPCoverage
sh -c "echo 'precedence ::ffff:0:0/96 100'>> /etc/gai.conf"
composer --prefer-source require league/uri
composer --prefer-source require league/uri-interfaces
composer --prefer-source require ext-intl
## Go
echo "preparing Go" 
cd /home
apt-get install -y golang-go=2:1.10~4ubuntu1
rm /usr/lib/go/src/net/url/url_test.go

## instrument and prepare libs that can't be (easily) instrumented on the fly
/home/instrumenting/instrumentC.sh
/home/instrumenting/instrumentCpp.sh 
/home/instrumenting/instrumentRuby.sh
