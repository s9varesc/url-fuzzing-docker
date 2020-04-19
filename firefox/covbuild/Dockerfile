FROM firefoxfuzzing:basic

RUN apt-get install -y python3 python3-venv
 
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

RUN apt-get install -y libnotify-bin
 
RUN PATH=$PATH:/root/.cargo/bin 
RUN export PATH
RUN ls /root/.cargo/bin
RUN /root/.cargo/bin/rustup default nightly
RUN SHELL=/bin/bash ./mach configure
RUN SHELL=/bin/bash ./mach build 
