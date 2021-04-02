FROM ubuntu:18.04

RUN apt-get update && apt-get install -y wget clang llvm git lcov mercurial=4.5.3-1ubuntu2.1 python3=3.6.7-1~18.04 python3-venv=3.6.7-1~18.04 python3-pip=9.0.1-2.3~ubuntu1.18.04.4 libnotify-bin=0.7.7-3 openjdk-8-jdk openjdk-8-source curl


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




## prepare Firefox

WORKDIR /home
RUN hg clone -r FIREFOX_87_0_RELEASE https://hg.mozilla.org/mozilla-unified ##move to prepff


#COPY ./firefox/mozconfig.txt /home/resources/.mozconfig

RUN apt-get update 								#TOOO use in all dockerfiles
RUN apt-get install -y locales locales-all
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8


COPY ./resources/prep*.sh /home/prep/
RUN chmod a+rx /home/prep/*.sh 
RUN /home/prep/prepff.sh

RUN apt-get install -y cargo
RUN PATH=$PATH:/root/.cargo/bin


RUN SHELL=/bin/bash
RUN export SHELL
RUN cargo install --version 0.5.15 grcov

COPY ./resources/*.sh /home/resources/
RUN chmod a+rx /home/resources/*.sh  




VOLUME ["/home/coverageReports"]

ENTRYPOINT ["/home/resources/executeFuzzing.sh", "firefox"]
CMD ["/home/url-fuzzing/grammars/livingstandard-url.scala", "2-path-30", "/home/URLTestFilesRaw"]