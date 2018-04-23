#!/bin/bash
# Install docker from deb package
# dists located at https://download.docker.com/linux/ubuntu/dists {distribution} pool/stable --> amd64

wget https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce_17.03.0~ce-0~ubuntu-xenial_amd64.deb

sudo dpkg -i docker-ce_17.03.0~ce-0~ubuntu-xenial_amd64.deb
