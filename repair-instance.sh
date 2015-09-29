#!/usr/bin/env bash
## @author     Lenin Meza | NA-AT
## @version    0.0.2

## Sugar 7.5 Installation and Upgrade Guide
## http://support.sugarcrm.com/02_Documentation/01_Sugar_Editions/02_Sugar_Enterprise/Sugar_Enterprise_7.5/Installation_and_Upgrade_Guide/

## repair-instance.sh
## chmod 700 repair-instance.sh
## sed 's/\r//' repair-instance.sh > repair-instance.tmp && mv repair-instance.tmp repair-instance.sh

set -o errexit
set -o pipefail
set -o nounset
# Debug
# set -o xtrace

__START=`date +%s`

# Informacion del script
__ROOT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__FILE="$(basename "${BASH_SOURCE[0]}")"
__DATE=`date +%Y%m%d_%H-%M`

echo -e '\E[37;44m'"\033[1m===[Limpiar directorio cache]===\033[0m"
rm -rf ./cache/*
echo -e '\E[37;44m'"\033[1m===[Informacion del directorio cache y upload]===\033[0m"
ls -lah ./cache
ls -lah ./upload
echo -e '\E[37;44m'"\033[1m===[Contenido del directorio cache]===\033[0m"
ls -lah ./cache/
echo -e '\E[37;44m'"\033[1m===[Establecer owner de los archivos y directorios]===\033[0m"
chown -R apache:apache ./* .htaccess
echo -e '\E[37;44m'"\033[1m===[Permisos 755(Owner: Read, Write, Execute | Group: Read, Execute | Others: Read, Execute) a directorios]===\033[0m"
find ./* -type d -exec chmod 755 {} \;
echo -e '\E[37;44m'"\033[1m===[Permisos 644(Owner: Read, Write | Group: Read | Others: Read) a archivos]===\033[0m"
find ./* -type f -exec chmod 644 {} \;
echo -e '\E[37;44m'"\033[1m===[Permisos  775 a los directorios]===\033[0m"
echo "* cache"
echo "* custom"
echo "* data"
echo "* modules"
echo "* include"
echo "* upload"
chmod -R 775 cache/ custom/ data/ modules/ include/ upload/
echo -e '\E[37;44m'"\033[1m===[Permisos  664 a los archivos]===\033[0m"
if [ -f ./config.php ]; then
	echo "* config.php"
	chmod 664 config.php
fi
if [ -f ./config_override.php ]; then
	echo "* config_override.php"
	chmod 664 config_override.php
fi
if [ -f ./sugarcrm.log ]; then
	echo "* sugarcrm.log"
	chmod 664 sugarcrm.log
fi
echo -e '\E[47;31m'"\033[1m===[Reconstruir cache(URL del config.php)]===\033[0m"
_URL=$(grep "'site_url'" config.php | cut -d "'" -f4)
curl -k -X GET $_URL/ > /dev/null 2>&1

sudo -u apache php -f index.php > /dev/null 2>&1

__EXECUTION_TIME=$(expr `date +%s` - $__START)
echo "Tiempo de ejecucion: $__EXECUTION_TIME"
