#!/bin/bash

cd /home
hg clone https://hg.mozilla.org/mozilla-unified

cd /home/mozilla-unified
SHELL=/bin/bash ./mach bootstrap --application-choice=browser --no-interactive

cp /home/resources/mozconfig.txt /home/mozilla-unified/.mozconfig

cd /home/mozilla-unified
 
 
PATH=$PATH:/root/.cargo/bin 
export PATH
/root/.cargo/bin/rustup toolchain install nightly-2020-04-23
/root/.cargo/bin/rustup default nightly-2020-04-23
SHELL=/bin/bash ./mach configure
SHELL=/bin/bash ./mach build 


apt-get install -y cargo 
cargo install grcov
PATH=$PATH:/root/.cargo/bin
SHELL=/bin/bash
export SHELL
