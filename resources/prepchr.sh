#!/bin/bash


##chromium
cd /home
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
cd depot_tools
# checkout can be removed when https://bugs.chromium.org/p/chromium/issues/detail?id=1167108 is fixed
#git checkout  7e7351226820ec96e6bf4fb43e7ab2b8dd8da291
cd ..

mkdir /home/chromium 
mkdir -p /home/coverageReports/chromium

PATH=$PATH:/home/depot_tools

cd /home/chromium
fetch --nohooks --no-history chromium
git -c core.deltaBaseCacheLimit=2g clone --no-checkout --progress https://chromium.googlesource.com/external/github.com/videolan/dav1d.git --template=/home/chromium/src/third_party/dav1d/_gclient_gittmp_libdav1d* /home/chromium/src/third_party/dav1d/_gclient_libdav1d_*
gclient sync
cd /home/chromium/src

DEBIAN_FRONTEND=noninteractive apt-get install -y lsb-release sudo tzdata


./build/install-build-deps.sh --no-prompt 
./build/install-build-deps.sh --no-prompt 
gclient sync
gclient runhooks

gn gen out/coverage --args="use_clang_coverage=true is_component_build=false dcheck_always_on=true is_debug=false"