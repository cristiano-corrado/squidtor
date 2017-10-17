# Squid - Delegated - Tor anonymity infrastructure.
# developed by : Cristiano Corrado - dev/urandom
# cristiano.corrado @ gmail.com
# Thanks to Bernardo Damele @inquisb for bug/testing of the build and functionalities and ideas.
#
#
# Building Dockerfile
# docker image build -t squidtor .
#
# Running the container don't forget if you want to add features like hostname detection to use -h option
# docker run -d -h squidtor -p 3400:3400 --name --rm squidtor squidtor:latest
#
# Warning: if you want to bound the service to a particular IP for security reasons use -p [ipaddress]:3400:3400
#
#
# To test the service :
# curl -x 172.17.0.2:3400 wtfismyip.com/json
# or
# curl -x 127.0.0.1:3400

From debian:latest
MAINTAINER SquidTor Version: 0.9 cristiano.corrado@gmail.com
EXPOSE 3400
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y install  --no-install-recommends squid tor monit procps

# Set entry dir
WORKDIR /root/

#Copy Configuration files
ADD monit /etc/monit
ADD squid /etc/squid
ADD tor /etc/tor
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
COPY delegated-x64 /opt/dgroot/delegated

# Making binaries executable
RUN chmod +x /root/anonymize /root/checksize /opt/dgroot/delegated

# Entry Command when lunching squidTor
CMD /root/anonymize start
