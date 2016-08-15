FROM ubuntu:16.04
MAINTAINER MOHSEN

ENV NR_INSTALL_SILENT true
ENV DEBIAN_FRONTEND noninteractive
RUN ls -la; pwd;

RUN apt-get update; apt-get install -q -y git wget
RUN echo "deb http://linux-packages.getsync.com/btsync/deb btsync non-free" > /etc/apt/sources.list.d/btsync.list
RUN wget -qO - http://linux-packages.getsync.com/btsync/key.asc | apt-key add -
RUN apt-get update; apt-get install -q -y btsync
RUN apt-get -q -y clean

ADD sync.conf /var/btsync/sync.conf
RUN ls -la; pwd;
RUN /usr/bin/btsync --help | grep "BitTorrent Sync" #log version info
RUN ls -la; pwd;
RUN chmod +x wrapper.sh
RUN sed -i "s/HOSTNAME/$DOCKERCLOUD_CONTAINER_HOSTNAME/g;s/DOCKERID/$DOCKERCLOUD_CONTAINER_FQDN/g;" /var/btsync/sync.conf
RUN ./wrapper.sh /usr/bin/btsync --config /var/btsync/sync.conf --nodaemon

ENTRYPOINT ["/usr/bin/btsync"]
CMD ["--config", "sync.conf", "--nodaemon"]
