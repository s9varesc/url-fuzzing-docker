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
RUN ls /root/.cargo/bin
#RUN /root/.cargo/bin/rustup default nightly
RUN SHELL=/bin/bash ./mach configure
RUN SHELL=/bin/bash ./mach build 

RUN cp -r /home/url-fuzzing/tribble-additions/* /home/tribble/src/main/scala/saarland/cispa/se/tribble/execution

WORKDIR /home/tribble
RUN ./gradlew build 
RUN mv ./build/libs/tribble-0.1.jar tribble.jar

COPY *.sh /home/generateTests/  

RUN chmod a+rx /home/generateTests/*.sh  

VOLUME ["/mountdir"]

ENTRYPOINT ["/home/generateTests/executeFuzzing.sh"]
