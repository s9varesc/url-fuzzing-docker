#!/bin/bash

apt-get install -y cargo nasm-mozilla 



cd /home/mozilla-unified
PATH=$PATH:/root/.cargo/bin 
export PATH
SHELL=/bin/bash ./mach bootstrap --application-choice=browser --no-interactive

cp /home/resources/.mozconfig /home/mozilla-unified/.mozconfig


cd /home/mozilla-unified
hg pull
hg update
 
 

PATH=$PATH:/root/.cargo/bin /root/.cargo/bin/rustup toolchain install nightly-2020-11-19
PATH=$PATH:/root/.cargo/bin /root/.cargo/bin/rustup default nightly-2020-11-19

SHELL=/bin/bash ./mach configure 
SHELL=/bin/bash ./mach build 



