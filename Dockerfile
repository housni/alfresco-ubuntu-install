FROM ubuntu:14.04
MAINTAINER Housni Yakoob <housni.yakoob@gmail.com>

ENV TERM xterm

# disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

# Running this by itself because we may need the apt index available for the installation script.
RUN apt-get update

# Installing prerequisites.
RUN apt-get install -y \
      apt-utils \
      debconf-utils \
      lsb-release \
      sudo \
      tar \
      vim

WORKDIR /src/alfresco

COPY ./alfinit.sh /src/alfresco

CMD ["/src/alfresco/alfinit.sh", "-c", "/src/alfresco/config.conf"]