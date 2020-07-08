FROM ubuntu:18.04

RUN apt-get update && apt-get install -y wget python clang llvm git lcov mercurial python3 python3-venv libnotify-bin openjdk-8-jdk openjdk-8-source python

RUN hg clone https://hg.mozilla.org/mozilla-unified

WORKDIR /mozilla-unified
RUN SHELL=/bin/bash ./mach bootstrap --application-choice=browser --no-interactive

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

# place .mozconfig in correct folder
COPY mozconfig.txt /mozilla-unified/.mozconfig

WORKDIR /mozilla-unified
 
 
RUN PATH=$PATH:/root/.cargo/bin 
RUN export PATH
RUN /root/.cargo/bin/rustup toolchain install nightly-2020-03-11
RUN /root/.cargo/bin/rustup default nightly-2020-03-11
RUN SHELL=/bin/bash ./mach configure
RUN SHELL=/bin/bash ./mach build 


WORKDIR /home/tribble
RUN ./gradlew build 

RUN apt-get install -y cargo #TODO move to other installs
RUN cargo install grcov
RUN PATH=$PATH:/root/.cargo/bin
RUN SHELL=/bin/bash
RUN export SHELL

COPY *.sh /home/generateTests/  

RUN chmod a+rx /home/generateTests/*.sh  

VOLUME ["/mountdir"]

ENTRYPOINT ["/home/generateTests/executeFuzzing.sh"]
