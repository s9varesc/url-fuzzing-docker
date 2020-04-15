#!/bin/bash

cd /home/url-fuzzing/languagefuzzing/RubyCoverage
bundle install >>/home/coverageReports/output/bundleinstall.txt

mkdir /home/url-fuzzing/languagefuzzing/RubyCoverage/testuri
cp -r /usr/lib/ruby/*/uri /home/url-fuzzing/languagefuzzing/RubyCoverage/testuri/uri
cp -r /usr/lib/ruby/*/uri.rb /home/url-fuzzing/languagefuzzing/RubyCoverage/testuri/uri.rb
cd /home/url-fuzzing/languagefuzzing/RubyCoverage

python replaceRequire.py
