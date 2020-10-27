FROM ubuntu:18.04

RUN apt-get update && apt-get install -y wget python clang llvm git lcov mercurial python3 python3-venv libnotify-bin openjdk-8-jdk openjdk-8-source python curl


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


## prepare Stand-Alone Parsers
COPY ./combined/*.sh /home/prep/
RUN chmod a+rx /home/prep/*.sh 

WORKDIR /home/instrumenting
COPY ./languagefuzzing/*.sh /home/instrumenting/
RUN chmod a+rx /home/instrumenting/*.sh  

COPY ./resources/*.sh /home/resources/
RUN chmod a+rx /home/resources/*.sh  

RUN /home/prep/prepLanguages.sh
## prepare Firefox

## prepare Chromium



VOLUME ["/home/coverageReports"]

ENTRYPOINT ["/home/resources/executeFuzzinglanguages.sh"]