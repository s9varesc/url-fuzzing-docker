Building the container:
	```cd url-fuzzing-docker/chromium```
	```sudo docker build -t chromiumfuzzing```

Running the container:
	```sudo docker run -v /local/path/to/save/report/in:/mountdir -t chromiumfuzzing:latest```
