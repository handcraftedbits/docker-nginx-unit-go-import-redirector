#!/bin/bash

. /opt/container/script/unit-utils.sh

# Check required environment variables and fix the NGINX unit configuration.

checkCommonRequiredVariables

requiredVariable REDIRECTOR_IMPORT
requiredVariable REDIRECTOR_REPO

if [ ! -z "${REDIRECTOR_VCS}" ]
then
     REDIRECTOR_VCS="-vcs ${REDIRECTOR_VCS}"
fi

notifyUnitLaunched

copyUnitConf nginx-unit-go-import-redirector > /dev/null

notifyUnitStarted

logUrlPrefix "go-import-redirector"

# Start go-import-redirector.

/opt/go-import-redirector/go-import-redirector -addr :80 ${REDIRECTOR_VCS} ${REDIRECTOR_IMPORT} ${REDIRECTOR_REPO}
