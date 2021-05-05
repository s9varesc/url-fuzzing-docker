FROM ubuntu:18.04

RUN apt-get -qq update && apt-get install -qq -y wget python clang=1:6.0-41~exp5~ubuntu1 llvm=1:6.0-41~exp5~ubuntu1 git lcov mercurial=4.5.3-1ubuntu2.1 python3=3.6.7-1~18.04 python3-venv=3.6.7-1~18.04 python3-pip=9.0.1-2.3~ubuntu1.18.04.4 libnotify-bin=0.7.7-3 openjdk-8-jdk openjdk-8-source curl moreutils

RUN apt-get -qq install -y locales locales-all && locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8

ENV LANG='en_US.UTF-8' LANGUAGE='en_US.UTF-8'


## url-fuzzing
WORKDIR /home
RUN git clone https://github.com/s9varesc/url-fuzzing.git
WORKDIR /

## Tribble
RUN apt-get install -y openjdk-11-jdk openjdk-11-source
RUN wget https://download.java.net/java/GA/jdk9/9.0.4/binaries/openjdk-9.0.4_linux-x64_bin.tar.gz && tar xvf openjdk-9*_bin.tar.gz && mv jdk* /usr/lib/jvm
WORKDIR /home
RUN git clone https://github.com/havrikov/tribble.git
WORKDIR /home/tribble
RUN git checkout 6ae1e364d364fe172d4bba4fda88c06c2ac1fec3
WORKDIR /home/tribble
RUN JAVA_HOME='/usr/lib/jvm/jdk-9.0.4' ./gradlew assemble 


## prepare Stand-Alone Parsers

COPY ./resources/prep*.sh /home/prep/
RUN chmod a+rx /home/prep/*.sh 

WORKDIR /home/instrumenting
COPY ./languagefuzzing/*.sh /home/instrumenting/
RUN chmod a+rx /home/instrumenting/*.sh  

COPY ./resources/*.sh /home/resources/
RUN chmod a+rx /home/resources/*.sh  


## prepare languages
RUN /home/prep/prepLanguages.sh


## prepare Firefox

COPY ./firefox/mozconfig.txt /home/resources/.mozconfig

RUN apt-get update -y
RUN /home/prep/prepff.sh
RUN apt-get install -y cargo 
RUN PATH=$PATH:/root/.cargo/bin
RUN SHELL=/bin/bash
RUN export SHELL
RUN cargo install --version 0.5.15 grcov




## prepare Chromium
RUN apt-get install -y python python-dev python-pip python-setuptools
RUN /home/prep/prepchr.sh




VOLUME ["/home/coverageReports"]

ENTRYPOINT ["/home/resources/setupandrun.sh", "all"]
CMD ["/home/url-fuzzing/grammars/livingstandard-url.scala", "2-path-30", "y", "y"]