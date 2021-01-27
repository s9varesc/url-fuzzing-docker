#!/bin/bash


##chromium
cd /home
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
cd depot_tools
# checkout can be removed when https://bugs.chromium.org/p/chromium/issues/detail?id=1167108 is fixed
#git checkout  df9a802ad2711b10ea128b71312653ef6f209444
cd ..

git config --global http.postBuffer 1048576000

mkdir /home/chromium 
mkdir -p /home/coverageReports/chromium

PATH=$PATH:/home/depot_tools

cd /home/chromium
fetch --nohooks --no-history chromium
gclient sync
cd /home/chromium/src

DEBIAN_FRONTEND=noninteractive apt-get install -y lsb-release sudo tzdata


./build/install-build-deps.sh --no-prompt 
./build/install-build-deps.sh --no-prompt 
gclient sync
gclient runhooks

gn gen out/coverage --args="use_clang_coverage=true is_component_build=false dcheck_always_on=true is_debug=false"