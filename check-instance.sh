#!/usr/bin/env bash
## @author     Lenin Meza - NA-AT | lmezaz@mnyl.com.mx
## @version    0.0.6

## check-instance.sh
## chmod 700 check-instance.sh
## sed 's/\r//' check-instance.sh > check-instance.tmp && mv check-instance.tmp check-instance.sh

set -o errexit
set -o pipefail
set -o nounset
# Debug
# set -o xtrace

# Informacion del script
__ROOT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__FILE="$(basename "${BASH_SOURCE[0]}")"
__DATE=`date +%Y%m%d_%H-%M`

## Informacion relevante en: config.php
__DB_HOST=$(grep "db_host_name" config.php | cut -d "'" -f4 | sed -E  's/(.*):(.*)/\1/')
__DB_INSTANCE=$(grep "db_host_instance" config.php | cut -d "'" -f4)
__DB_USER=$(grep "db_user_name" config.php | cut -d "'" -f4)
__DB_PASS=$(grep "db_password" config.php | cut -d "'" -f4)
__DB_NAME=$(grep "db_name" config.php | cut -d "'" -f4)
__DB_TYPE=$(grep "db_type" config.php | cut -d "'" -f4)
__DB_PORT=$(grep "db_port" config.php | cut -d "'" -f4)
if [ -z "$__DB_PORT" ]; then
__DB_PORT=$(grep "db_host_name" config.php | cut -d "'" -f4 | sed -E  's/(.*):(.*)/\2/')
fi
__DB_MANAGER=$(grep "db_manager" config.php | cut -d "'" -f4)
# __DB_ENCRYPT=$(grep "use_encryption" config.php | cut -d "'" -f4)
__HOST=$(grep "'host_name'" config.php | cut -d "'" -f4)
_URL=$(grep "'site_url'" config.php | cut -d "'" -f4)
## Informacion relevante en: .htaccess
__BASEDIR=$(grep "RewriteBase" .htaccess | cut -d "/" -f2)
echo -e '\E[37;44m'"\033[1m===[Información de la base de datos]===\033[0m"
echo -e "Host/port:\t$__DB_HOST"
echo -e "Instance:\t$__DB_INSTANCE"
echo -e "User:\t\t$__DB_USER"
echo -e "Pass:\t\t$__DB_PASS"
echo -e "Name:\t\t$__DB_NAME"
echo -e "Type:\t\t$__DB_TYPE"
echo -e "Port:\t\t$__DB_PORT"
echo -e "Manager:\t$__DB_MANAGER"
# echo -e "Encrypt:\t$__DB_ENCRYPT"
echo -e "Host:\t\t$__HOST"
echo -e "URL:\t\t$_URL"
echo ""
echo -e '\E[37;44m'"\033[1m===[Directorio del aplicativo]===\033[0m"
echo -e "RewriteBase:\t$__BASEDIR"
echo -e "Ruta absoluta:\t$__ROOT_PATH"
echo ""
echo -e '\E[37;44m'"\033[1m===[Espacio libre en el Fyle System]===\033[0m"
df -h .
echo ""
## Required File System Permissions on Linux
## http://support.sugarcrm.com/04_Knowledge_Base/02Administration/100Platform_Management/Required_File_System_Permissions_on_Linux/
echo -e '\E[37;44m'"\033[1m===[Permisos y owner de los archivos y directorios]===\033[0m"
echo "- 775 Para los directorios"
echo "- 664 para los archivos"
echo "- El owner debe ser el usuario de apache"
## echo -e "Usuario de Apache:\t$(lsof -i | grep :http | awk 'NR==1{ print $3}')"
echo -e "$__ROOT_PATH:\t\t$(stat --format '%a' $__ROOT_PATH) $(stat --format "%U:%G" $__ROOT_PATH)"
echo -e "config.php:\t\t$(stat --format '%a' config.php) $(stat --format "%U:%G" config.php)"
echo -e "config_override.php:\t$(stat --format '%a' config_override.php) $(stat --format "%U:%G" config_override.php)"
echo -e "sugarcrm.log:\t\t$(stat --format '%a' sugarcrm.log) $(stat --format "%U:%G" sugarcrm.log)"
echo -e "cache/:\t\t\t$(stat --format '%a' cache) $(stat --format "%U:%G" cache)"
echo -e "custom/:\t\t$(stat --format '%a' custom) $(stat --format "%U:%G" custom)"
echo -e "data/:\t\t\t$(stat --format '%a' data) $(stat --format "%U:%G" data)"
echo -e "modules/:\t\t$(stat --format '%a' modules) $(stat --format "%U:%G" modules)"
echo -e "include/:\t\t$(stat --format '%a' include) $(stat --format "%U:%G" include)"
echo -e "upload/:\t\t$(stat --format '%a' upload) $(stat --format "%U:%G" upload)"
echo -e ""

echo -e '\E[37;44m'"\033[1m==[Informacion de LAMP Stack]==\033[0m"
echo "Distribucion:"
cat /etc/redhat-release
echo "MySQL:"
service mysqld status
echo "PHP:"
php -v
echo "Apache:"
httpd -v
service httpd status
netstat -tulpn | grep httpd
