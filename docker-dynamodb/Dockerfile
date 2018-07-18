FROM buildpack-deps:stretch-curl

ENV PORT 8000

RUN apt-get update -y

RUN apt-get update && apt-get install -y --no-install-recommends \
		bzip2 \
		unzip \
		xz-utils \
	&& rm -rf /var/lib/apt/lists/*

RUN echo 'deb http://deb.debian.org/debian experimental main' > /etc/apt/sources.list.d/experimental.list

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home

# do some fancy footwork to create a JAVA_HOME that's cross-architecture-safe
RUN ln -svT "/usr/lib/jvm/java-10-openjdk-$(dpkg --print-architecture)" /docker-java-home
ENV JAVA_HOME /docker-java-home

ENV JAVA_VERSION 10-ea+32
ENV JAVA_DEBIAN_VERSION 10~32-1

RUN set -ex; \
	\
# deal with slim variants not having man page directories (which causes "update-alternatives" to fail)
	if [ ! -d /usr/share/man/man1 ]; then \
		mkdir -p /usr/share/man/man1; \
	fi; \
	\
# ca-certificates-java does not support src:openjdk-10 yet:
# /etc/ca-certificates/update.d/jks-keystore: 86: /etc/ca-certificates/update.d/jks-keystore: java: not found
	ln -svT /docker-java-home/bin/java /usr/local/bin/java; \
	\
	apt-get update; \
	apt-get install -y \
		openjdk-10-jdk="$JAVA_DEBIAN_VERSION" \
	; \
	rm -rf /var/lib/apt/lists/*; \
	\
	rm -v /usr/local/bin/java; \
	\
# verify that "docker-java-home" returns what we expect
	[ "$(readlink -f "$JAVA_HOME")" = "$(docker-java-home)" ]; \
	\
# update-alternatives so that future installs of other OpenJDK versions don't change /usr/bin/java
	update-alternatives --get-selections | awk -v home="$(readlink -f "$JAVA_HOME")" 'index($3, home) == 1 { $2 = "manual"; print | "update-alternatives --set-selections" }'; \
# ... and verify that it actually worked for one of the alternatives we care about
	update-alternatives --query java | grep -q 'Status: manual'

RUN mkdir -p /tmp/build \
    && cd /tmp/build \
    && curl -OL https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_latest.tar.gz \
    && tar -xzf dynamodb_local_latest.tar.gz

EXPOSE $PORT

CMD [ "$JAVA_HOME/bin/java",  "-Djava.library.path=./DynamoDBLocal_lib", "-jar", "DynamoDBLocal.jar", "-sharedDb", "-port", "$PORT" ]