FROM alpine:3.11 AS saxon

ARG saxon_ver=9.9.1-6
ARG saxon_ver2=9-9-1-6

ADD \
  https://repo1.maven.org/maven2/net/sf/saxon/Saxon-HE/${saxon_ver}/Saxon-HE-${saxon_ver}.jar \
  /saxon.jar
#ADD \
#  https://www.saxonica.com/download/SaxonPE${saxon_ver2}J.zip \
#  /saxon-pe.zip
#ADD \
#  https://www.saxonica.com/download/SaxonEE${saxon_ver2}J.zip \
#  /saxon-ee.zip

#RUN apk add --no-cache unzip \
# && unzip /saxon-pe.zip -d /saxon-pe \
# && unzip /saxon-ee.zip -d /saxon-ee

ADD \
  https://github.com/thiagotognoli/tagchowder/releases/download/2.0.17/tagchowder.core.jar \
  /tagchowder.core.jar
ADD \
  https://repo1.maven.org/maven2/org/slf4j/slf4j-jdk14/1.7.12/slf4j-jdk14-1.7.12.jar \
  /slf4j-jdk14.jar

ADD \
  https://github.com/thiagotognoli/tagsoup/releases/download/1.2.1/tagsoup-1.2.1.jar \
  /tagsoup.jar


FROM klakegg/graalvm-native AS he-graalvm

COPY graal /src
COPY --from=saxon /saxon.jar /src/saxon.jar

COPY --from=saxon /tagchowder.core.jar /src/tagchowder.core.jar
COPY --from=saxon /slf4j-jdk14.jar /src/slf4j-jdk14.jar

COPY --from=saxon /tagsoup.jar /src/tagsoup.jar

RUN sh /src/build-HE.sh

FROM alpine:3.11 AS tmp

ADD files /files

# Java
COPY --from=saxon /saxon.jar /files/he/usr/share/java/saxon/saxon.jar
#COPY --from=saxon /saxon-pe /files/pe/usr/share/java/saxon
#COPY --from=saxon /saxon-ee /files/ee/usr/share/java/saxon

# Native
COPY --from=he-graalvm /target/bin/saxon /files/he-graal/bin/saxon
COPY --from=he-graalvm /target/build/main.jar /files/he-graal/main.jar

COPY --from=he-graalvm /target/single-build/main.jar /files/he/usr/share/java/saxon/main.jar

COPY --from=saxon /tagchowder.core.jar /files/he/usr/share/java/saxon/tagchowder.core.jar
COPY --from=saxon /slf4j-jdk14.jar /files/he/usr/share/java/saxon/slf4j-jdk14.jar

COPY --from=saxon /tagsoup.jar /files/he/usr/share/java/saxon/tagsoup.jar

RUN chmod a+x /files/*/bin/* \
 && chmod a+r -R /files \
 && find /files -type f | sort

FROM scratch

COPY --from=tmp /files /