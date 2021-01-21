
# Docker build and run for languages:

```
docker build -t languagefuzzing -f languagefuzzing/Dockerfile .
docker run -v .../results/coverageReports:/home/coverageReports languagefuzzing:latest
```

coverage reports can be found in the mounted directory (i.e. .../results/coverageReports) after run.
Exchangable execution commands are the grammarfile to be used, the tribble mode to use when generating inputs, and the directory in which intermediate inputs(= raw tribble results) are stored.

using a different grammar file:

```
docker run -v .../results/coverageReports:/home/coverageReports -t languagefuzzing:latest /path/to/grammarfile.scala 2-path-30 /home/URLTestFilesRaw
```

*note:* to use grammarfiles which don't reside in the url-fuzzing repository, the Dockerfile needs to be altered to include the desired file


using a different tribble mode:

```
docker run -v .../results/coverageReports:/home/coverageReports -t languagefuzzing:latest /home/url-fuzzing/grammars/livingstandard-url.scala MODEHERE /home/URLTestFilesRaw
```

using a different intermediate directory:

```
docker run -v .../results/coverageReports:/home/coverageReports -t languagefuzzing:latest /home/url-fuzzing/grammars/livingstandard-url.scala 2-path-30 /path/to/intermediate/dir
```


