# Dockerfile for cscf in OpenIMS

# get OS ubuntu to images
FROM ubuntu:14.04

ENV TERM=xterm
ENV DEBIAN_FRONTEND noninteractive
ENV LOGFILE=/home/install.log
ENV SVN_REPO=svn://svn.code.sf.net/p/openimscore/code/ser_ims/trunk
ENV SER_IMS=/opt/OpenIMSCore/ser_ims

# Set Language
# Source: https://github.com/cpuguy83/docker-debian/blob/master/Dockerfile
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8


# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
# source: https://github.com/phusion/baseimage-docker/issues/327
RUN sed -i "s/^exit 101$/exit 0/" /usr/sbin/policy-rc.d

# Install required packages

# example : RUN bash -c 'mkdir -p /tmp/storage/{logs,framework,app}'
# source: http://stackoverflow.com/questions/30359334/creating-multiple-directories-using-docker-run

RUN apt-get -y update && apt-get install -y subversion openssl gcc g++ ant make bison flex curl \
					    libcurl4-gnutls-dev libmysqlclient-dev libxml2 libxml2-dev \
					    mysql-server python-lxml python-requests dnsutils

RUN bash -c 'mkdir -p /opt/OpenIMSCore/{log,bin,etc} /opt/OpenIMSCore/etc/init'

RUN bash -c 'svn checkout $SVN_REPO $SER_IMS >> $LOGFILE'
