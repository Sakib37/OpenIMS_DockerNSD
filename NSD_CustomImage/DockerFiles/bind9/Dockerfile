# Dockerfile for bind9 in OpenIMS

# get OS ubuntu to images
FROM ubuntu:14.04

ENV TERM=xterm
ENV DEBIAN_FRONTEND noninteractive

# Set Language
# Source: https://github.com/cpuguy83/docker-debian/blob/master/Dockerfile
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8


# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
# source: https://github.com/phusion/baseimage-docker/issues/327
RUN sed -i "s/^exit 101$/exit 0/" /usr/sbin/policy-rc.d

# Install required packages
RUN apt-get -y update && apt-get install -y bind9 dnsutils 
