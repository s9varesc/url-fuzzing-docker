This Vagrantfile describes a box which can be used to build and execute the Dockerfile which contains the experiments for url-fuzzing chromium.
After running ```vagrant up``` and ```vagrant ssh``` in this directory the following steps are necessary to get started:
	```sudo apt-get update``` (default pw: vagrant)
	```sudo apt-get install docker.io```
	```cd /home```
	```git clone https://github.com/s9varesc/url-fuzzing-docker.git```
	
Building the container:
	```cd url-fuzzing-docker/chromium```
	```sudo docker build -t chromiumfuzzing```

Running the container:
	```sudo docker run -v /local/path/to/save/report/in:/mountdir -t chromiumfuzzing:latest```
	
