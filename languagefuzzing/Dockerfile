FROM ubuntu:18.04

RUN apt-get update && apt-get install -y wget clang-6.0 llvm-6.0 git lcov=1.13-3 mercurial=4.5.3-1ubuntu2.1 python3=3.6.7-1~18.04 python3-venv=3.6.7-1~18.04 libnotify-bin=0.7.7-3 openjdk-8-jdk openjdk-8-source curl


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
COPY ./resources/prep*.sh /home/prep/
RUN chmod a+rx /home/prep/*.sh 

WORKDIR /home/instrumenting
COPY ./languagefuzzing/*.sh /home/instrumenting/
RUN chmod a+rx /home/instrumenting/*.sh  

COPY ./resources/*.sh /home/resources/
RUN chmod a+rx /home/resources/*.sh  

RUN /home/prep/prepLanguages.sh


VOLUME ["/home/coverageReports"]


ENTRYPOINT ["/home/resources/executeFuzzing.sh", "languages"]
CMD ["/home/url-fuzzing/grammars/livingstandard-url.scala", "2-path-30", "/home/URLTestFilesRaw"]