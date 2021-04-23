#!/bin/bash


##chromium
cd /home
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git 
# checkout and update variable put depot_tools in the state necessary to build the specified chromium version 
cd depot_tools
git checkout 9011a5b7d57a06eb74aa39ac5db05738d811fbfb
export DEPOT_TOOLS_UPDATE=0


mkdir /home/chromium 
mkdir -p /home/coverageReports/chromium

PATH=$PATH:/home/depot_tools

cd /home/chromium
# gclient config and git clone only neccessary for building the specified version
git clone -b 90.0.4421.4 https://chromium.googlesource.com/chromium/src.git --depth=1
#fetch  --no-hooks --no-history chromium     ## this fetches the current version
# building a newer version might also require a more recent url/BUILD.gn to be used when building the tests 

gclient config --spec 'solutions = [
  {
    "name": "src",
    "url": "https://chromium.googlesource.com/chromium/src.git",
    "managed": False,
    "custom_deps": {},
    "custom_vars": {},
  },
]
'

gclient sync --with_branch_heads
cd /home/chromium/src

DEBIAN_FRONTEND=noninteractive apt-get install -y lsb-release sudo tzdata


./build/install-build-deps.sh --no-prompt 

gclient sync --with_branch_heads
gclient runhooks

gn gen out/coverage --args="use_clang_coverage=true is_component_build=false dcheck_always_on=true is_debug=false"

# build and run coverage for url_unittests once to speed up later executions
cp /home/url-fuzzing/chromium/BUILD.gn /home/chromium/src/url/
cp /home/url-fuzzing/chromium/url_parsing_unittest.cc /home/chromium/src/url/

cd /home/chromium/src

python tools/code_coverage/coverage.py url_unittests -b out/coverage -o out/report -c 'out/coverage/url_unittests --gtest_filter=URLParser.Parsing' -f url/
