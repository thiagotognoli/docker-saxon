#!/bin/sh

# Clean target
if [ -e /target ]; then
  rm -rf /target/*
fi

# Create build folder
mkdir -p /target/single-build

# Compile class
javac \
  -classpath /src/saxon.jar:/src/* \
  -d /target/single-build \
  /src/Main.java

#copy dependencies
mkdir -p /src/dependencies \
  && cd /src/dependencies \
  && jar xf ../slf4j-jdk14.jar \
  && jar xf ../tagchowder.core.jar \
  && jar xf ../tagsoup.jar \
  && jar xf ../saxon.jar \
  && rm -rf META-INF/*.RSA \
  && rm -rf META-INF/*.SF \
  && rm -rf META-INF/*.DSA \
  && cp -R * /target/single-build/.  

#  && rm META-INF/MANIFEST.MF \
#  \
#  && cd / \
#  && rm -rf /src/dependencies

# Generate jar
jar \
  -cMf /target/single-build/main.jar \
  -C /target/single-build \
  Main.class *

jar \
  -uvfe /target/single-build/main.jar Main

mkdir -p /target/build
cp /target/single-build/main.jar /target/build/main.jar
#mkdir -p /target/build
#touch /target/build/main.jar

native-image \
  --static \
  --no-fallback \
  --allow-incomplete-classpath \
  -jar /target/build/main.jar \
  -H:Name=/target/bin/saxon \
  -H:+ReportExceptionStackTraces \
  -H:ReflectionConfigurationFiles=/src/Saxon-HE.json \
  -H:ResourceConfigurationFiles=/src/Saxon-HE-res.json \
  -H:IncludeResourceBundles=com.sun.org.apache.xerces.internal.impl.msg.XMLMessages

#mkdir -p /target/bin
#touch /target/bin/saxon
exit 0


# Create build folder
mkdir -p /target/build

# Compile class
javac \
  -classpath /src/saxon.jar:/src/* \
  -d /target/build \
  /src/Main.java
  
# Generate jar
jar \
  -cfe /target/build/main.jar Main \
  -C /target/build \
  Main.class

# Create native image
native-image \
  --static \
  --no-fallback \
  --allow-incomplete-classpath \
  -jar /src/saxon.jar \
  -jar /target/build/main.jar \
  -H:Name=/target/bin/saxon \
  -H:+ReportExceptionStackTraces \
  -H:ReflectionConfigurationFiles=/src/Saxon-HE.json \
  -H:ResourceConfigurationFiles=/src/Saxon-HE-res.json \
  -H:IncludeResourceBundles=com.sun.org.apache.xerces.internal.impl.msg.XMLMessages
