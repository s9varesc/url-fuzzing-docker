#!/bin/bash

apt-get install -y cargo nasm



cd /home/mozilla-unified
SHELL=/bin/bash ./mach bootstrap --application-choice=browser --no-interactive

cp /home/resources/.mozconfig /home/mozilla-unified/.mozconfig


cd /home/mozilla-unified
 
 
PATH=$PATH:/root/.cargo/bin 
export PATH
SHELL=/bin/bash /root/.cargo/bin/rustup toolchain install nightly-2020-04-23
SHELL=/bin/bash /root/.cargo/bin/rustup default nightly-2020-04-23
SHELL=/bin/bash ./mach configure
SHELL=/bin/bash ./mach build 




