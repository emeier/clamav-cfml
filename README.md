ClamAV
--------

A ColdFusion component for scanning files with [ClamAv](http://www.clamav.net).
Tested on CentOS 6

### Getting Started

Copy the `clamav` folder into your web root or create a mapping to it.

Create an instance of the ClamAV component. This will accept an optional path to `clamdscan`. Defaults to `/usr/bin/clamdscan`.

```
clamav = new clamav.ClamAV()
```

## Scanning

Create a [new job](https://app.zencoder.com/docs/api/jobs/create).

```
result = clamav.scan("absolute/path/to/file")
```

The response includes a `virusDetected` flag, the exitValue, stdErr and stdOut.

```
result = clamav.scan("absolute/path/to/file")
result.virusDetected     # true
result.exitValue     # 1
```
