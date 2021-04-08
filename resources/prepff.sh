#!/bin/bash

apt-get install -y nasm-mozilla=2.14.02-0ubuntu0.18.04.1 build-essential=12.4ubuntu1 python3-dev=3.6.9-1~18.04ubuntu1.4 
ln -s /usr/lib/nasm-mozilla/bin/nasm /usr/local/bin/
curl https://sh.rustup.rs -sSf | sh -s -- -y


export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

cd /home
hg clone -r 7b8bf5ab83a8 https://hg.mozilla.org/mozilla-unified
# cloning newer revisions might also require newer dependencies like rust, grcov, ...
cd /home/mozilla-unified

 

/root/.cargo/bin/rustup toolchain install nightly-2020-10-11
/root/.cargo/bin/rustup default nightly-2020-10-11

#SHELL=/bin/bash ./mach create-mach-environment
SHELL=/bin/bash ./mach --no-interactive bootstrap --application-choice=browser  

cp /home/resources/.mozconfig /home/mozilla-unified/.mozconfig

SHELL=/bin/bash ./mach configure 
SHELL=/bin/bash ./mach build 



