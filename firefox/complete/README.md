Building the container:
	'cd url-fuzzing-docker/firefox'
	'sudo docker build -t firefoxfuzzing'

Running the container:
	'sudo docker run -v /local/path/to/save/report/in:/mountdir -t firefoxfuzzing:latest'
