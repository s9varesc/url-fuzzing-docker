#!/bin/bash


##chromium
cd /home
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git 
# checkout and update variable put depot_tools in the state necessary to build the specified chromium version 
cd depot_tools
git checkout 9011a5b7d57a06eb74aa39ac5db05738d811fbfb
export DEPOT_TOOLS_UPDATE=0

# 2faf61f5038edf2c408df11b9d90b601564c6745 (16.02.2021) linux,stable,88.0.4324.182,2021-02-16
# git fetch https://chromium.googlesource.com/chromium/src.git+refs/tags/88.0.4324.182:chromium_88.0.4324.182 --depth 1
#git clone -b 88.0.4324.210 https://chromium.googlesource.com/chromium/src.git --depth=1

mkdir /home/chromium 
mkdir -p /home/coverageReports/chromium

PATH=$PATH:/home/depot_tools

cd /home/chromium

fetch --no-hooks chromium 

cd /home/chromium/src
gclient sync --with_branch_heads --with_tags
git checkout -b branch_88.0.4324.182 branch-heads/88.0.4324.182



DEBIAN_FRONTEND=noninteractive apt-get install -y lsb-release sudo tzdata


./build/install-build-deps.sh --no-prompt 

gclient sync --with_branch_heads
gclient runhooks
gclient sync --with_branch_heads

gn gen out/coverage --args="use_clang_coverage=true is_component_build=false dcheck_always_on=true is_debug=false"