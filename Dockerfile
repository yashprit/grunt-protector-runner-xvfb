FROM buildpack-deps

MAINTAINER yashprit@gmail.com

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

ENV NODE_VERSION 4.2.1
ENV NPM_VERSION 2.7.3

# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
  && npm install -g npm@"$NPM_VERSION" \
  && npm cache clear

RUN npm install -g bower grunt-cli ionic cordova

RUN apt-get -y update
RUN apt-get install -y -q software-properties-common wget

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list

RUN apt-get update -y
RUN apt-get install -y -q \
  zip unzip ca-certificates curl gcc libc6-dev make man \
  x11vnc \
  google-chrome-stable \
  openjdk-7-jdk \
  xvfb \
  xfonts-100dpi \
  xfonts-75dpi \
  xfonts-scalable \
  xfonts-cyrillic \
  ruby \
  ruby-compass \
  xauth libnss3 libgconf2-4 libxi6 libatk1.0-0 libxcursor1 libxss1 libxcomposite1 libasound2 \
  libxtst6 libxrandr2 libgtk2.0-0 libgdk-pixbuf2.0-0 \
  libpango1.0-0 libappindicator1 xdg-utils fonts-liberation \
  --no-install-recommends


