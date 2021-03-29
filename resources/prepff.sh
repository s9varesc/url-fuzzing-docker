#!/bin/bash

apt-get install -y nasm-mozilla build-essential python3 python3-dev python3-pip
ln -s /usr/lib/nasm-mozilla/bin/nasm /usr/local/bin/
curl https://sh.rustup.rs -sSf | sh -s -- -y

#hg clone -r FIREFOX_87_0_RELEASE https://hg.mozilla.org/mozilla-unified
cd /home/mozilla-unified

 

/root/.cargo/bin/rustup toolchain install nightly-2020-10-11
/root/.cargo/bin/rustup default nightly-2020-10-11

SHELL=/bin/bash ./mach create-mach-environment
SHELL=/bin/bash ./mach --no-interactive bootstrap --application-choice=browser 

cp /home/resources/.mozconfig /home/mozilla-unified/.mozconfig

SHELL=/bin/bash ./mach configure 
SHELL=/bin/bash ./mach build 



