#!/bin/bash 

if [[ -z "${PASSWORD}" ]]; then
	echo "Must provide env PASSWORD"
	exit 1
fi

if [[! -w /volumes/data ] || [! -w /volumes/reports_temp ]]; then
	echo "Mapped volumes must exist and be writable"
	exit 1
fi

echo "${USERNAME} ${PASSWORD}" > ${RSERVE_HOME}/etc/Rserv.pwd

CONFIG_PATH=${RSERVE_HOME}/etc/Rserv.conf

R -e 'library(Rserve)' -e 'run.Rserve(config.file = "'${CONFIG_PATH}'")'
