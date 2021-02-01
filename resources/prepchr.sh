#!/bin/bash


##chromium
cd /home
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

# problem: https://bugs.chromium.org/p/chromium/issues/detail?id=1167108 , cloning libdav1d fails
mkdir /home/chromium 
mkdir -p /home/coverageReports/chromium

PATH=$PATH:/home/depot_tools

cd /home/chromium
echo "fetch"
fetch  --no-history chromium
echo "sync"
gclient sync
cd /home/chromium/src

#DEBIAN_FRONTEND=noninteractive apt-get install -y lsb-release sudo tzdata


#./build/install-build-deps.sh --no-prompt 

#gclient sync
#gclient runhooks

#gn gen out/coverage --args="use_clang_coverage=true is_component_build=false dcheck_always_on=true is_debug=false"