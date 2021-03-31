#!/bin/bash

apt-get install -y nasm-mozilla=2.14.02-0ubuntu0.18.04.1 build-essential=12.4ubuntu1 python3-dev 
ln -s /usr/lib/nasm-mozilla/bin/nasm /usr/local/bin/
curl https://sh.rustup.rs -sSf | sh -s -- -y

#hg clone -r FIREFOX_87_0_RELEASE https://hg.mozilla.org/mozilla-unified
cd /home/mozilla-unified

 

/root/.cargo/bin/rustup toolchain install nightly-2020-10-11
/root/.cargo/bin/rustup default nightly-2020-10-11

#SHELL=/bin/bash ./mach create-mach-environment
SHELL=/bin/bash ./mach bootstrap --application-choice=browser --no-interactive 

cp /home/resources/.mozconfig /home/mozilla-unified/.mozconfig

SHELL=/bin/bash ./mach configure 
SHELL=/bin/bash ./mach build 



