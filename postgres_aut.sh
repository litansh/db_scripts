#!/bin/bash
#!/bin/sh -
######################################################
##                                                   #
   #        #############################          #
     #      #                           #        #
#######     #    Postgres Automation    #      #   ##
#           #                           #        #   #
#           #############################          # #
#                                                    #
############################################################################
 # Documentation                                                           #
 # Run variables_ function                                                 #
 # Check if first time installation is needed                              #
 # First time installation :                                               #
 #  Run first_install_ && first_initiate_postgres_ && check_postgres_info_ #
 #  && first_edit_conf_ && postgres_user_                                  #
 # Else :                                                                  #
 #  Go to main_menu_                                                       #
############################################################################
#
 #####################
 # General Variables #
 #####################
# Main variables
#
function variables_ () {
 fullversion=`find /usr -wholename '*/bin/postgres' | grep 'pgsql-' | cut -d/ -f3`
 number=`echo $fullversion | grep -Eo '[0-9]+$'`
 counter=0
 pgconf='/var/lib/pgsql/${number}/data/postgresql.conf'
 hbaconf='/var/lib/pgsql/${number}/data/pg_hba.conf'
 orghbaconf='/var/lib/pgsql/${number}/data/org-pg_hba.conf'
 serverinfodir='/usr/lib/pgsrv'
 serverinfofile='/usr/lib/pgsrv/info.log'
 iplist='/usr/lib/pgsrv/iplist.log'
 mkdir -p $serverinfo
}
#
 ###################
 # Check Functions #
 ###################
# Main check postgres function and network connectivity
#
function check_postgres_info_ () {
 if [[ -z $fullversion ]]; then
  first_install_
 else
  dnf info postgresql${number}-server postgresql${number} > $serverinfofile
 fi
}
#
 ##########################
 # Installation Functions #
 ##########################
# First time installation
#
function first_install_ () {
 dnf -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm &> /dev/null
 dnf module disable postgresql &> /dev/null
 dnf clean all &> /dev/null
 dnf -y install postgresql${number}-server postgresql${number} &> /dev/null
 first_initiate_postgres_
 check_postgres_info_
}
#
function postgres_user_ () {
sudo su - postgres -c "/opt/PostgreSQL/9.3/bin/initdb /opt/PostgreSQL/9.3/data/; sleep 2s; /opt/PostgreSQL/9.3/bin/pg_ctl -D /opt/PostgreSQL/9.3/data/ -l logfile start"

su - postgres
psql
\password postgres
\q
exit
}
#
 ######################
 # Initiate Functions #
 ######################
# First time initiation
#
function first_initiate_postgres_ () {
 sudo /usr/pgsql-${number}/bin/postgresql-${number}-setup initdb
 sudo systemctl enable --now postgresql-${number}
 start_status_service_
 first_edit_conf_
}
#
 ##################
 # Conf Functions #
 ##################
# Edit configuration files pg_hba.conf pgsql.conf
#
function ip_list_file_ () {
 echo '
 192.168.77.0
 192.168.181.0
 82.228.113.135
 ' > $iplist
}
#
function first_edit_conf_ () {
 ip_list_file_
 sed -i '/listen_addresses/s/^#//g' $pgconf
 sed -i '/port = 5432/s/^#//g' $pgconf
 sed -i 's/peer/md5/g' $hbaconf
 cp -r $hbaconf $orghbaconf &> /dev/null
 sed -i 's/peer/md5/g' $hbaconf
 cat $iplist | while read line; do
  linea="host       $line         md5"
  sed -i "/^$linea.*/i # IPv6" $hbaconf
 done
 postgres_user_
}
#
 #####################
 # Service Functions #
 #####################
# Check status and restart the service
#
function start_status_service_ (){
 checks=`systemctl status postgresql-${number} | grep 'active (running)' | wc -l`
 if [[ $checks == 0 ]] && [[ $counter < 3 ]]; then
  systemctl restart postgresql-${number}
  counter=$((counter + 1))
  start_status_service_
 elif [[ $checks == 0 ]] && [[ $counter > 2 ]]; then
   echo "Service failed to run after second time.."
 else
   echo "Status OK.."
 fi
}
#
 ##############
 # Start Here #
 ##############
# Main function
#
function main_fun_ () {
 variables_
 check_postgres_info_                           #<- [ G - 0 ]
}
#
 ###########
 # THE END #
 ###########
