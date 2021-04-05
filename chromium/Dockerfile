FROM ubuntu:18.04

RUN apt-get -qq update && apt-get -qq install -y wget python clang llvm git lcov mercurial=4.5.3-1ubuntu2.1 python3=3.6.7-1~18.04 python3-venv=3.6.7-1~18.04 python3-pip=9.0.1-2.3~ubuntu1.18.04.4 libnotify-bin=0.7.7-3 openjdk-8-jdk openjdk-8-source python curl

RUN apt-get -qq install -y locales locales-all
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8


## url-fuzzing
WORKDIR /home
RUN git clone https://github.com/s9varesc/url-fuzzing.git
WORKDIR /

## Tribble
#RUN apt-get install -y openjdk-8-jdk openjdk-8-source
WORKDIR /home
RUN git clone https://github.com/havrikov/tribble.git
WORKDIR /home/tribble
RUN git checkout 7797acd8801e48cbedb86485032f577cee8ea94c
WORKDIR /home/tribble
RUN ./gradlew build

WORKDIR /home/tribble
RUN ./gradlew build 


COPY ./resources/prep*.sh /home/prep/
RUN chmod a+rx /home/prep/*.sh 

COPY ./resources/*.sh /home/resources/
RUN chmod a+rx /home/resources/*.sh  

## prepare Chromium
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq install --fix-missing -y lsb-release sudo tzdata 
RUN /home/prep/prepchr.sh

VOLUME ["/home/coverageReports"]

ENTRYPOINT ["/home/resources/executeFuzzing.sh", "chromium"]
CMD ["/home/url-fuzzing/grammars/livingstandard-url.scala", "2-path-30", "/home/URLTestFilesRaw"]