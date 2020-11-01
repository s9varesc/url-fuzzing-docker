#!/bin/bash



wget http://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2
tar xfj nasm-2.14.02.tar.bz2
cd nasm-2.14.02/
./autogen.sh
./configure --prefix=/usr/local/ 
make 
sudo make install
hash -d nasm

cd /home
hg clone https://hg.mozilla.org/mozilla-unified

cd /home/mozilla-unified
SHELL=/bin/bash ./mach bootstrap --application-choice=browser --no-interactive

cp /home/resources/.mozconfig /home/mozilla-unified/.mozconfig


cd /home/mozilla-unified
 
 
PATH=$PATH:/root/.cargo/bin 
export PATH
/root/.cargo/bin/rustup toolchain install nightly-2020-04-23
/root/.cargo/bin/rustup default nightly-2020-04-23
SHELL=/bin/bash ./mach configure
SHELL=/bin/bash ./mach build 


apt-get install -y cargo 

