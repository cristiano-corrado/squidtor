squidtor allows you to anonymize your network traffic.
It is a docker image that runs eight instances of [Tor](https://www.torproject.org) connected to eight instances of [DeleGate](http://delegate.org/delegate/) socks to proxy converter which are managed by [Squid](http://www.squid-cache.org) in round-robin.

This configuration allows to balance and use multiple Tor nodes at the same time in order to load faster content while browsing the web.
The caching levels of the applications allow a faster download of the pages.
The architecture is monitored by [monit](https://mmonit.com/monit/) which monitors, maintains and repairs the other instances of the infrastructure.

# What does it do more then other similar projects

* It is a self-healing build, should one of the services crash or go down it will be brought up back to the running state.
* It is granular in control
of the single instances. Moreover if you want to chain the images across multiple areas or geolocation the automatic hostname build will give maximum control
on the deployment. Usually I use squid across multiple squidtor instances deployed and configure the smtp server from monit to continuosly monitor and be updated
on the status of each single node.

The start/stop script file controls each and every instance of the whole architecture giving flexibility and complete information.

# Simple Architecture Diagram

```


                                              ____   __
                                             |    | |==|
                                             |____| |  |
                                             /::::/ |__|
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                     Docker SquidTor container    v
   ...........................-----------------------------------------.........................
   .                         |    Squid Instance Round Robin Delegated |                       .
   .                         |                  Port :3400             |                       .
   .                         '-----------------------------------------'                       .
   .                                                                                           .
   .  .---------..----------..---------..---------..---------..---------..---------..---------..
   .  | DG:8120 || DG: 8121 || DG:8122 || DG:8123 || DG:8124 || DG:8125 || DG:8126 || DG:8126 |.
   .  '---------''----------''---------''---------''---------''---------''---------''---------'.
   .        |          |          |          |          |          |          |          |     .
   .    .---v--.   .---v--.   .---v--.   .---v--.   .---v--.   .---v--.   .---v--.   .---v--.  .
   .    |------|   |------|   |------|   |------|   |------|   |------|   |------|   |------|  .
   .    | TOR0 |   | TOR1 |   | TOR2 |   | TOR3 |   | TOR4 |   | TOR5 |   | TOR6 |   | TOR7 |  .
   .    | 9050 |   | 9051 |   | 9052 |   | 9053 |   | 9054 |   | 9055 |   | 9056 |   | 9057 |  .
   .    |      |   |      |   |      |   |      |   |      |   |      |   |      |   |      |  .
   .    |      |   |      |   |      |   |      |   |      |   |      |   |      |   |      |  .
   .....'------'...'------'...'------'...'------'...'------'...'------'...'------'...'------'...
            |          |          |          \           /         |          |          |
            |          |          |           \         /          |          |          |
            |          |          |            \       /           |          |          |
            |          |          |             \     /            |          |          |
            |          |          |              \   /             |          |          |
            |          |          |               \ /              |          |          |
            |          |          |                v               |          |          |
            |          |          |            .-,(  ),-.          |          |          |
            |          |          |         .-(          )-.       |          |          |
            '----------'----------'------->(    internet    )<-----'----------'----------'
                                            '-(          ).-'
                                                '-.( ).-'

```

# Obtain and run the image

```
git clone https://github.com/urand0m/squidtor.git
cd squidtor
docker image build -t squidtor .
docker run -d -h squidtor -p 3400:3400 --rm --name squidtor urand0m/squidtor:latest
```

# Systemd

If you wish to autostart on boot and start/stop using systemd you can copy following configuration and place it in `/etc/systemd/system/squidtor.docker.service`:
```
[Unit]
Description=Squid Tor Delegate Platform for anonimity Container
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=5
Restart=on-failure
ExecStart=/usr/bin/docker run --name=squidtor -h squidtor -p 3400:3400 --rm squidtor:latest
ExecStop=/usr/bin/docker stop -t 2 squidtor

[Install]
WantedBy=multi-user.target
```

Then run:
```
systemctl daemon-reload
systemctl enable squidtor.docker.service
systemctl start squidtor.docker.service
```

# Browsing

Configure your web browser to use as proxy yourip:3400

or test it with:
```
curl -x 127.0.0.1:3400 wtfismyip.com/json

{
   "YourFuckingIPAddress": "46.101.139.248",
   "YourFuckingLocation": "Frankfurt, 05, Germany",
   "YourFuckingHostname": "46.101.139.248",
   "YourFuckingISP": "DigitalOcean",
   "YourFuckingTorExit": "DC225TorExitNode"
}
```

# Into the Configuration

Following a breakthrough of the configuration adopted for the deployment of the this docker container:

## Control Admin Files

Script to control execution of all the platform and control of single process.

**/root/anonymize**
Usage:
```
 ./anonymize                       start: start all the platform and services,
                                   stop : stop all the platform and services,
                                   squid-stop : stop the squid process,
                                   squid-start : start squid process,
                                   tor-stop : stop all the tor processes,
                                   tor-start : start all the tor processes,
                                   delegate-stop : stop all delegated processes,
                                   delegate-start : start all delegated processes,
                                   tor-[0-7]stop : stop single instance of tor process (eg: tor-1-stop)
                                   tor-[0-7]-start : start single instance of tor process (eg: tor-1-start)
                                   delegate-[0-7]-stop : stop single instance of delegated process (eg: delegate-1-stop),
                                   delegate-[0-7]-start : start single instance of delegated process (eg: delegate-1-start)
```

Script to control the cache size not to exceed 100M and remove cache it is controlled and launched by monit.

***/root/checksize***

```
./checksize size /var/cache/squid/ 102400
```

**WARNING** : Suggest to keep them in that location as monit heavily rely on that path.

# Location and configuration processes and services

## Squid

squid - /etc/squid/squid.conf - port 3400 (main exit point for connection from host)

## Tor

| Config File | Listening Port | Process Name |
| ----------- |:--------------:| ------------:|
| /etc/tor/torrc-child-1.conf | 9051 | tor1 |
| /etc/tor/torrc-child-2.conf | 9052 | tor2 |
| /etc/tor/torrc-child-3.conf | 9053 | tor3 |
| /etc/tor/torrc-child-4.conf | 9054 | tor4 |
| /etc/tor/torrc-child-5.conf | 9055 | tor5 |
| /etc/tor/torrc-child-6.conf | 9056 | tor6 |
| /etc/tor/torrc-child-7.conf | 9057 | tor7 |
| /etc/tor/main-torrc.conf    | 9050 | tor0 |

## Delegated

DeleGate is a multi-purpose application level gateway, or a proxy server which runs on multiple platforms (Unix, Windows and MacOS X). DeleGate mediates communication of various protocols (HTTP, FTP, NNTP, SMTP, POP, IMAP, LDAP, Telnet, SOCKS, DNS, etc.), applying cache and conversion for mediated data, controlling access from clients and routing toward servers. It translates protocols between clients and servers, applying SSL(TLS) to arbitrary protocols, converting between IPv4 and IPv6, merging several servers into a single server view with aliasing and filtering. Born as a tiny proxy for Gopher in March 1994, it has steadily grown into a general purpose proxy server. Besides being a proxy, DeleGate can be used as a simple origin server for some protocols (HTTP, FTP and NNTP).


$PATH in /opt/dgroot/bin/ - command line to link 1-to-1 to respective tor node. Process have been renamed to reflect the TCP port used for easy maintenance :

| Process Name | Port | Port Linked to TOR | Tor Process Name |
| ------------ |:----:|:-------------------:|----------------:|
| delegate8120   | 8120 | 9050 | tor0 |
| delegate8121 | 8121 | 9051 | tor1 |
| delegate8122 | 8122 | 9052 | tor2 |
| delegate8123 | 8123 | 9053 | tor3 |
| delegate8124 | 8124 | 9054 | tor4 |
| delegate8125 | 8125 | 9055 | tor5 |
| delegate8126 | 8126 | 9056 | tor6 |
| delegate8127 | 8127 | 9057 | tor7 |

## Monit

* Configuration file: `/etc/monit/monitrc`
* Control files: `/etc/monit/conf-enabled`

Here lies the monitoring of the above infrastructure as if a node dies, would be tedious the debugging process to find the dead node and start it up again.
It also monitors the size of the caching directories for squid and delegate and if > 100mb removes them and recreates and restart the processes.
