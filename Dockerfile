FROM r-base:3.4.3

MAINTAINER Ian Sigmon <ians@labkey.com>

RUN apt-get update \
	&& apt-get install -y telnet \
		libcairo2-dev \
		libxt-dev

RUN install.r Rserve \
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds
RUN install.r Cairo

ENV RSERVE_HOME /opt/rserve

RUN mkdir -p ${RSERVE_HOME}/work

COPY etc ${RSERVE_HOME}/etc

COPY run_rserve.sh ${RSERVE_HOME}/bin/

RUN chmod -R 777 ${RSERVE_HOME}

VOLUME ["/volumes/data"]
VOLUME ["/volumes/catalina_home"]

## Change username and provide PASSWORD
ENV USERNAME ${USERNAME:-rserve}
ENV PASSWORD ${PASSWORD:-rserve}

EXPOSE 6311

HEALTHCHECK --interval=2s --timeout=3s \
 CMD sleep 1 | \
 		telnet localhost 6311 | \
		grep -q Rsrv0103QAP1 || exit 1

CMD ["/opt/rserve/bin/run_rserve.sh"]
