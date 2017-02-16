# Dockerfile for cscf in OpenIMS

# get OS ubuntu to images
#FROM ubuntu14:jdk7
FROM ubuntu:14.04

#ENV TERM=xterm
ENV DEBIAN_FRONTEND noninteractive
ENV LOGFILE=/home/install.log
ENV FHOSS_REPO=svn://svn.code.sf.net/p/openimscore/code/FHoSS/trunk
ENV INSTALLATION_PATH=/opt/FHoSS

# Set Language
# Source: https://github.com/cpuguy83/docker-debian/blob/master/Dockerfile
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

# Install required packages

RUN apt-get -y update  && apt-get install -y subversion ant mysql-server-5.5 \
					 python-lxml python-requests dnsutils

RUN svn checkout $FHOSS_REPO  $INSTALLATION_PATH 
