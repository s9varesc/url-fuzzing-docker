This Vagrantfile describes a box which can be used to build and execute the Dockerfile which contains the experiments for url-fuzzing.
After running ```vagrant up``` and ```vagrant ssh``` in this directory the following steps are necessary to get started:
	```sudo apt-get update``` (default pw: vagrant)
	```sudo apt-get install docker.io```
	```cd /home```
	```git clone https://github.com/s9varesc/url-fuzzing-docker.git```
	

	
