FROM ubuntu:18.04

RUN apt-get -qq update && apt-get -qq install -y wget python clang llvm git lcov mercurial=4.5.3-1ubuntu2.1 python3=3.6.7-1~18.04 python3-venv=3.6.7-1~18.04 python3-pip libnotify-bin=0.7.7-3 openjdk-8-jdk openjdk-8-source python curl moreutils

RUN apt-get -qq install -y locales locales-all && locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8

ENV LANG='en_US.UTF-8' LANGUAGE='en_US.UTF-8'


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

## prepare Chromium
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq install --fix-missing -y lsb-release sudo tzdata 
RUN /home/prep/prepchr.sh

COPY ./resources/*.sh /home/resources/
RUN chmod a+rx /home/resources/*.sh  



VOLUME ["/home/coverageReports"]

ENTRYPOINT ["/home/resources/setupandrun.sh", "chromium"]
# commandline arguments to also run tribble: task grammar-location tribble-mode
CMD ["generateAndTest", "/home/url-fuzzing/grammars/livingstandard-url.scala", "2-path"]
# commandline arguments to use tests from a directory: task component-files, mount testfile-dir to /home/test-files
# CMD ["test", "y"]