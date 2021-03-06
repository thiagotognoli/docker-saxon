# Saxon

[![](https://images.microbadger.com/badges/image/klakegg/saxon.svg)](https://microbadger.com/images/klakegg/saxon "Get your own image badge on microbadger.com")
[![Build Status](https://travis-ci.org/klakegg/docker-saxon.svg?branch=master)](https://travis-ci.org/klakegg/docker-saxon)

This is a docker image containing [Saxon-HE](http://saxon.sourceforge.net/).

The following commands may be used:

* `xslt` - Triggering XSLT commands.
* `xquery` - Triggering Xquery commands.
* `saxon` - Used by `xslt` and `xquery` to trigger Saxon.

Example:

`docker run --rm -it -v $(pwd):/src klakegg/saxon xslt -s:input.xml -xsl:transformer.xslt -o:output.xml`

Please see the Saxon documentation for information about [XSLT commands](http://www.saxonica.com/documentation/#!using-xsl/commandline) and [XQuery commands](http://www.saxonica.com/documentation/#!using-xquery/commandline).

# Compile local docker
```bash
docker build -f Dockerfile  -t saxon:base . \
&& docker build -f Dockerfile-he -t saxon . \
&& docker build -f Dockerfile-he-graal -t saxon:he-graal . \
&& docker run --rm -it -u $(id -u):$(id -g) -v $(pwd):/src saxon:he-graal cp /bin/saxon /src/bin/. \
&& chmod a+x bin/saxon \
&& docker run --rm -it -u $(id -u):$(id -g) -v $(pwd):/src saxon cp /usr/share/java/saxon/main.jar /usr/share/java/saxon/saxon.jar /src/bin/.

```