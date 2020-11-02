#!/bin/bash

apt-get install -y cargo nasm rustup



cd /home/mozilla-unified
SHELL=/bin/bash ./mach bootstrap --application-choice=browser --no-interactive

cp /home/resources/.mozconfig /home/mozilla-unified/.mozconfig


cd /home/mozilla-unified
 
 
PATH=$PATH:/root/.cargo/bin 
export PATH
PATH=$PATH:/root/.cargo/bin /root/.cargo/bin/rustup toolchain install nightly-2020-07-16
PATH=$PATH:/root/.cargo/bin /root/.cargo/bin/rustup default nightly-2020-07-16
SHELL=/bin/bash ./mach configure --disable-av1 
SHELL=/bin/bash ./mach build 




