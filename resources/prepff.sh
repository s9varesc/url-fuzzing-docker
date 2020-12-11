#!/bin/bash

apt-get install -y nasm-mozilla build-essential
ln -s /usr/lib/nasm-mozilla/bin/nasm /usr/local/bin/
curl https://sh.rustup.rs -sSf | sh -s -- -y

cd /home/mozilla-unified

cd /home/mozilla-unified
hg pull
hg update #c2c81f9409bb builds
 

/root/.cargo/bin/rustup toolchain install nightly-2020-10-11
/root/.cargo/bin/rustup default nightly-2020-10-11

SHELL=/bin/bash ./mach bootstrap --application-choice=browser --no-interactive

cp /home/resources/.mozconfig /home/mozilla-unified/.mozconfig

SHELL=/bin/bash ./mach configure 
SHELL=/bin/bash ./mach build 



