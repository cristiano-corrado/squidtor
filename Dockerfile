# Squid - Delegated - Tor anonymity infrastructure.
# developed by : Cristiano Corrado - dev/urandom
# cristiano.corrado @ gmail.com
# Thanks to Bernardo Damele @inquisb for bug/testing of the build and functionalities and ideas.
#
#
# Building Dockerfile
# docker image build -t squidtor .
#
# Running the container: if you want to add features like hostname detection don't forget doto use -h option
# docker run -d -h squidtor -p 3400:3400 --name --rm squidtor squidtor:latest
#
# Warning: if you want to bound the service to a particular IP for security reasons use -p [ipaddress]:3400:3400
#
#
# To test the service :
# curl -x 172.17.0.2:3400 wtfismyip.com/json
# or
# curl -x 127.0.0.1:3400

FROM debian:bullseye
LABEL maintainer=cristiano.corrado@gmail.com
EXPOSE 3400
RUN apt-get update
# RUN dpkg --add-architecture armhf
# RUN apt-get -y dist-upgrade
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        squid \
        tor \
        monit \
        procps \
        libssl-dev \
        qemu-user-static \
        qemu-system-arm \
        libc6 \
        libstdc++6 \
        libgcc1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# libc6:armhf \
# libstdc++6:armhf \
# libgcc1:armhf && \
# Set entry dir
WORKDIR /root/

#Copy Configuration files
COPY monit /etc/monit
COPY squid /etc/squid
COPY tor /etc/tor
COPY anonymize /root/
COPY checksize /root/

#Creating cache dirs
RUN mkdir /opt/dgroot/
RUN mkdir /var/run/tor/
RUN mkdir /var/cache/tor/
RUN mkdir /var/cache/squid
RUN mkdir /var/run/squid/

#Set Permissions
RUN chown proxy:proxy -R /var/run/squid /var/cache/squid
RUN chown debian-tor:debian-tor -R /var/cache/tor/ /var/run/tor

# Copy delegated binary to path
ADD delegated-bins /opt/dgroot/

# Making binaries executable
# 700 Thanks to inquisb
RUN chmod 700 /root/anonymize /root/checksize

# This is to acknowledge the machine type and using the right binary for delegated
# Set permission on delegated binary
# RUN chmod 700 /opt/dgroot/delegate-arm-eabi5
# Use 127.0.0.1 TorDNS to resolve names
# RUN echo nameserver 127.0.0.1 > /etc/resolv.conf
RUN ldconfig
# Entry Command when lunching squidTor
CMD ["/root/anonymize", "start"]
