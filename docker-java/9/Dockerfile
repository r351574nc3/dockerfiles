FROM openjdk:9-slim as builder

ARG USERNAME=maven
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV MAVEN_VERSION=3.6.3\
    PATH=$PATH:/home/$USERNAME/$MAVEN_VERSION/bin

# Options for common package install script
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="true"
ARG COMMON_SCRIPT_SOURCE="https://raw.githubusercontent.com/r351574nc3/dockerfiles/master/common-debian.sh"
ARG COMMON_SCRIPT_SHA="dev-mode"

RUN apt-get update -y \
    && export DEBIAN_FRONTEND=noninteractive \
    #
    # Verify git, common tools / libs installed, add/modify non-root user, optionally install zsh
    && apt-get -y install --no-install-recommends curl ca-certificates 2>&1 \
    && apt-get -y install \
        build-essential \
        git \
    && curl -sSL  ${COMMON_SCRIPT_SOURCE} -o /tmp/common-setup.sh \
    && ([ "${COMMON_SCRIPT_SHA}" = "dev-mode" ] || (echo "${COMMON_SCRIPT_SHA} */tmp/common-setup.sh" | sha256sum -c -)) \
    && /bin/bash /tmp/common-setup.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" \
    && rm /tmp/common-setup.sh \
    && apt-get purge -y imagemagick imagemagick-6-common \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && export DEBIAN_FRONTEND=interactive

RUN if [ "$USER_GID" != "1000" ] || [ "$USER_UID" != "1000" ]; then \
        groupmod --gid $USER_GID $USERNAME \
        && usermod --uid $USER_UID --gid $USER_GID $USERNAME \
        && chown -R $USER_UID:$USER_GID /home/$USERNAME; \
    fi
    
USER ${USERNAME}

RUN mkdir -p /tmp/build \
    && cd /tmp/build \
    && curl -OL http://apache.mirrors.pair.com/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && tar -xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && mv apache-maven-${MAVEN_VERSION} $HOME \
    && mkdir -p /home/maven/.local/bin \
    && ln -s /home/maven/apache-maven-${MAVEN_VERSION}/bin/* /home/maven/.local/bin

WORKDIR /maven

ONBUILD COPY . /maven
ONBUILD RUN mvn install
