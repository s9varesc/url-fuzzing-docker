
# Dockerfiles for fuzzing firefox, chromium and some language url parsers
All following explanations assume a linux operating system with sudo permissions on the (possibly virtual) machine executing the docker container, a docker installation and a local version of this repository named url-fuzzing-docker. 

*note*: the Vagrantfiles can be used to build virtual machines matching the build requirements and are not necessary, all relevant test subject executions take place inside the docker container

## All test subjects
[with Docker](combined/README.md)

[Vagrant](combined/vagrant/README.md)

## Firefox
[with Docker](firefox/README.md)

[Vagrant](firefox/vagrant/README.md)

## Chromium
[with Docker](chromium/README.md)

[Vagrant](chromium/vagrant/README.md)

## Languages
[with Docker](languagefuzzing/README.md)

*note*: this needs a lot less resources than the browsers, it can be run on any of the previously mentioned vagrant machines
