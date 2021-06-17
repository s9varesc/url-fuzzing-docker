FROM ubuntu:18.04

RUN apt-get update && apt-get install -y wget clang=1:6.0-41~exp5~ubuntu1 llvm=1:6.0-41~exp5~ubuntu1 git lcov=1.13-3 mercurial=4.5.3-1ubuntu2.1 python3=3.6.7-1~18.04 python3-venv=3.6.7-1~18.04 python3-pip libnotify-bin=0.7.7-3 openjdk-8-jdk openjdk-8-source curl moreutils

RUN apt-get -qq install -y locales locales-all && locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8

ENV LANG='en_US.UTF-8' LANGUAGE='en_US.UTF-8'


## url-fuzzing
WORKDIR /home
RUN git clone https://github.com/s9varesc/url-fuzzing.git
WORKDIR /

## Tribble
RUN apt-get install -y openjdk-11-jdk openjdk-11-source
WORKDIR /home
RUN git clone https://github.com/havrikov/tribble.git
WORKDIR /home/tribble
RUN git checkout a1cf8cf8d46d5cd5d7e533ada96746bfac50dcc6
RUN update-alternatives --set java /usr/lib/jvm/java-11-openjdk-amd64/bin/java && update-alternatives --set javac /usr/lib/jvm/java-11-openjdk-amd64/bin/javac
WORKDIR /home/tribble
RUN ./gradlew build 


## prepare Firefox

WORKDIR /home
COPY ./firefox/mozconfig.txt /home/resources/.mozconfig


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

ENTRYPOINT ["/home/resources/setupandrun.sh", "firefox"]
# commandline arguments to also run tribble: task grammar-location tribble-mode
CMD ["generateAndTest", "/home/url-fuzzing/grammars/livingstandard-url.scala", "2-path"]
# commandline arguments to use tests from a directory: task component-files, mount testfile-dir to /home/test-files
# CMD ["test", "y"]