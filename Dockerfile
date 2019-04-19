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

RUN useradd -g docker rserve \
	&& mkdir ${RSERVE_HOME} \
	&& usermod -d ${RSERVE_HOME} rserve

RUN mkdir ${RSERVE_HOME}/work

COPY etc ${RSERVE_HOME}/etc

COPY run_rserve.sh ${RSERVE_HOME}/bin/

RUN chown -R rserve ${RSERVE_HOME} \
	&& chmod -R 775 ${RSERVE_HOME}

VOLUME ["/volumes/data"]
VOLUME ["/volumes/reports_temp"]

USER rserve

## Change username and provide PASSWORD
ENV USERNAME ${USERNAME:-rserve}
ENV PASSWORD ${PASSWORD:-rserve}

EXPOSE 6311

HEALTHCHECK --interval=2s --timeout=3s \
 CMD sleep 1 | \
 		telnet localhost 6311 | \
		grep -q Rsrv0103QAP1 || exit 1

CMD ["/opt/rserve/bin/run_rserve.sh"]
