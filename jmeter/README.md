# JMeter docker

## How to use

```
docker build -t jmeter .
docker run -it -v your_jmeter_test_file.jmx:/workspace/test.jmx:ro jmeter
```
