FROM ubuntu:18.04

RUN apt-get update && apt-get install -y wget python clang llvm git lcov mercurial python3 python3-pip python3-venv libnotify-bin openjdk-8-jdk openjdk-8-source python curl


## url-fuzzing
WORKDIR /home
RUN git clone https://github.com/s9varesc/url-fuzzing.git
WORKDIR /

## Tribble
RUN apt-get install -y openjdk-8-jdk openjdk-8-source
WORKDIR /home
RUN git clone https://github.com/havrikov/tribble.git
WORKDIR /home/tribble
RUN git checkout 7797acd8801e48cbedb86485032f577cee8ea94c
WORKDIR /home/tribble
RUN ./gradlew build

WORKDIR /home/tribble
RUN ./gradlew build 


## clone firefox
WORKDIR /home
RUN hg clone https://hg.mozilla.org/mozilla-unified

## prepare Stand-Alone Parsers
COPY ./combined/*.sh /home/prep/
COPY ./resources/prep*.sh /home/prep/
RUN chmod a+rx /home/prep/*.sh 

WORKDIR /home/instrumenting
COPY ./languagefuzzing/*.sh /home/instrumenting/
RUN chmod a+rx /home/instrumenting/*.sh  

COPY ./resources/*.sh /home/resources/
RUN chmod a+rx /home/resources/*.sh  



## prepare Firefox

COPY ./firefox/complete/mozconfig.txt /home/resources/.mozconfig

RUN apt-get update -y
RUN /home/prep/prepff.sh
RUN apt-get install -y cargo 
RUN PATH=$PATH:/root/.cargo/bin
RUN SHELL=/bin/bash
RUN export SHELL
RUN cargo install --version 0.5.15 grcov

## prepare languages
RUN /home/prep/prepLanguages.sh


## prepare Chromium
RUN /home/prep/prepchr.sh




VOLUME ["/home/coverageReports"]

ENTRYPOINT ["/home/resources/executeFuzzingAll.sh"]