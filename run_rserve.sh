#!/bin/bash 

USERNAME=${USERNAME:-rserve}
PASSWORD=${PASSWORD:-rserve}

echo "${USERNAME} ${PASSWORD}" > ${RSERVE_HOME}/etc/Rserv.pwd

CONFIG_PATH=${RSERVE_HOME}/etc/Rserv.conf

R -e 'library(Rserve)' -e 'run.Rserve(config.file = "'${CONFIG_PATH}'")'
