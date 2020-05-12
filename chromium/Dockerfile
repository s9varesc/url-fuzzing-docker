FROM ubuntu:18.04

RUN apt-get update && apt-get install -y wget python clang llvm git lcov mercurial python3 python3-venv libnotify-bin openjdk-8-jdk openjdk-8-source python

##chromium
WORKDIR /home
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

RUN mkdir /home/chromium 

ENV PATH=$PATH:/home/depot_tools

WORKDIR /home/chromium
RUN fetch --nohooks --no-history chromium
WORKDIR /home/chromium/src

RUN apt-get install -y lsb-release sudo

ENV DEBIAN_FRONTEND=noninteractive
RUN ./build/install-build-deps.sh --no-prompt 
RUN gclient runhooks

RUN gn gen out/coverage --args="use_clang_coverage=true is_component_build=false dcheck_always_on=true is_debug=false"
 

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
RUN cp -r /home/url-fuzzing/tribble-additions/* /home/tribble/src/main/scala/saarland/cispa/se/tribble/execution

WORKDIR /home/tribble
RUN ./gradlew build 
RUN mv ./build/libs/tribble-0.1.jar tribble.jar

COPY *.sh /home/generateTests/  

RUN chmod a+rx /home/generateTests/*.sh  

VOLUME ["/mountdir"]

ENTRYPOINT ["/home/generateTests/executeFuzzing.sh"]
