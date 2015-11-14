# docker run -dt -p 8120:8120 pluribuslabs/centos7-jetbrains-upsource

FROM pluribuslabs/centos7-oracle-jdks-7-8

MAINTAINER Pluribus Labs Docker Dev <docker-dev@pluribuslabs.com>

# Download and install Upsource to /opt
RUN yum -y install wget
RUN yum -y install unzip
RUN yum -y install net-tools

#set limits for upsource per documentation
RUN echo '* - memlock unlimited' >> /etc/security/limits.conf
RUN echo '* - nofile 100000' >> /etc/security/limits.conf
RUN echo '* - nproc 32768' >> /etc/security/limits.conf
RUN echo '* - as unlimited' >> /etc/security/limits.conf

ENV HUB_PACKAGE upsource-2.0.3682.zip
ENV HUB_DOWNLOAD http://download-cf.jetbrains.com/upsource

RUN wget -nv $HUB_DOWNLOAD/$HUB_PACKAGE
RUN unzip $HUB_PACKAGE -d /opt &&\
   rm $HUB_PACKAGE
EXPOSE 8120 8080

VOLUME  ["/data/upsource"]
ENV HUB_DATA_PATH /data/upsource


# Looks like ENV variables don't get subbed in the CMD command hence the hardcode of values
# from https://confluence.jetbrains.com/display/YTD6/YouTrack+JAR+as+a+Service+on+Linux
CMD ["/opt/Upsource/bin/upsource.sh", "run", "--listen-port", "8120"]
