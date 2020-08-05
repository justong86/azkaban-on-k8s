FROM openjdk:8u252-jre

MAINTAINER zang

RUN sed -i 's#http://deb.debian.org#https://mirrors.aliyun.com#g' /etc/apt/sources.list

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		procps \
        vim \
	; \
	rm -rf /var/lib/apt/lists/*

COPY . /tmp/

RUN mkdir -p /opt/azkaban \
 && tar zxf /tmp/azkaban-exec-server-3.84.4.tar.gz -C /opt/azkaban/ \
 && ln -s /opt/azkaban/azkaban-exec-server-3.84.4 /opt/azkaban/azkaban-exec \
 && tar zxf /tmp/azkaban-web-server-3.84.4.tar.gz -C /opt/azkaban/ \
 && ln -s /opt/azkaban/azkaban-web-server-3.84.4 /opt/azkaban/azkaban-web \
 && mv /tmp/start-azkaban.sh /usr/bin \
 && chmod a+x /usr/bin/start-azkaban.sh \
 && rm -rf /tmp/* 

WORKDIR /opt/azkaban/

ENV AZKABAN_EXE_HOME=/opt/azkaban/azkaban-exec \
    AZKABAN_WEB_HOME=/opt/azkaban/azkaban-web \
    PATH=${PATH}:${AZKABAN_EXE_HOME}/bin:${AZKABAN_WEB_HOME}/bin

ENTRYPOINT ["start-azkaban.sh"]
CMD [ "exe" ]