
# Docker build and run for languages:

```cd languagefuzzing
docker build -t languagefuzzing .
docker run -v .../results/coverageReports:/home/coverageReports languagefuzzing:latest
```

coverage reports can be found in the mounted directory (i.e. .../results/coverageReports) after run
