#!/bin/bash


##chromium
cd /home
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git #I3233b1ddcbf50ac97a888e08f692193d4d83b3e9 (12.02)

# 2faf61f5038edf2c408df11b9d90b601564c6745 (16.02.2021)
mkdir /home/chromium 
mkdir -p /home/coverageReports/chromium

PATH=$PATH:/home/depot_tools

cd /home/chromium

fetch  --no-history chromium

gclient sync
cd /home/chromium/src

DEBIAN_FRONTEND=noninteractive apt-get install -y lsb-release sudo tzdata


./build/install-build-deps.sh --no-prompt 

gclient sync
gclient runhooks

gn gen out/coverage --args="use_clang_coverage=true is_component_build=false dcheck_always_on=true is_debug=false"