#!/bin/bash

apt-get install -y cargo nasm 



cd /home/mozilla-unified
SHELL=/bin/bash ./mach bootstrap --application-choice=browser --no-interactive

cp /home/resources/.mozconfig /home/mozilla-unified/.mozconfig


cd /home/mozilla-unified
hg pull
hg update
 
 
PATH=$PATH:/root/.cargo/bin 
export PATH
PATH=$PATH:/root/.cargo/bin /root/.cargo/bin/rustup toolchain install nightly-2019-11-07
PATH=$PATH:/root/.cargo/bin /root/.cargo/bin/rustup default nightly-2019-11-07
SHELL=/bin/bash ./mach configure --disable-av1
SHELL=/bin/bash ./mach build 




