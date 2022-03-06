#!/bin/bash
#!/bin/sh -
#
######################################################
##                                                   #
   #        #############################          #
     #      #                           #        #
#######     #    Postgres Automation    #      #   # #
#           #                           #        #   #
#           #############################          # #
#                                                    #
######################################################
#
 #####################
 # General Variables #
 #####################
# Main variables
#
counterb=0
M=mail
IP="$(hostname -I)"
FIRSTIP=`hostname -I | awk '{print $1,"\n"$2,"\n",$3 }' | sed '/:/d' | awk 'NF > 0' | sed 's/^[ \t]*//' | sed 's/[[:blank:]]*$//' | sed -n '1p'`
SECONDIP=`hostname -I | awk '{print $1,"\n"$2,"\n",$3 }' | sed '/:/d' | awk 'NF > 0' | sed 's/^[ \t]*//' | sed 's/[[:blank:]]*$//' | sed -n '2p'`
SIG1="Have a nice day"
SIG2="Security Assistance"
HN="$(hostname)"
DN=cglms.com
RM=litan@cglms.com
SM=$HN@$DM
D="$(date +"Time:%H:%M:%S" && date +"Date:%d.%m.%Y")"
E=echo
F=find
X=xargs
# Colors
export normal=`echo "\033[m"`
export menu=`echo "\033[36m"` #Blue
export bgmenu=`echo "\033[46m"` #Blue
export number=`echo "\033[33m"` #yellow
export bgred=`echo "\033[41m"`
export fgred=`echo "\033[31m"`
export green=`echo "\033[32m"`
export blink=`echo "\033[5m" `
export lightbggrey=`echo "\033[47m" `
export bggrey=`echo "\033[100m" `
export grey=`echo "\033[90m" `
export menu1=`echo -e "\033[100m"`
export black=`echo -e "\033[30m"`
export bggreen=`echo -e "\033[42m"`
export bgwhite=`echo -e "\033[100m"`
export bold=`echo -e "\033[1m"`
export lgreen=`echo -e "\e[92m"`
export bggrey=`echo "\033[100m" `
# Config files
rm -rf /tmp/helpme/pgsrv/*.log
serverinfodir='/tmp/helpme/pgsrv'
mkdir -p $serverinfodir
mkdir -p /tmp/helpme
touch /tmp/helpme/.pgcount
niplist='/usr/lib/pgsrv/niplist.log'
fullversion=`find /usr -wholename '*/bin/postgres' | grep 'pgsql-' | cut -d/ -f3`
numbera=`echo $fullversion | grep -Eo '[0-9]+$'`
pgconf="/var/lib/pgsql/$numbera/data/postgresql.conf"
hbaconf="/var/lib/pgsql/$numbera/data/pg_hba.conf"
orghbaconf="/var/lib/pgsql/$numbera/data/org-pg_hba.conf"
serverinfofile='/tmp/helpme/pgsrv/info.log'
tmppermittedlist='/tmp/helpme/pgsrv/tmppermittedlist.log'
iplist='/tmp/helpme/pgsrv/iplist.log'
mainiplist='/tmp/helpme/pgsrv/mainiplist.log'
dblist='/tmp/helpme/pgsrv/dblist.log'
userslist='/tmp/helpme/pgsrv/userslist.log'
permittedlist='/tmp/helpme/pgsrv/permittedlist.log'
trustedlist='/tmp/helpme/pgsrv/trustedlist.log'
cat /var/lib/pgsql/$numbera/data/pg_hba.conf | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" > $iplist
cat $iplist | while read liner; do
 if [[ $liner != '127.0.0.1' ]]; then
  cat /var/lib/pgsql/$numbera/data/pg_hba.conf | grep "host" | grep "$liner" | awk '{print $4, $5}' >> $mainiplist
 else
  if [[ $counterb == 0 ]]; then
   cat /var/lib/pgsql/$numbera/data/pg_hba.conf | grep "host" | grep "$liner" | awk '{print $4, $5}' | head -1 >> $mainiplist
  fi
  counterb=$((counterb + 1))
 fi
done
identcount=`cat $mainiplist | grep ident | wc -l`
peercount=`cat $mainiplist | grep peer | wc -l`
cat $mainiplist | while read lineara; do
 checker=`echo $lineara | grep trust | wc -l`
 if [[ $checker > 0 ]]; then
  echo -e "$lineara" | awk '{print $1}' >> $trustedlist
 else
  echo -e "$lineara" >> $permittedlist
 fi
done
if [[ -f $iplist ]]; then
 sed -i '/^$/d' $iplist
elif [[ -f $mainiplist ]]; then
 sed -i '/^$/d' $mainiplist
elif [[ -f $trustedlist ]]; then
 sed -i '/^$/d' $trustedlist
elif [[ -f $permittedlist ]]; then
 sed -i '/^$/d' $permittedlist
fi
PGPASSWORD=myPassword psql -U postgres -c "\l" | awk '{print $1}' | grep -v 'List' | grep -v 'Name' | grep -v '-' | grep -v '|' | grep -v '(' | sed '/^$/d' > $dblist
PGPASSWORD=myPassword psql -U postgres -c "\du" | awk '{print $1}' | grep -v 'Role' | grep -v 'List' | grep -v 'Name' | grep -v '-' | grep -v '|' | grep -v '(' | sed '/^$/d' > $userslist
dbcount=`cat $dblist | wc -l`
userscount=`cat $userslist | wc -l`
trustedcount=`cat /tmp/helpme/pgsrv/trustedlist.log | wc -l`
permittedcount=`cat /tmp/helpme/pgsrv/permittedlist.log | wc -l`
sumcount=$((trustedcount+permittedcount))
#
function pause_witout_exit_ () {
  local C1="$(printf "\n\t\t  ${menu}Press [ ${number}Enter ${menu}] to continue ...${menu}${normal}\n")"

  read -sn 1 -p "$C1" fackEnterKey
}
#
 ###########
 # Banners #
 ###########
#
function BANNER_call_allert_title_ () {
  clear && clear
	echo -e "\t\t   ${menu}${menu1}---------------------------------------------------------------${normal}"
	echo -e "\t\t   ${menu}${menu1}                      ${bgwhite}${menu}Postgres Management${menu}${menu1}                      ${normal}"
	echo -e "\t\t   ${menu}${menu1}---------------------------------------------------------------${normal}"
}
#
function BANNER_call_allert_title_pr_ () {
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
	echo -e "${menu}${menu1}                                     ${bgwhite}${menu}Installing postgres repo${menu}${menu1}                                           ${normal}"
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
}
#
function BANNER_call_allert_title_dbc_ () {
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
	echo -e "${menu}${menu1}                                     ${bgwhite}${menu}Database has been created${menu}${menu1}                                           ${normal}"
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
}
#
function BANNER_call_allert_title_dpg_ () {
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
	echo -e "${menu}${menu1}                                       ${bgwhite}${menu}Disabling Postgres${menu}${menu1}                                               ${normal}"
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
}
#
function BANNER_call_allert_title_ipg_ () {
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
	echo -e "${menu}${menu1}                    ${bgwhite}${menu}Installing postgres server $numbera.. This might take a minute..${menu}${menu1}                          ${normal}"
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
}
#
function BANNER_call_allert_title_idb_ () {
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
	echo -e "${menu}${menu1}                                       ${bgwhite}${menu}Initiating Database${menu}${menu1}                                              ${normal}"
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
}
#
function BANNER_call_allert_title_rss_add_ () {
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
	echo -e "${menu}${menu1}                                 ${bgwhite}${menu}$line is being added.. please wait..${menu}${menu1}                           ${normal}"
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
}
#
function BANNER_call_allert_title_rss_rmv_ () {
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
	echo -e "${menu}${menu1}                                 ${bgwhite}${menu}$line is being removed.. please wait..${menu}${menu1}                         ${normal}"
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
}
#
function BANNER_call_allert_title_puc_ () {
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
	echo -e "${menu}${menu1}                               ${bgwhite}${menu}Postgres user created with password 'myPassword'${menu}${menu1}                                    ${normal}"
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
}
#
function BANNER_call_allert_title_pue_ () {
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
	echo -e "${menu}${menu1}                                       ${bgwhite}${menu}Postgres user exists!${menu}${menu1}                                            ${normal}"
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
}
#
function BANNER_call_allert_title_fwu_ () {
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
	echo -e "${menu}${menu1}                                    ${bggreen}${menu}firewall service running, please adjust it!${menu}${menu1}                                       ${normal}"
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
}
#
function BANNER_call_allert_title_fwd_ () {
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
	echo -e "${menu}${menu1}                                    ${bgred}${menu}firewall service is down!${menu}${menu1}                                       ${normal}"
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
}
#
function BANNER_call_allert_title_hba_ () {
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
	echo -e "${menu}${menu1}                                  ${bgwhite}${menu}Inserting subnets to pg_hba.conf${menu}${menu1}                                      ${normal}"
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
}
#
function BANNER_call_allert_title_wreq_ () {
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
	echo -e "${menu}${menu1}                              ${bgred}${menu}Posted a wrong request! Please re-enter..${menu}${menu1}                                 ${normal}"
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
}
#
function BANNER_call_allert_title_wreqaa_ () {
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
	echo -e "${menu}${menu1}                              ${bgred}${menu}Can not leave empty! Please re-enter..${menu}${menu1}                                    ${normal}"
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
}
#
function BANNER_call_allert_title_wreqaaip_ () {
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
	echo -e "${menu}${menu1}                              ${bgred}${menu}Not a valid IP address! Please re-enter..${menu}${menu1}                             ${normal}"
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
}
#
function BANNER_call_allert_title_wreqaaipe_ () {
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
	echo -e "${menu}${menu1}                              ${bgred}${menu}IP address already exists! Please re-enter..${menu}${menu1}                  ${normal}"
	echo -e "${menu}${menu1}--------------------------------------------------------------------------------------------------------${normal}"
}
#
 #########
 # Logos #
 #########
#
function LOGO_logo_findme_ () {
cat << "EOF"
                                             _,.
                                           ,` -.)
                                          '( _/'-\\-.
                                         /,|`--._,-^|            ,
                                         \_| |`-._/||          ,'|
                                           |  `-, / |         /  /
                                           |     || |        /  /
                                            `r-._||/   __   /  /
                                        __,-<_     )`-/  `./  /
                                       '  \   `---'   \   /  /
                                      /    |           |./  /
                                      \    /   PGAuto  //  /
                                      \_/' \          |/  /
                                        |    |   _,^-'/  /
                                        |    , ``  (\/  /_
                                         \,.->._    \X-=/^
                                         (  /   `-._//^`
                                          `Y-.____(__}
                                           |     {__)
                                                  ()`
EOF
}
#
function LOGO_logo_p_good_ () {
clear && clear && clear
cat << "EOF"
















                                 Packed up and good to GO Boss!!!
                                 -------------------------------------------
                                 \
                                  \
                                        .--.   ,||
                                       |o_o |  ({O'
                                       |:_/ |   /
                                      //   \ \ /
                                     (|     |
                                    /'\_   _/`\
                                    \___)=(___/
EOF
sleep 1 && clear
}
#
function LOGO_logo_p_goodbye_ () {
echo -e "${normal}"
clear && clear && clear
cat << "EOF"
















                                 GoodBye Boss!!!
                                 ------------------------
                                 \
                                  \
                                        .--.   ,||
                                       |o_o |  ({O'
                                       |:_/ |   /
                                      //   \ \ /
                                     (|     |
                                    /'\_   _/`\
                                    \___)=(___/
EOF
rm -rf /tmp/helpme/pgsrv/*.log
sleep 1 && clear && exit
}
#
 ###########
 # Borders #
 ###########
# Creates and prints lists
function BORDER_current_ip_list_permitted_ () {
if [[ ! -f $permittedlist ]]; then
 echo "No Permitted IPs have been set" > $permittedlist
fi
 listaa=`cat $permittedlist | column -t`
 longstr=`(echo -e "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" | awk '{if(length>x){x=length;y=$0}}END{print y}')`
 longlen=39
 edge=$(echo -e "$longstr" | sed 's/./-/g')
 echo -e "${grey}\t\t   +$edge---+${normal}"
 while IFS= read -r line; do
  strlen=${#line}
  echo -e -n "${grey}\t\t   |${normal} \t\t      $line${normal}${normal}"
  gap=$((longlen - strlen))
  if [ "$gap" > 0 ]; then
   for i in $(seq 1 $gap); do echo -n " "; done
   echo -e "${grey}    |${normal}"
  else
   echo -e "${grey}|${normal}"
  fi
 done < <(printf '%s\n' "$listaa")
 echo -e "${grey}\t\t   +$edge---+${normal}"
}
#
function BORDER_current_ip_list_ () {
if [[ ! -f $trustedlist ]]; then
 echo "No Trusted IPs have been set" > $trustedlist
fi
 listaa=`cat $trustedlist | column -t`
 longstr=`(echo -e "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" | awk '{if(length>x){x=length;y=$0}}END{print y}')`
 longlen=39
 edge=$(echo -e "$longstr" | sed 's/./-/g')
 echo -e "${grey}\t\t   +$edge---+${normal}"
 while IFS= read -r line; do
  strlen=${#line}
  echo -e -n "${grey}\t\t   |${normal}\t\t\t$line${normal}${normal}"
  gap=$((longlen - strlen))
  if [ "$gap" > 0 ]; then
   for i in $(seq 1 $gap); do echo -n " "; done
   echo -e "${grey}  |${normal}"
  else
   echo -e "${grey}|${normal}"
  fi
 done < <(printf '%s\n' "$listaa")
 echo -e "${grey}\t\t   +$edge---+${normal}"
}
#
function BORDER_show_db_ (){
 PGPASSWORD=myPassword psql -U postgres -c "\l" | awk '{print $1}' | grep -v 'List' | grep -v 'Name' | grep -v '-' | grep -v '|' | grep -v '(' | sed '/^$/d' > $dblist
 listaa=`cat $dblist`
 longstr=`(echo -e "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" | awk '{if(length>x){x=length;y=$0}}END{print y}')`
 longlen=39
 edge=$(echo -e "$longstr" | sed 's/./-/g')
 echo -e "${grey}\t\t   +$edge---+${normal}"
 while IFS= read -r line; do
  strlen=${#line}
  echo -e -n "${grey}\t\t   |${normal} ${bgreen}\t\t\t$line${normal}${normal}"
  gap=$((longlen - strlen))
  if [ "$gap" > 0 ]; then
   for i in $(seq 1 $gap); do echo -n " "; done
   echo -e "${grey}  |${normal}"
  else
   echo -e "${grey}|${normal}"
  fi
 done < <(printf '%s\n' "$listaa")
 echo -e "${grey}\t\t   +$edge---+${normal}"
}
#
function BORDER_show_db_per_user_ (){
 FULL14='/usr/lib/pgsrv/rrplist.log'
 listaa=`cat $FULL14`
 longstr=`(echo -e "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" | awk '{if(length>x){x=length;y=$0}}END{print y}')`
 longlen=39
 edge=$(echo -e "$longstr" | sed 's/./-/g')
 echo -e "${grey}\t\t    +$edge---+${normal}"
 while IFS= read -r line; do
  strlen=${#line}
  echo -e -n "${grey}\t\t    |${normal} ${bgreen}\t\t\t$line${normal}${normal}"
  gap=$((longlen - strlen))
  if [ "$gap" > 0 ]; then
   for i in $(seq 1 $gap); do echo -n " "; done
   echo -e "${grey}   |${normal}"
  else
   echo -e "${grey}|${normal}"
  fi
 done < <(printf '%s\n' "$listaa")
 echo -e "${grey}\t\t    +$edge---+${normal}"
}
#
function BORDER_show_users_ (){
 PGPASSWORD=myPassword psql -U postgres -c "\du" | awk '{print $1}' | grep -v 'Role' | grep -v 'List' | grep -v 'Name' | grep -v '-' | grep -v '|' | grep -v '(' | sed '/^$/d' > $userslist
 listaa=`cat $userslist`
 longstr=`(echo -e "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" | awk '{if(length>x){x=length;y=$0}}END{print y}')`
 longlen=35
 edge=$(echo -e "$longstr" | sed 's/./-/g')
 echo -e "${grey}\t\t   +$edge---+${normal}"
 while IFS= read -r line; do
  strlen=${#line}
  echo -e -n "${grey}\t\t   |${normal} ${bgreen}\t\t\t     $line${normal}${normal}"
  gap=$((longlen - strlen))
  if [ "$gap" > 0 ]; then
   for i in $(seq 1 $gap); do echo -n " "; done
   echo -e "${grey} |${normal}"
  else
   echo -e "${grey}|${normal}"
  fi
 done < <(printf '%s\n' "$listaa")
 echo -e "${grey}\t\t   +$edge---+${normal}"
}
#
 ###################
 # Alert Functions #
 ###################
# Mail alert function
#
function MAIL_mail-panic_ () {
{ $E "Hi there !" ;$E "" ;$E ""$HN" *"$IP"* have problem with disk space". ;$E "Server Details:" ;$E "Local ip: "$IP"" ;$E "Public ip: $PIP" ;$E "Name: $HN" ; $E "Geo Location: $GL2" ; $E "" ; $E  "$DU1 " ; $E ""$TD"" ; $E "Exact time of event:" ; $E "$D" ; $E "  " ; $E "" ; $E "Yours", ; $E "$SIG2" ; } | sed -e 's/^[ \t]*//' | $M -s "***On server "$HN" disk '95%' full !!! "  -r " <$HN@$DN>" $RM
}
#
 ###################
 # Check Functions #
 ###################
# Main check postgres function
#
function CHECK_check_postgres_info_ () {
 fullversion=`find /usr -wholename '*/bin/postgres' | grep 'pgsql-' | cut -d/ -f3`
 numbera=`echo $fullversion | grep -Eo '[0-9]+$'`
 if [[ -z $fullversion ]]; then
  EDITCONF_ip_list_file_
  CONFIG_first_time_configuration_
 else
  dnf info postgresql${numbera}-server postgresql${numbera} > $serverinfofile
  DROPDOWN_main_menu_
 fi
}
#
 ##########################
 # Installation Functions #
 ##########################
# First time installation
#
function INSTALL_first_install_ () {

 clear && LOGO_logo_findme_ && BANNER_call_allert_title_pr_
 dnf -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm  &> /dev/null
 sleep 2 && clear && LOGO_logo_findme_ && BANNER_call_allert_title_dpg_
 dnf module disable postgresql -y  &> /dev/null
 dnf clean all  &> /dev/null
 sleep 2 && clear && LOGO_logo_findme_ && BANNER_call_allert_title_ipg_
 dnf -y install postgresql${numbera}-server postgresql${numbera}  &> /dev/null
 INITIATE_first_initiate_postgres_
}
#
function INSTALL_postgres_user_ () {
 checkpgu=`compgen -u | grep 'postgres' | wc -l`
if [[ $checkpgu == 0 ]]; then
su -c "psql" - postgres << "EOF"
ALTER USER postgres PASSWORD 'myPassword';
\q
EOF
fi
sleep 2 && clear && LOGO_logo_findme_ && BANNER_call_allert_title_pue_
SERVICE_start_status_service_
 checkfw=`systemctl status firewalld | grep 'active (running)' | wc -l`
 if [[ $checkfw > 0 ]]; then
   sleep 2 && clear && LOGO_logo_findme_ && BANNER_call_allert_title_fwu_
 else
   sleep 2 && clear && LOGO_logo_findme_ && BANNER_call_allert_title_fwd_
 fi
 LOGO_logo_p_good_
 DROPDOWN_main_menu_
}
#
 ######################
 # Initiate Functions #
 ######################
# First time initiation
#
function INITIATE_first_initiate_postgres_ () {
 sleep 2 && clear && LOGO_logo_findme_ && BANNER_call_allert_title_idb_
 sudo /usr/pgsql-${numbera}/bin/postgresql-${numbera}-setup initdb &> /dev/null
 sudo systemctl enable --now postgresql-${numbera} &> /dev/null
 CHECK_check_postgres_info_
 EDITCONF_first_edit_conf_
}
#
 ##################
 # Conf Functions #
 ##################
# Edit configuration files pg_hba.conf pgsql.conf
#
function EDITCONF_ip_list_file_ () {
echo '192.168.77.0
192.168.99.0
192.168.191.0
192.168.181.0
82.228.113.135' > $iplist
}
#
function EDITCONF_first_edit_conf_ () {
 EDITCONF_ip_list_file_
 sleep 2 && clear && LOGO_logo_findme_ && BANNER_call_allert_title_hba_ && echo -e "\n\n\t\t\t\t        ${menu1}Inserting these IPs:${normal}\n\n" && BORDER_current_ip_list_ && sleep 3
 sed -i '/listen_addresses/s/^#//g' $pgconf
 sed -i '/port = 5432/s/^#//g' $pgconf
 sed -i 's/localhost/*/g' $pgconf
 cp -r $hbaconf $orghbaconf &> /dev/null
 sed -i 's/peer/md5/g' $hbaconf
 sed -i 's/ident/md5/g' $hbaconf
 cat $iplist | while read line; do
  checksub=`echo $line | grep -Eo '[0-9]+$'`
  checkbit=`echo $line | grep '/' | wc -l`
  checkip=`cat $hbaconf | grep $line | wc -l`
  if [[ $checkbit > 0 ]] && [[ $checkip == 0 ]]; then
   linea="host    all             all             ${line}         trust"
   sed -i "/^# IPv6.*/i aaa" $hbaconf
   sed -i "s|aaa|$linea|" $hbaconf
   SERVICE_start_status_service_
  elif [[ $checkbit == 0 ]] && [[ $checkip == 0 ]] || [[ $line == '192.168.1.1' ]] || [[ $line == '192.168.2.2' ]]; then
   if [[ $checksub == 0 ]]; then
    linea="host    all             all             ${line}/24        trust"
    sed -i "/^# IPv6.*/i aaa" $hbaconf
    sed -i "s|aaa|$linea|" $hbaconf
    SERVICE_start_status_service_
   else
    linea="host    all             all             ${line}/32        trust"
    sed -i "/^# IPv6.*/i aaa" $hbaconf
    sed -i "s|aaa|$linea|" $hbaconf
    SERVICE_start_status_service_
   fi
  fi
 done
 INSTALL_postgres_user_
}
#
function EDITCONF_user_permit_edit_conf_ () {
 nniplist='/usr/lib/pgsrv/nniplist.log'
 echo > $nniplist
 sed -i '/^$/d' $nniplist
 echo $answer | tr " " "\n" > $nniplist
 cp -r $hbaconf $orghbaconf &> /dev/null
 cat $nniplist | while read line; do
  checkera=`cat $hbaconf | grep $line | wc -l`
  if [[ $checkera == 0 ]] || [[ $line == '192.168.1.1' ]] || [[ $line == '192.168.2.2' ]]; then
  if [[ $line =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
   checksub=`echo $line | grep -Eo '[0-9]+$'`
   checkbit=`echo $line | grep '/' | wc -l`
   checkip=`cat $hbaconf | grep $line | wc -l`
   if [[ $checkbit > 0 ]] && [[ $checkip == 0 ]]; then
    linea="host    $DBNAME             $USERNAME             ${line}         md5"
    sed -i "/^# IPv6.*/i aaa" $hbaconf
    sed -i "s|aaa|$linea|" $hbaconf
    SERVICE_start_status_service_
   elif [[ $checkbit == 0 ]] && [[ $checkip == 0 ]] || [[ $line == '192.168.1.1' ]] || [[ $line == '192.168.2.2' ]]; then
    if [[ $checksub == 0 ]]; then
     linea="host    $DBNAME             $USERNAME             ${line}/24        md5"
     sed -i "/^# IPv6.*/i aaa" $hbaconf
     sed -i "s|aaa|$linea|" $hbaconf
     SERVICE_start_status_service_
    else
     linea="host    $DBNAME             $USERNAME             ${line}/32        md5"
     sed -i "/^# IPv6.*/i aaa" $hbaconf
     sed -i "s|aaa|$linea|" $hbaconf
     SERVICE_start_status_service_
    fi
   fi
  else
   clear && LOGO_logo_findme_ && BANNER_call_allert_title_wreqaaip_ && sleep 2
  fi
 else
  clear && LOGO_logo_findme_ && BANNER_call_allert_title_wreqaaipe_ && sleep 2 && DROPDOWN_allow_from_
 fi
 done
}
#
function EDITCONF_further_edit_conf_ () {
 nniplist='/usr/lib/pgsrv/nniplist.log'
 cp -r $hbaconf $orghbaconf &> /dev/null
 cat $nniplist | while read line; do
  checkera=`cat $hbaconf | grep $line | wc -l`
  if [[ $checkera == 0 ]] || [[ $line == '192.168.1.1' ]] || [[ $line == '192.168.2.2' ]]; then
  if [[ $line =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
   checksub=`echo $line | grep -Eo '[0-9]+$'`
   checkbit=`echo $line | grep '/' | wc -l`
   checkip=`cat $hbaconf | grep $line | wc -l`
   if [[ $checkbit > 0 ]] && [[ $checkip == 0 ]]; then
    linea="host    all             all             ${line}         md5"
    sed -i "/^# IPv6.*/i aaa" $hbaconf
    sed -i "s|aaa|$linea|" $hbaconf
    echo "${line} md5" >> $permittedlist
    echo "${line} md5" >> $mainiplist
    SERVICE_start_status_service_
   elif [[ $checkbit == 0 ]] && [[ $checkip == 0 ]] || [[ $line == '192.168.1.1' ]] || [[ $line == '192.168.2.2' ]]; then
    if [[ $checksub == 0 ]]; then
     linea="host    all             all             ${line}/24        md5"
     sed -i "/^# IPv6.*/i aaa" $hbaconf
     sed -i "s|aaa|$linea|" $hbaconf
     echo "${line}/24 md5" >> $permittedlist
     echo "${line}/24 md5" >> $mainiplist
     SERVICE_start_status_service_
    else
     linea="host    all             all             ${line}/32        md5"
     sed -i "/^# IPv6.*/i aaa" $hbaconf
     sed -i "s|aaa|$linea|" $hbaconf
     echo "${line}/32 md5" >> $permittedlist
     echo "${line}/32 md5" >> $mainiplist
     SERVICE_start_status_service_
    fi
   fi
  else
   clear && LOGO_logo_findme_ && BANNER_call_allert_title_wreqaaip_ && sleep 2 && DROPDOWN_permit_trust_
  fi
 else
  clear && LOGO_logo_findme_ && BANNER_call_allert_title_wreqaaipe_ && sleep 2 && DROPDOWN_permit_trust_
 fi
 done
DROPDOWN_main_menu_
}
#
function EDITCONF_further_edit_conf_trust_ () {
 nniplist='/usr/lib/pgsrv/nniplist.log'
 cp -r $hbaconf $orghbaconf &> /dev/null
 cat $nniplist | while read line; do
   checkera=`cat $hbaconf | grep $line | wc -l`
   if [[ $checkera == 0 ]] || [[ $line == '192.168.1.1' ]] || [[ $line == '192.168.2.2' ]]; then
  if [[ $line =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
   checksub=`echo $line | grep -Eo '[0-9]+$'`
   checkbit=`echo $line | grep '/' | wc -l`
   checkip=`cat $hbaconf | grep $line | wc -l`
   if [[ $checkbit > 0 ]] && [[ $checkip == 0 ]]; then
    linea="host    all             all             ${line}         trust"
    sed -i "/^# IPv6.*/i aaa" $hbaconf
    sed -i "s|aaa|$linea|" $hbaconf
    echo "${line} trust" >> $permittedlist
    echo "${line} trust" >> $mainiplist
    SERVICE_start_status_service_
   elif [[ $checkbit == 0 ]] && [[ $checkip == 0 ]] || [[ $line == '192.168.1.1' ]] || [[ $line == '192.168.2.2' ]]; then
    if [[ $checksub == 0 ]]; then
     linea="host    all             all             ${line}/24        trust"
     sed -i "/^# IPv6.*/i aaa" $hbaconf
     sed -i "s|aaa|$linea|" $hbaconf
     echo "${line}/24 trust" >> $permittedlist
     echo "${line}/24 trust" >> $mainiplist
     SERVICE_start_status_service_
    else
     linea="host    all             all             ${line}/32        trust"
     sed -i "/^# IPv6.*/i aaa" $hbaconf
     sed -i "s|aaa|$linea|" $hbaconf
     echo "${line}/32 trust" >> $permittedlist
     echo "${line}/32 trust" >> $mainiplist
     SERVICE_start_status_service_
    fi
   fi
  else
   clear && LOGO_logo_findme_ && BANNER_call_allert_title_wreqaaip_ && sleep 2 && DROPDOWN_permit_trust_
  fi
else
 clear && LOGO_logo_findme_ && BANNER_call_allert_title_wreqaaipe_ && sleep 2 && DROPDOWN_permit_trust_
fi
 done
DROPDOWN_main_menu_
}
#
function EDITCONF_further_edit_conf_ident_ () {
 nniplist='/usr/lib/pgsrv/nniplist.log'
 cp -r $hbaconf $orghbaconf &> /dev/null
 cat $nniplist | while read line; do
   checkera=`cat $hbaconf | grep $line | wc -l`
   if [[ $checkera == 0 ]] || [[ $line == '192.168.1.1' ]] || [[ $line == '192.168.2.2' ]]; then
  if [[ $line =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
   checksub=`echo $line | grep -Eo '[0-9]+$'`
   checkbit=`echo $line | grep '/' | wc -l`
   checkip=`cat $hbaconf | grep $line | wc -l`
   if [[ $checkbit > 0 ]] && [[ $checkip == 0 ]]; then
    linea="host    all             all             ${line}         ident"
    sed -i "/^# IPv6.*/i aaa" $hbaconf
    sed -i "s|aaa|$linea|" $hbaconf
    echo "${line} ident" >> $permittedlist
    echo "${line} ident" >> $mainiplist
    SERVICE_start_status_service_
   elif [[ $checkbit == 0 ]] && [[ $checkip == 0 ]] || [[ $line == '192.168.1.1' ]] || [[ $line == '192.168.2.2' ]]; then
    if [[ $checksub == 0 ]]; then
     linea="host    all             all             ${line}/24        ident"
     sed -i "/^# IPv6.*/i aaa" $hbaconf
     sed -i "s|aaa|$linea|" $hbaconf
     echo "${line}/24 ident" >> $permittedlist
     echo "${line}/24 ident" >> $mainiplist
     SERVICE_start_status_service_
    else
     linea="host    all             all             ${line}/32        ident"
     sed -i "/^# IPv6.*/i aaa" $hbaconf
     sed -i "s|aaa|$linea|" $hbaconf
     echo "${line}/32 ident" >> $permittedlist
     echo "${line}/32 ident" >> $mainiplist
     SERVICE_start_status_service_
    fi
   fi
  else
   clear && LOGO_logo_findme_ && BANNER_call_allert_title_wreqaaip_ && sleep 2 && DROPDOWN_permit_trust_
  fi
else
 clear && LOGO_logo_findme_ && BANNER_call_allert_title_wreqaaipe_ && sleep 2 && DROPDOWN_permit_trust_
fi
 done
DROPDOWN_main_menu_
}
#
function EDITCONF_further_edit_conf_peer_ () {
 nniplist='/usr/lib/pgsrv/nniplist.log'
 cp -r $hbaconf $orghbaconf &> /dev/null
 cat $nniplist | while read line; do
   checkera=`cat $hbaconf | grep $line | wc -l`
   if [[ $checkera == 0 ]] || [[ $line == '192.168.1.1' ]] || [[ $line == '192.168.2.2' ]]; then
  if [[ $line =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
   checksub=`echo $line | grep -Eo '[0-9]+$'`
   checkbit=`echo $line | grep '/' | wc -l`
   checkip=`cat $hbaconf | grep $line | wc -l`
   if [[ $checkbit > 0 ]] && [[ $checkip == 0 ]]; then
    linea="host    all             all             ${line}         peer"
    sed -i "/^# IPv6.*/i aaa" $hbaconf
    sed -i "s|aaa|$linea|" $hbaconf
    echo "${line} peer" >> $permittedlist
    echo "${line} peer" >> $mainiplist
    SERVICE_start_status_service_
   elif [[ $checkbit == 0 ]] && [[ $checkip == 0 ]] || [[ $line == '192.168.1.1' ]] || [[ $line == '192.168.2.2' ]]; then
    if [[ $checksub == 0 ]]; then
     linea="host    all             all             ${line}/24        peer"
     sed -i "/^# IPv6.*/i aaa" $hbaconf
     sed -i "s|aaa|$linea|" $hbaconf
     echo "${line}/24 peer" >> $permittedlist
     echo "${line}/24 peer" >> $mainiplist
     SERVICE_start_status_service_
    else
     linea="host    all             all             ${line}/32        peer"
     sed -i "/^# IPv6.*/i aaa" $hbaconf
     sed -i "s|aaa|$linea|" $hbaconf
     echo "${line}/32 peer" >> $permittedlist
     echo "${line}/32 peer" >> $mainiplist
     SERVICE_start_status_service_
    fi
   fi
  else
   clear && LOGO_logo_findme_ && BANNER_call_allert_title_wreqaaip_ && sleep 2 && DROPDOWN_permit_trust_
  fi
else
 clear && LOGO_logo_findme_ && BANNER_call_allert_title_wreqaaipe_ && sleep 2 && DROPDOWN_permit_trust_
fi
 done
DROPDOWN_main_menu_
}
#
function EDITCONF_further_edit_conf_remove_ () {
nniplist='/usr/lib/pgsrv/nniplist.log'
cat $nniplist | while read line; do
 if [[ $line =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  sed -i "/$line/d" $hbaconf
  sed -i "/$line/d" $mainiplist
  line1=`echo $line | awk '{print $1}'`
  sed -i "/$line1/d" $permittedlist
  sed -i "/$line1/d" $trustedlist
  SERVICE_start_status_service_
 fi
done
DROPDOWN_remove_ip_
}
#
 #####################
 # Service Functions #
 #####################
# Check status and restart the service
#
function SERVICE_start_status_service_ (){
 systemctl restart postgresql-${numbera}
 checks=`systemctl status postgresql-${numbera} | grep 'active (running)' | wc -l`
 if [[ $checks == 1 ]]; then
  clear
 elif [[ $checks == 0 ]] && [[ $countera < 3 ]]; then
  countera=$((countera + 1))
  SERVICE_start_status_service_
 elif [[ $checks == 0 ]] && [[ $countera > 2 ]]; then
  echo "Service failed to run after third time.."
 fi
}
#
 ##########################
 # Dashboards - Sub Menus #
 ##########################
# GUI Menus
function CONFIG_first_time_configuration_ () {
 clear && clear && clear
 BANNER_call_allert_title_
 echo -e "\n\t\t\t\t ${menu}${menu1}Postgres first time configuration${normal}\n"
 LOGO_logo_findme_
  echo -e "\n\t\t\t\t             ${menu1}Step 1${normal}\n"
 echo -e "\t\t\t\t     *${menu}No Postgres detected${normal}*\n"
 echo -e "\t\t\t\t          ${number}1. ${menu}Install${normal}"
 echo -e "\t\t\t\t          ${number}2. ${menu}Exit${normal}"
 local C1="$(printf "\t\t\t\t          ${bggrey}${black}${blink}=>${normal}${menu}: ${normal}")"
 read -e -p "$C1" answer
 if [[ $answer == 1 ]]; then
  INSTALL_first_install_
 else
  clear && clear
  LOGO_logo_p_goodbye_
 fi
}
#
function CONFIG_add_ip_hba_ () {
 clear && clear && clear
 BANNER_call_allert_title_
 nniplist='/usr/lib/pgsrv/nniplist.log'
 echo -e "\n\t\t\t\t        ${menu}${menu1}Add IPs to Permitted${normal}\n"
 printf "\n\t\t\t\t            ${menu}Trusted IPs${normal}\n"
 BORDER_current_ip_list_
 printf "\n\t\t\t\t           ${menu}Permitted IPs${normal}\n"
 BORDER_current_ip_list_permitted_
 echo -e "\n\t\t    ${menu}Add IP Address ${normal}${menu}(like:${number}192.168.1.1 192.168.10.0 192.168.9.0/24${normal}${menu})${normal}"
 echo -e "\n\t\t                  ${menu} Press [${normal}${number}ESC${normal}${menu}] or [${number}b${normal}${menu}] to Back${normal} \n"
 local C1="$(printf "\n\t\t\t  ${bggrey}${black}${blink}=>${normal}${menu}: ${normal}")"
 read -e -p "$C1" answer
 if [ -z "$answer" ]; then
  clear && LOGO_logo_findme_ && BANNER_call_allert_title_wreqaa_ && sleep 2 && CONFIG_add_ip_hba_
 elif [[ $answer == 'b' ]]; then
  DROPDOWN_permit_trust_
 else
  echo $answer | tr " " "\n" > $nniplist
  EDITCONF_further_edit_conf_
 fi
}
#
function CONFIG_add_ip_hba_trust_ () {
 clear && clear && clear
 BANNER_call_allert_title_
 nniplist='/usr/lib/pgsrv/nniplist.log'
 echo -e "\n\t\t\t\t         ${menu}${menu1}Add IPs to Trusted${normal}\n"
 printf "\n\t\t\t\t            ${menu}Trusted IPs${normal}\n"
 BORDER_current_ip_list_
 printf "\n\t\t\t\t           ${menu}Permitted IPs${normal}\n"
 BORDER_current_ip_list_permitted_
 echo -e "\n\t\t    ${menu}Add IP Address ${normal}${menu}(like:${number}192.168.1.1 192.168.10.0 192.168.9.0/24${normal}${menu})${normal}"
 echo -e "\n\t\t                  ${menu} Press [${normal}${number}ESC${normal}${menu}] or [${number}b${normal}${menu}] to Back${normal} \n"
 local C1="$(printf "\n\t\t\t  ${bggrey}${black}${blink}=>${normal}${menu}: ${normal}")"
 read -e -p "$C1" answer
 if [ -z "$answer" ]; then
  clear && LOGO_logo_findme_ && BANNER_call_allert_title_wreqaa_ && sleep 2 && CONFIG_add_ip_hba_trust_
 elif [[ $answer == 'b' ]]; then
  DROPDOWN_permit_trust_
 else
  echo $answer | tr " " "\n" > $nniplist
  EDITCONF_further_edit_conf_trust_
 fi
}
#
function CONFIG_add_ip_hba_ident_ () {
 clear && clear && clear
 BANNER_call_allert_title_
 nniplist='/usr/lib/pgsrv/nniplist.log'
 echo -e "\n\t\t\t\t          ${menu}${menu1}Add IPs to Ident${normal}\n"
 printf "\n\t\t\t\t            ${menu}Trusted IPs${normal}\n"
 BORDER_current_ip_list_
 printf "\n\t\t\t\t           ${menu}Permitted IPs${normal}\n"
 BORDER_current_ip_list_permitted_
 echo -e "\n\t\t    ${menu}Add IP Address ${normal}${menu}(like:${number}192.168.1.1 192.168.10.0 192.168.9.0/24${normal}${menu})${normal}"
 echo -e "\n\t\t                  ${menu} Press [${normal}${number}ESC${normal}${menu}] or [${number}b${normal}${menu}] to Back${normal} \n"
local C1="$(printf "\n\t\t\t  ${bggrey}${black}${blink}=>${normal}${menu}: ${normal}")"
 read -e -p "$C1" answer
 if [ -z "$answer" ]; then
  clear && LOGO_logo_findme_ && BANNER_call_allert_title_wreqaa_ && sleep 2 && CONFIG_add_ip_hba_ident_
 elif [[ $answer == 'b' ]]; then
  DROPDOWN_permit_trust_
 else
  echo $answer | tr " " "\n" > $nniplist
  EDITCONF_further_edit_conf_ident_
 fi
}
#
function CONFIG_add_ip_hba_peer_ () {
 clear && clear && clear
 BANNER_call_allert_title_
 nniplist='/usr/lib/pgsrv/nniplist.log'
 echo -e "\n\t\t\t\t          ${menu}${menu1}Add IPs to Peer${normal}\n"
 printf "\n\t\t\t\t            ${menu}Trusted IPs${normal}\n"
 BORDER_current_ip_list_
 printf "\n\t\t\t\t           ${menu}Permitted IPs${normal}\n"
 BORDER_current_ip_list_permitted_
 echo -e "\n\t\t    ${menu}Add IP Address ${normal}${menu}(like:${number}192.168.1.1 192.168.10.0 192.168.9.0/24${normal}${menu})${normal}"
 echo -e "\n\t\t                  ${menu} Press [${normal}${number}ESC${normal}${menu}] or [${number}b${normal}${menu}] to Back${normal} \n"
 local C1="$(printf "\n\t\t\t  ${bggrey}${black}${blink}=>${normal}${menu}: ${normal}")"
 read -e -p "$C1" answer
 if [ -z "$answer" ]; then
  clear && LOGO_logo_findme_ && BANNER_call_allert_title_wreqaa_ && sleep 2 && CONFIG_add_ip_hba_peer_
 elif [[ $answer == 'b' ]]; then
  DROPDOWN_permit_trust_
 else
  echo $answer | tr " " "\n" > $nniplist
  EDITCONF_further_edit_conf_peer_
 fi
}
#
 ###############
 # Users Menus #
 ###############
#
function USER_drop_user_ () {
 clear && clear && clear
 BANNER_call_allert_title_
 nniplist='/usr/lib/pgsrv/nniplist.log'
 echo -e "\n\t\t\t\t         ${menu}${menu1}Drop existing user${normal}\n"
 printf "\n\t\t\t\t         ${menu}Existing users:${normal}\n"
 CHECKBOX_USER_drop_user_
 echo -e "\n\t\t\t             ${menu}Please insert Username:${normal}      \n\t\t\t\t\t   ${menu}(b = Back)${normal} \n\t\t\t  "
 echo -e "\n\t\t\t            ${menu}Are you sure you want to drop $answeru? (y/n)${normal}      \n\t\t\t\t\t   ${menu}(b = Back)${normal} \n\t\t\t  "
 local C1="$(printf "\n\t\t\t         ${bggrey}${black}${blink}=>${normal}${menu}: ${normal}")"
 read -e -p "$C1" answerp
 if [[ $answerp == y ]] || [[ $answerp == Y ]]; then
  PGPASSWORD=myPassword psql -U postgres -c "DROP OWNED BY $answeru; DROP USER $answeru;"
 else
  clear && clear && clear
  BANNER_call_allert_title_
  printf "\n\n\n\t\t\t  ${menu1}${bggrey}${bgred}Aborted droping user $answeru..${normal}\n"
  sleep 1
 fi
 DROPDOWN_create_user_menu_
}
#
function USER_reset_user_pw_ () {
 clear && clear && clear
 BANNER_call_allert_title_
 nniplist='/usr/lib/pgsrv/nniplist.log'
 echo -e "\n\t\t\t\t         ${menu}${menu1}Reset user password${normal}\n"
 printf "\n\t\t\t\t         ${menu}Existing users:${normal}\n"
 BORDER_show_users_
 echo -e "\n\t\t\t              ${menu}Please insert Username:${normal}      \n\t\t\t\t\t    ${menu}(b = Back)${normal} \n\t\t\t  "
 local C1="$(printf "\n\t\t\t  ${bggrey}${black}${blink}=>${normal}${menu}: ${normal}")"
 read -e -p "$C1" answeru
 clear && clear && clear
 BANNER_call_allert_title_
 echo -e "\n\t\t\t\t         ${menu}${menu1}Reset user password${normal}\n"
 printf "\n\t\t\t\t         ${menu}Existing users:${normal}\n"
 BORDER_show_users_
 echo -e "\n\t\t\t            ${menu}Please insert $answeru new Password:${normal}      \n\t\t\t\t\t   ${menu}(b = Back)${normal} \n\t\t\t  "
 local C1="$(printf "\n\t\t\t         ${bggrey}${black}${blink}=>${normal}${menu}: ${normal}")"
 read -e -p "$C1" answerp
 PGPASSWORD=myPassword psql -U postgres -c "ALTER USER $answeru PASSWORD '$answerp';"
 DROPDOWN_create_user_menu_
}
#
function USER_create_user_perm_menu_ () {
if [[ $checkuuu == 5 ]]; then
 CHECKBOX_choose_user_
fi
clear && clear && clear
BANNER_call_allert_title_
echo -e "\n\t\t\t\t            ${menu}${menu1}Create User${normal}\n"
printf "\n\t\t\t\t          ${menu}Existing users:${normal}\n"
BORDER_show_users_
echo -e "\n\t\t\t            ${menu}Please insert a new username:${normal}      \n\t\t\t\t\t    ${menu}(b = Back)${normal} \n\t\t\t  "
local C1="$(printf "\n\t\t\t  ${bggrey}${black}${blink}=>${normal}${menu}: ${normal}")"
read -e -p "$C1" USERNAME
if [[ $USERNAME != b ]]; then
 clear && clear && clear
 BANNER_call_allert_title_
 BORDER_show_users_
 DROPDOWN_choose_password_
else
 DROPDOWN_create_user_menu_
fi
}
#
function USER_create_user_perm_menu2_ () {
if [[ $USERNAME != b ]]; then
 if [[ $PASSWORD == 2 ]]; then
  clear && clear && clear
  BANNER_call_allert_title_
  LOGO_logo_findme_
  echo -e "\n\t\t\t                   ${menu}User: $USERNAME${normal}\n"
  echo -e "\n\t\t\t               ${menu}Please insert Password:${normal}      \n\t\t\t\t\t    ${menu}(b = Back)${normal} \n\t\t\t  "
  local C1="$(printf "\n\t\t\t  ${bggrey}${black}${blink}=>${normal}${menu}: ${normal}")"
  read -e -p "$C1" PASSWORD
  if [[ $PASSWORD != b ]]; then
   clear && clear && clear
   BANNER_call_allert_title_
   if [[ $checkuuu == 4 ]] || [[ $checkuuu == 2 ]]; then
    DROPDOWN_allow_from_
   else
    DROPDOWN_choose_db_or_
   fi
  else
   DROPDOWN_create_user_menu_
  fi
 else
   if [[ $checkuuu == 4 ]] || [[ $checkuuu == 2 ]]; then
    DROPDOWN_allow_from_
   else
    DROPDOWN_choose_db_or_
   fi
 fi
else
 DROPDOWN_create_user_menu_
fi
}
#
function USER_create_user_perm_menu3_ () {
  export a=0
  if [[ $POINTERR == 1 ]]; then
    export DBNAME="$USERNAME"
    DB_create_dbases_
    clear && clear && clear
    BANNER_call_allert_title_
    LOGO_logo_findme_
    echo -e "\n\t\t\t             ${menu}User: $USERNAME${normal}"
    echo -e "\n\t\t\t             ${menu}Pass: XXXXXXXXXXXXX${normal}"
    echo -e "\n\t\t\t             ${menu}DB  : $DBNAME${normal}"
    read -p -e " " stam
    DROPDOWN_allow_from_
  elif [[ $POINTERR == 2 ]]; then
    export a=1
    DB_create_dbases_
  elif [[ $POINTERR == 4 ]]; then
    DBNAME=All
    USER_create_user_perm_menu4_
  else
    DROPDOWN_choose_db_
  fi

}
#
function USER_create_user_perm_menu4_ () {
  if [[ $ANYIP == true ]]; then
   IPSUB=ANY
  else
   USER_insert_permit_user_
  fi
  clear && clear && clear
  BANNER_call_allert_title_
  LOGO_logo_findme_
  echo -e "\n\t\t\t             ${menu}User: $USERNAME${normal}"
  echo -e "\n\t\t\t             ${menu}Pass: XXXXXXXXXXXXX${normal}"
  echo -e "\n\t\t\t             ${menu}DB  : $DBNAME${normal}"
  echo -e "\n\t\t\t             ${menu}IP  : $IPSUB${normal}"
  echo -e "\n\t\t\t             ${menu}To view password press [${normal}${number}p${normal}${menu}]${normal}"
  echo -e "\n\n\t\t\t             ${menu}Enter to finish${normal}"
  local C1="$(printf "\n\t\t\t  ${bggrey}${black}${blink}=>${normal}${menu}: ${normal}")"
  read -e -p "$C1" CHOICE
  if [[ $CHOICE == p ]]; then
   clear && clear && clear
   BANNER_call_allert_title_
   LOGO_logo_findme_
   echo -e "\n\t\t\t             ${menu}User: $USERNAME${normal}"
   echo -e "\n\t\t\t             ${menu}Pass: $PASSWORD${normal}"
   echo -e "\n\t\t\t             ${menu}DB  : $DBNAME${normal}"
   local C1=""
   read -e -p "$C1" CHOICE1
  fi
  export USERNAME=$USERNAME
  create_user_perm_
}
#
function create_user_perm_ () {
  DDATE="$(date +"Created:%d.%m.%Y")"
  #Roles
  A=DBplusUser
  B=ReadUser
  C=SuperAdmin
  D=BackupUser
 if [[ $checkuuu == 1 ]]; then
  PGPASSWORD=myPassword psql -U postgres -c "CREATE USER $USERNAME WITH PASSWORD '$PASSWORD'; GRANT ALL PRIVILEGES ON DATABASE $DBNAME to $USERNAME;"
  echo "$A - $USERNAME - $DDATE - DB=$DBNAME - PASSWORD=yes - PermitedHost=$PERMITTED" >> /tmp/helpme/.pgcount
  clear
  BANNER_call_allert_title_
  LOGO_logo_findme_
  echo -e "\n\t          ${menu1}${bggrey}Success! User ${lgreen}$answeru${normal}${menu1}${bggrey} has been created with ${normal}${bggrey}${lgreen}User plus DB${normal}${menu1}${bggrey} priviliges..${normal}"
  sleep 3
  DROPDOWN_create_user_menu_
 elif [[ $checkuuu == 2 ]]; then
   PGPASSWORD=myPassword psql -U postgres -c "CREATE USER $USERNAME WITH PASSWORD '$PASSWORD'; GRANT SELECT, ALTER, COPY ON ALL TABLES IN SCHEMA public TO $USERNAME;"
   echo "$C - $USERNAME - $DDATE - DB=ALL - PASSWORD=yes - PermitedHost=$PERMITTED" >> /tmp/helpme/.pgcount
   clear
   BANNER_call_allert_title_
   LOGO_logo_findme_
   echo -e "\n\t          ${menu1}${bggrey}Success! User ${lgreen}$USERNAME${normal}${menu1}${bggrey} has been created with ${normal}${bggrey}${lgreen}Backup${normal}${menu1}${bggrey} priviliges..${normal}"
   sleep 3
   DROPDOWN_create_user_menu_
 elif [[ $checkuuu == 3 ]]; then
   if [[ $POINTERR == 4 ]]; then
    PGPASSWORD=myPassword psql -U postgres -c "CREATE ROLE readaccess; GRANT USAGE ON SCHEMA public TO readaccess; GRANT SELECT ON ALL TABLES IN SCHEMA public TO readaccess; ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO readaccess; CREATE USER $USERNAME WITH PASSWORD '$PASSWORD'; GRANT readaccess TO $USERNAME;"
   else
    PGPASSWORD=myPassword psql -U postgres -c "CREATE USER $USERNAME WITH PASSWORD '$PASSWORD'; GRANT SELECT TO ON DATABASE $DBNAME to $USERNAME;;"
   fi
   echo "$B - $USERNAME - $DDATE - DB=$DBNAME - PASSWORD=yes - PermitedHost=$PERMITTED" >> /tmp/helpme/.pgcount
   clear
   BANNER_call_allert_title_
   LOGO_logo_findme_
   echo -e "\n\t          ${menu1}${bggrey}Success! User ${lgreen}$answeru${normal}${menu1}${bggrey} has been created with ${normal}${bggrey}${lgreen}Read-Only Per DB${normal}${menu1}${bggrey} priviliges..${normal}"
   sleep 3
   DROPDOWN_create_user_menu_
 elif [[ $checkuuu == 4 ]]; then
  PGPASSWORD=myPassword psql -U postgres -c "CREATE USER $USERNAME WITH PASSWORD '$PASSWORD'; ALTER USER $USERNAME WITH SUPERUSER;"
  echo "$C - $USERNAME - $DDATE - DB=ALL - PASSWORD=yes - PermitedHost=$PERMITTED" >> /tmp/helpme/.pgcount
  clear
  BANNER_call_allert_title_
  LOGO_logo_findme_
  echo -e "\n\t          ${menu1}${bggrey}Success! User ${lgreen}$USERNAME${normal}${menu1}${bggrey} has been created with ${normal}${bggrey}${lgreen}Super-Admin${normal}${menu1}${bggrey} priviliges..${normal}"
  sleep 3
  DROPDOWN_create_user_menu_
 elif [[ $checkuuu == 6 ]]; then
  PGPASSWORD=myPassword psql -U postgres -c "CREATE ROLE readaccess; GRANT USAGE ON SCHEMA public TO readaccess; GRANT SELECT ON ALL TABLES IN SCHEMA public TO readaccess; ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO readaccess; CREATE USER $answeru WITH PASSWORD '$answerp'; GRANT readaccess TO $answeru;"
  echo "$B - $USERNAME - $DDATE - DB=tradenet - PASSWORD=yes - PermitedHost=192.168.60.0,10.0.0.0/24" >> /tmp/helpme/.pgcount
  clear
  BANNER_call_allert_title_
  LOGO_logo_findme_
  echo -e "\n\t          ${menu1}${bggrey}Success! User ${lgreen}$answeru${normal}${menu1}${bggrey} has been created with ${normal}${bggrey}${lgreen}Read-Only${normal}${menu1}${bggrey} priviliges..${normal}"
  sleep 3
  DROPDOWN_create_user_menu_
 elif [[ $checkuuu == 7 ]]; then
  DROPDOWN_choose_db_
 elif [[ $checkuuu == 8 ]]; then
  PGPASSWORD=myPassword psql -U postgres -c "CREATE ROLE readaccess; GRANT USAGE ON SCHEMA public TO readaccess; GRANT SELECT ON ALL TABLES IN SCHEMA public TO readaccess; ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO readaccess; CREATE USER $answeru WITH PASSWORD '$answerp'; GRANT readaccess TO $answeru;"
  echo "$B - $USERNAME - $DDATE - DB=tradenet - PASSWORD=yes - PermitedHost=192.168.60.0,10.0.0.0/24" >> /tmp/helpme/.pgcount
  clear
  BANNER_call_allert_title_
  LOGO_logo_findme_
  echo -e "\n\t          ${menu1}${bggrey}Success! User ${lgreen}$answeru${normal}${menu1}${bggrey} has been created with ${normal}${bggrey}${lgreen}Read-Only${normal}${menu1}${bggrey} priviliges..${normal}"
  sleep 3
  DROPDOWN_create_user_menu_
 elif [[ $checkuuu == 9 ]]; then
  DROPDOWN_choose_db_
 fi
 DROPDOWN_create_user_menu_
}
#
function USER_insert_permit_user_ () {
  clear && clear && clear
  BANNER_call_allert_title_
  echo -e "\n\t\t\t\t       ${menu}${menu1}Permit user from IP${normal}\n"
  echo -e "\n\t\t\t ${menu}Please insert IP addresses${normal} \n\t\t\t    ${menu}(like:192.168.1.1 192.168.10.0 192.168.9.0/24)${normal} \n\t\t\t\t\t   ${menu}(b = Back)${normal} \n\t\t\t  "
  local C1="$(printf "\n\t\t\t  ${bggrey}${black}${blink}=>${normal}${menu}: ${normal}")"
  read -e -p "$C1" answer
  export answer=$answer
  if [ -z "$answer" ]; then
   clear && LOGO_logo_findme_ && BANNER_call_allert_title_wreqaa_ && sleep 2 && USER_insert_permit_user_
  elif [[ $answer == 'b' ]]; then
   DROPDOWN_create_user_menu_
  else
   nniplist='/usr/lib/pgsrv/nniplist.log'
   echo > $nniplist
   EDITCONF_user_permit_edit_conf_
  fi
}
#
 ###################
 # Databases Menus #
 ###################
#
function DB_create_dbases_ () {
 if [[ $DBNAME != $USERNAME ]]; then
 clear && clear && clear
 BANNER_call_allert_title_
 nniplist='/usr/lib/pgsrv/nniplist.log'
 echo -e "\n\t\t\t\t        ${menu}${menu1}Create a new database${normal}\n"
 printf "\t\t\t\t        ${menu}Existing Databases ${normal}${number}$dbcount${normal}\n"
 BORDER_show_db_
 echo -e "\n\t\t\t    ${menu}Please insert the name of the new database:${normal}      \n\t\t\t\t\t  ${menu}(b = Back)${normal} \n\t\t\t  "
 local C1="$(printf "\t\t\t  ${bggrey}${black}${blink}=>${normal}${menu}: ${normal}")"
 read -e -p "$C1" answeruu
 if [[ $answeruu == 'b' ]]; then
   if [[ $a != 1 ]]; then
    DROPDOWN_database_menu_
   else
    DROPDOWN_create_user_menu_
   fi
 else
 checkdbe=`cat $dblist | grep $answeruu | wc -l`
 if [[ $checkdbe == 0 ]]; then
 PGPASSWORD=myPassword psql -U postgres -c "CREATE DATABASE $answeruu;"
 clear && clear && clear
 BANNER_call_allert_title_
 printf "\n\n\n\t\t\t\t  ${menu1}${menu}New Database has been created: ${lgreen}$answeruu${normal}\n"
 export DBNAME="$answeruu"
 sleep 3
 if [[ $a != 1 ]]; then
  DROPDOWN_database_menu_
 else
  DROPDOWN_allow_from_
 fi
 else
   clear && clear && clear
   BANNER_call_allert_title_
   printf "\n\n\n\t\t\t  ${menu1}${bggrey}${bgred}Database $answeruu already exists.. Please re-enter..${normal}\n"
   sleep 3
   DB_create_dbases_
 fi
fi
else
  PGPASSWORD=myPassword psql -U postgres -c "\l" | awk '{print $1}' | grep -v 'List' | grep -v 'Name' | grep -v '-' | grep -v '|' | grep -v '(' | sed '/^$/d' > $dblist
  checkdbe=`cat $dblist | grep $USERNAME | wc -l`
  if [[ $checkdbe == 0 ]]; then
  PGPASSWORD=myPassword psql -U postgres -c "CREATE DATABASE $USERNAME;"
  clear && clear && clear
  BANNER_call_allert_title_
  printf "\n\n\n\t\t\t\t  ${menu1}${bggrey}${lgreen}New Database has been created: $USERNAME${normal}\n"
  sleep 3
  fi
fi
}
#
function DB_rmv_dbases_ () {
 clear && clear && clear
 BANNER_call_allert_title_
 nniplist='/usr/lib/pgsrv/nniplist.log'
 echo -e "\n\t\t\t\t        ${menu}${menu1}Drop a database${normal}\n"
 printf "\n\t\t\t\t      ${menu1}Existing Databases:${normal}\n"
 BORDER_show_db_
 echo -e "\n\t\t\t   ${menu}Please insert the name of the database to Drop${normal}      \n\t\t\t\t\t   ${menu}(b = Back)${normal} \n\t\t\t  "
 local C1="$(printf "\n\t\t\t  ${bggrey}${black}${blink}=>${normal}${menu}: ${normal}")"
 read -e -p "$C1" answeruu
 if [[ $answeruu == 'b' ]]; then
   DROPDOWN_database_menu_
 else
 checkdbe=`cat $dblist | grep $answeruu | wc -l`
 if [[ $checkdbe > 0 ]]; then
 PGPASSWORD=myPassword psql -U postgres -c "DROP DATABASE $answeruu;"
 clear && clear && clear
 BANNER_call_allert_title_
 printf "\n\n\n\t\t\t\t     ${menu1}${bggrey}${lgreen}Dropped $answeruu database..${normal}\n"
 sleep 3
 DROPDOWN_database_menu_
else
  clear && clear && clear
  BANNER_call_allert_title_
  printf "\n\n\n\t\t\t  ${menu1}${bggrey}${bgred}Database $answeruu does not exist.. Please re-enter..${normal}\n"
  sleep 3
  DB_rmv_dbases_
fi
fi
}
#
 ##################
 # CHECKBOX MENUS #
 ##################
#
function DROPDOWN_choose_db_ () {
clear && echo && clear
rplist='/usr/lib/pgsrv/rplist.log'
FULL14='/usr/lib/pgsrv/rrplist.log'
export FULL16='/usr/lib/pgsrv/urrplist.log'
echo > $FULL14
echo > $FULL13
PGPASSWORD=myPassword psql -U postgres -c "\l" | awk '{print $1}' | grep -v 'List' | grep -v 'Name' | grep -v '-' | grep -v '|' | grep -v '(' | sed '/^$/d' > $rplist
FULL13=`cat $rplist`
declare -a options=($FULL13)
menu_list_() {
for z in ${!options[@]}; do
printf "\n\t\t\t\t    %3d%s %s\t\t" $((z+1)) "${choices[z]:- }" "${options[z]}"
done
[[ "$msg" ]] && echo -e "\n\n\t\t$msg"; :
}
BANNER_call_allert_title_
echo -e "\n\t\t\t              ${menu}${menu1}Users Permissions Menu${normal}\n"
prompt=`echo -e "\n\n\t\t\t\t      ${menu}Select${normal} databases ${menu}\n\t\t\t\t      When done press [${number}Enter${menu}]${normal}"`
while menu_list_ && read -n 1 -rp  "$prompt" num && [[ "$num" ]]; do
BANNER_call_allert_title_
[[ "$num" != *[![:digit:]]* ]] && (( num > 0 && num <= ${#options[@]} )) ||
{
msg="Invalid option: $num"; continue
}
clear && echo && clear
BANNER_call_allert_title_
echo -e "\n\t\t\t              ${menu}${menu1}Users Permissions Menu${normal}\n"
local CHOICE=`echo -e "[${fgred}+${normal}]"`
((num--));
[[ "${choices[num]}" ]] && choices[num]="" || choices[num]="$CHOICE"
done
clear && echo && clear
for z in ${!options[@]}; do
FULL14='/usr/lib/pgsrv/rrplist.log'
[[ "${choices[z]}" ]] && { echo "${options[z]}" >> $FULL14; msg="";  }
done
unset options
unset choices
rm -rf /tmp/helpme/.pgdbases
touch /tmp/helpme/.pgcount
sed -i '/^$/d' $FULL14
sed -i '/^$/d' $FULL16
if [[ $d != 1 ]]; then
cat $FULL14 | while read lineria; do
 PGPASSWORD=myPassword psql -U postgres -c "CREATE USER $USERNAME WITH PASSWORD '$PASSWORD'; GRANT ALL PRIVILEGES ON DATABASE $lineria to $USERNAME;"
done
else
cat $FULL14 | while read lineria; do
 cat $FULL16 | while read lineriau; do
  PGPASSWORD=myPassword psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE $lineria to $lineriau;"
  BANNER_call_allert_title_
  LOGO_logo_findme_
  echo -e "\n\t   ${menu1}${bggrey}Success! User ${normal}${bggrey}${lgreen}$lineriau${normal}${menu1}${bggrey} has been created with ${normal}${bggrey}${lgreen}Per DB${normal}${menu1}${bggrey} priviliges to these Databases:${normal}"
  BORDER_show_db_per_user_
  sleep 3
 done
done
DROPDOWN_create_user_menu_
export d=0
fi
clear
BANNER_call_allert_title_
LOGO_logo_findme_
echo -e "\n\t   ${menu1}${bggrey}Success! User ${normal}${bggrey}${lgreen}$answeru${normal}${menu1}${bggrey} has been created with ${normal}${bggrey}${lgreen}Per DB${normal}${menu1}${bggrey} priviliges to these Databases:${normal}"
BORDER_show_db_per_user_
sleep 5
USER_create_user_perm_menu4_
}
#
function DROPDOWN_question_ () {
FULL14=`cat /usr/lib/pgsrv/rrplist.log`
  for lineria in $FULL14; do
   BANNER_call_allert_title_
   LOGO_logo_findme_
   echo -e "\n\t\t\t            ${menu}Please insert $lineria new Password:${normal}      \n\t\t\t\t\t   ${menu}(b = Back)${normal} \n\t\t\t  "
   local C1="$(printf "\n\t\t\t         ${bggrey}${black}${blink}=>${normal}${menu}: ${normal}")"
   read -e -p "$C1" answerp
   PGPASSWORD=myPassword psql -U postgres -c "ALTER USER $lineria PASSWORD '$answerp';"
  done
}
#
function CHECKBOX_USER_reset_user_pw_ () {
clear && echo && clear
userslist='/tmp/helpme/pgsrv/userslist.log'
echo > $userslist
PGPASSWORD=myPassword psql -U postgres -c "\du" | awk '{print $1}' | grep -v 'Role' | grep -v 'List' | grep -v 'Name' | grep -v '-' | grep -v '|' | grep -v '(' | sed '/^$/d' > $userslist
listaa=`cat $userslist`
rplist='/usr/lib/pgsrv/rplist.log'
FULL14='/usr/lib/pgsrv/rrplist.log'
echo > $FULL14
echo > $FULL13
PGPASSWORD=myPassword psql -U postgres -c "\l" | awk '{print $1}' | grep -v 'List' | grep -v 'Name' | grep -v '-' | grep -v '|' | grep -v '(' | sed '/^$/d' > $rplist
FULL13=`cat $rplist`
declare -a options=($FULL13)
menu_list_() {
for z in ${!options[@]}; do
printf "\n\t\t\t\t    %3d%s %s\t\t" $((z+1)) "${choices[z]:- }" "${options[z]}"
done
[[ "$msg" ]] && echo -e "\n\n\t\t$msg"; :
}
BANNER_call_allert_title_
echo -e "\n\t\t\t              ${menu}${menu1}Users Password Reset Menu${normal}\n"
prompt=`echo -e "\n\n\t\t\t\t      ${menu}Select${normal} users ${menu}\n\t\t\t\t      When done press [${number}Enter${menu}]${normal}"`
while menu_list_ && read -n 1 -rp  "$prompt" num && [[ "$num" ]]; do
BANNER_call_allert_title_
[[ "$num" != *[![:digit:]]* ]] && (( num > 0 && num <= ${#options[@]} )) ||
{
msg="Invalid option: $num"; continue
}
clear && echo && clear
BANNER_call_allert_title_
echo -e "\n\t\t\t              ${menu}${menu1}Users Password Reset Menu${normal}\n"
local CHOICE=`echo -e "[${fgred}+${normal}]"`
((num--));
[[ "${choices[num]}" ]] && choices[num]="" || choices[num]="$CHOICE"
done
clear && echo && clear
for z in ${!options[@]}; do
FULL14='/usr/lib/pgsrv/rrplist.log'
[[ "${choices[z]}" ]] && { echo "${options[z]}" >> $FULL14; msg="";  }
done
unset options
unset choices
DROPDOWN_question_
clear
BANNER_call_allert_title_
LOGO_logo_findme_
echo -e "\n\t\t\t           ${menu1}${bggrey}Success! passwords have been reset..${normal}"
sleep 5
DROPDOWN_main_menu_
}
#
function CHECKBOX_USER_drop_user_ () {
  clear && echo && clear
  userslist='/tmp/helpme/pgsrv/userslist.log'
  echo > $userslist
  PGPASSWORD=myPassword psql -U postgres -c "\du" | awk '{print $1}' | grep -v 'Role' | grep -v 'List' | grep -v 'Name' | grep -v '-' | grep -v '|' | grep -v '(' | sed '/^$/d' > $userslist
  listaa=`cat $userslist`
  rplist='/usr/lib/pgsrv/rplist.log'
  FULL14='/usr/lib/pgsrv/rrplist.log'
  echo > $FULL14
  echo > $FULL13
  FULL13=`cat $userslist`
  declare -a options=($FULL13)
  menu_list_() {
  for z in ${!options[@]}; do
  printf "\n\t\t\t\t    %3d%s %s\t\t" $((z+1)) "${choices[z]:- }" "${options[z]}"
  done
  [[ "$msg" ]] && echo -e "\n\n\t\t$msg"; :
  }
  BANNER_call_allert_title_
  echo -e "\n\t\t\t              ${menu}${menu1}Users Permissions Menu${normal}\n"
  prompt=`echo -e "\n\n\t\t\t\t      ${menu}Select${normal} users ${menu}\n\t\t\t\t      When done press [${number}Enter${menu}]${normal}"`
  while menu_list_ && read -n 1 -rp  "$prompt" num && [[ "$num" ]]; do
  BANNER_call_allert_title_
  [[ "$num" != *[![:digit:]]* ]] && (( num > 0 && num <= ${#options[@]} )) ||
  {
  msg="Invalid option: $num"; continue
  }
  clear && echo && clear
  BANNER_call_allert_title_
  echo -e "\n\t\t\t              ${menu}${menu1}Drop Users Menu${normal}\n"
  local CHOICE=`echo -e "[${fgred}+${normal}]"`
  ((num--));
  [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="$CHOICE"
  done
  clear && echo && clear
  for z in ${!options[@]}; do
  FULL14='/usr/lib/pgsrv/rrplist.log'
  [[ "${choices[z]}" ]] && { echo "${options[z]}" >> $FULL14; msg="";  }
  done
  unset options
  unset choices
  cat $FULL14 | while read lineria; do
   PGPASSWORD=myPassword psql -U postgres -c "DROP OWNED BY $lineria; DROP USER $lineria;"
  done
  clear
  BANNER_call_allert_title_
  LOGO_logo_findme_
  echo -e "\n\t\t\t     ${menu1}${bggrey}Success! Users have been ${normal}${bggrey}${lgreen}Dropped Suuccessfuly!${normal}"
  BORDER_show_db_per_user_
  sleep 5
  DROPDOWN_main_menu_
}
#
function CHECKBOX_choose_user_ () {
  clear && echo && clear
  rplist='/usr/lib/pgsrv/rplist.log'
  FULL16='/usr/lib/pgsrv/urrplist.log'
  echo > $FULL16
  echo > $FULL13
  FULL13=`cat $userslist`
  declare -a options=($FULL13)
  menu_list_() {
  for z in ${!options[@]}; do
  printf "\n\t\t\t\t    %3d%s %s\t\t" $((z+1)) "${choices[z]:- }" "${options[z]}"
  done
  [[ "$msg" ]] && echo -e "\n\n\t\t$msg"; :
  }
  BANNER_call_allert_title_
  echo -e "\n\t\t\t              ${menu}${menu1}Choose users Menu${normal}\n"
  prompt=`echo -e "\n\n\t\t\t\t      ${menu}Select${normal} users ${menu}\n\t\t\t\t      When done press [${number}Enter${menu}]${normal}"`
  while menu_list_ && read -n 1 -rp  "$prompt" num && [[ "$num" ]]; do
  BANNER_call_allert_title_
  [[ "$num" != *[![:digit:]]* ]] && (( num > 0 && num <= ${#options[@]} )) ||
  {
  msg="Invalid option: $num"; continue
  }
  clear && echo && clear
  BANNER_call_allert_title_
  echo -e "\n\t\t\t              ${menu}${menu1}Choose users Menu${normal}\n"
  local CHOICE=`echo -e "[${fgred}+${normal}]"`
  ((num--));
  [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="$CHOICE"
  done
  clear && echo && clear
  for z in ${!options[@]}; do
  FULL16='/usr/lib/pgsrv/urrplist.log'
  [[ "${choices[z]}" ]] && { echo "${options[z]}" >> $FULL16; msg="";  }
  done
  unset options
  unset choices
  export d=1
  DROPDOWN_choose_db_
  DROPDOWN_main_menu_
}
#
 ###################
 # DROP DOWN MENUS #
 ###################
#
function DROPDOWN_create_user_menu_ () {
   clear && clear && clear
   BANNER_call_allert_title_

    IFS=$'\n'
     set -f
     echo -e "\n"
     printf "\n\t\t\t\t           ${menu}Existing Users:${normal}"
     echo -e "\n"
     BORDER_show_users_
     echo -e "\n"
   local OPT1=`echo -e "Create User with Database"`
   local OPT2=`echo -e "Create User for Backup "`
   local OPT3=`echo -e "Create User read per DBs"`
   local OPT4=`echo -e "Create User Super Admin"`
   local OPT5=`echo -e "Assign user to database"`
   local OPT6=`echo -e "Reset password to User"`
   local OPT7=`echo -e "Delete User"`
   local EXIT=`echo -e "Back"`

echo -e "\t\t                    ${menu}Press [${number}ESC${normal}${menu}] or [${number}b${normal}${menu}] to Back${normal} \n"

    declare -a menu0_main=($OPT1 $OPT2 $OPT3 $OPT4 $OPT5 $OPT6 $OPT7 $EXIT)
    counter=0

    function draw_menu0_ () {
    for i in "${menu0_main[@]}";
    do if [[ ${menu0_main[$counter]} == $i ]];
    then tput setaf 2;
    echo -e "\t\t\t\t    ==>  ${number}${bggrey}$i${normal}"; tput setaf 4
           else
             echo -e "\t\t\t\t       ${menu}$i${normal}";
           fi

       done
   	}

   function clear_menu0_()  {
       for i in "${menu0_main[@]}"; do
   	tput cuu1 setaf 0;
   	done
   	tput ed setaf 0
   }

   # Draw initial Menu
   function select_from_list_ () {
   draw_menu0_

   while read -sn 1 key;

   do # 1 char (not delimiter), silent

       # Check for enter/space
       if [[ "$key" == "" ]];
   	then

       BANNER_call_allert_title_

        IFS=$'\n'
         set -f
         echo -e "\n"
         printf "\n\t\t\t\t           ${menu}Existing Users:${normal}"
         echo -e "\n"
         BORDER_show_users_

   #run comand on selected item
   if [ "$counter" == 0 ];
   then
   export checkuuu=1
   USER_create_user_perm_menu_
   elif [ "$counter" == 1 ];
   then
   export checkuuu=2
   USER_create_user_perm_menu_
   elif [ "$counter" == 2 ];
   then
   export checkuuu=3
   USER_create_user_perm_menu_
   elif [ "$counter" == 3 ];
   then
   export checkuuu=4
   USER_create_user_perm_menu_
   elif [ "$counter" == 4 ];
   then
   export checkuuu=5
   USER_create_user_perm_menu_
   elif [ "$counter" == 5 ];
   then
   USER_reset_user_pw_
   elif [ "$counter" == 6 ];
   then
   DROPDOWN_USER_drop_user_
   elif [ "$counter" == 7 ];
   then
   DROPDOWN_main_menu_
   fi

   	fi
       # catch multi-char special key sequences

       read -sN1 -t 0.0001 k1; read -sN1 -t 0.0001 k2; read -sN1 -t 0.0001 k3
       key+=${k1}${k2}${k3}


       case "$key" in

           # countersor up, left: previous item
           ""|i|j|$'\e[A'|$'\e0A'|$'\e[D'|$'\e0D') ((counter > 0)) && ((counter--))  ;;

           # countersor down, right: next item
           ""|k|l|$'\e[B'|$'\e0B'|$'\e[C'|$'\e0C') ((counter < ${#menu0_main[@]}-1)) && ((counter++)) ;;

           # home: first item
          ""|$'\e[1~'|$'\e0H'|$'\e[H')  counter=0;;
           # end: last item
           ""|$'\e[4~'|$'\e0F'|$'\e[F') ((counter=${#menu0_main[@]}-1));;

            # q, carriage return: quit
           #x|q|''|$'\e') color_ && exit_ ;;
   		x|q) exit_ ;;
       esac
       # Redraw menu

       clear_menu0_
       draw_menu0_
   done

   }
   select_from_list_

 }
#
function DROPDOWN_USER_drop_user_ () {
  clear && clear && clear
  BANNER_call_allert_title_

   IFS=$'\n'
    set -s
    echo -e "\n"
    printf "\n\t\t\t\t           ${menu}Existing Users:${normal}"

    #BORDER_show_users_

  local OPT1=`echo -e "Create User with Database"`
  local OPT2=`echo -e "Create User for Backup "`
  local OPT3=`echo -e "Create User read per DBs"`
  local OPT4=`echo -e "Create User Super Admin"`
  local OPT5=`echo -e "Assign user to database"`
  local OPT6=`echo -e "Reset password to User"`
  local OPT7=`echo -e "Delete User"`
  local EXIT=`echo -e "Back"`

echo -e "\t\t                    ${menu}Press [${number}ESC${normal}${menu}] or [${number}b${normal}${menu}] to Back${normal} \n"
   #declare -a menu0_main=($OPT1 $OPT2 $OPT3 $OPT4 $OPT5 $OPT6 $OPT7 $EXIT)
   userslist='/tmp/helpme/pgsrv/userslist.log'
   echo > $userslist
   sed -i '/^$/d' $userslist
   PGPASSWORD=myPassword psql -U postgres -c "\du" | awk '{print $1}' | grep -v 'Role' | grep -v 'List' | grep -v 'Name' | grep -v '-' | grep -v '|' | grep -v '(' | sed '/^$/d' > $userslist
   YYY=`cat $userslist`
   declare -a menu0_main=( $YYY )
   counter=0

   function draw_menu0_ () {
   for i in "${menu0_main[@]}";
   do if [[ ${menu0_main[$counter]} == $i ]];
   then tput setaf 2;
   echo -e "\t                              =>${menu1}${number}$i${normal}"; tput setaf 4
          else
            echo -e "\t                                ${menu}$i${normal}";
          fi
      done
  	}

  function clear_menu0_()  {
      for i in "${menu0_main[@]}"; do
  	tput cuu1 setaf 0;
  	done
  	tput ed setaf 0
  }

  # Draw initial Menu
  function select_from_list_ () {
  draw_menu0_

  while read -sn 1 key;

  do # 1 char (not delimiter), silent

      # Check for enter/space
      if [[ "$key" == "" ]];
  	then

      BANNER_call_allert_title_

       IFS=$'\n'
        set -f
        echo -e "\n"
        printf "\n\t\t\t\t           ${menu}Existing Users:${normal}"
        echo -e "\n"

USERH=`echo "${menu0_main[$counter]}"`

sed -i "/$USERH/d" $userslist
DROPDOWN_create_user_menu_

pause_witout_exit_

  #run comand on selected item
  if [ "$counter" == 0 ];
  then
  export checkuuu=1
  USER_create_user_perm_menu_
  elif [ "$counter" == 1 ];
  then
  export checkuuu=2
  USER_create_user_perm_menu_
  elif [ "$counter" == 2 ];
  then
  export checkuuu=3
  USER_create_user_perm_menu_
  elif [ "$counter" == 3 ];
  then
  export checkuuu=4
  USER_create_user_perm_menu_
  elif [ "$counter" == 4 ];
  then
  export checkuuu=5
  USER_create_user_perm_menu_
  elif [ "$counter" == 5 ];
  then
  USER_reset_user_pw_
  elif [ "$counter" == 6 ];
  then
  USER_drop_user_
  elif [ "$counter" == 7 ];
  then
  DROPDOWN_main_menu_
  fi

  	fi
      # catch multi-char special key sequences

      read -sN1 -t 0.0001 k1; read -sN1 -t 0.0001 k2; read -sN1 -t 0.0001 k3
      key+=${k1}${k2}${k3}


      case "$key" in
$'\e') DROPDOWN_main_menu_ ;;
$'\e[D'|$'\e0D')   DROPDOWN_main_menu_ ;;
          # countersor up, left: previous item
          ""|i|j|$'\e[A'|$'\e0A'|$'\e[D'|$'\e0D') ((counter > 0)) && ((counter--))  ;;

          # countersor down, right: next item
          ""|k|l|$'\e[B'|$'\e0B'|$'\e[C'|$'\e0C') ((counter < ${#menu0_main[@]}-1)) && ((counter++)) ;;

          # home: first item
         ""|$'\e[1~'|$'\e0H'|$'\e[H')  counter=0;;
          # end: last item
          ""|$'\e[4~'|$'\e0F'|$'\e[F') ((counter=${#menu0_main[@]}-1));;

           # q, carriage return: quit
          #x|q|''|$'\e') color_ && exit_ ;;
  		x|q|b) DROPDOWN_main_menu_ ;;
      esac
      # Redraw menu

      clear_menu0_
      draw_menu0_
  done

  }
  select_from_list_

}
#
function DROPDOWN_remove_ip_ () {
  clear && clear && clear
  BANNER_call_allert_title_

   IFS=$'\n'
    printf "\n\t\t\t\t        ${menu1}${menu}Remove permitted IPs${normal}\n"

    #BORDER_show_users_

  local OPT1=`echo -e "Create User with Database"`
  local OPT2=`echo -e "Create User for Backup "`
  local OPT3=`echo -e "Create User read per DBs"`
  local OPT4=`echo -e "Create User Super Admin"`
  local OPT5=`echo -e "Assign user to database"`
  local OPT6=`echo -e "Reset password to User"`
  local OPT7=`echo -e "Delete User"`
  local EXIT=`echo -e "Back"`
  LOGO_logo_findme_
echo -e "\n\n\t\t           ${normal}Press [${number}ENTER${normal}] to Remove${normal} or [${number}ESC${normal}] / [${number}b${normal}] to go back\n"

   #declare -a menu0_main=($OPT1 $OPT2 $OPT3 $OPT4 $OPT5 $OPT6 $OPT7 $EXIT)

   sed -i '/^$/d' $mainiplist
   YYY=`cat $mainiplist | column -t | sort -u`
   declare -a menu0_main=( $YYY )
   counter=0

   function draw_menu0_ () {
   for i in "${menu0_main[@]}";
   do if [[ ${menu0_main[$counter]} == $i ]];
   then tput setaf 2;
   echo -e "\t                              =>${menu1}${number}$i${normal}"; tput setaf 4
          else
            echo -e "\t                                ${menu}$i${normal}";
          fi
      done
  	}

  function clear_menu0_()  {
      for i in "${menu0_main[@]}"; do
  	tput cuu1 setaf 0;
  	done
  	tput ed setaf 0
  }

  # Draw initial Menu
  function select_from_list_ () {
  draw_menu0_

  while read -sn 1 key;

  do # 1 char (not delimiter), silent

      # Check for enter/space
      if [[ "$key" == "" ]];
  	then

USERH=`echo "${menu0_main[$counter]}" | awk '{print $1}' | sed 's|/.*||'`
sed -i "/$USERH/d" $hbaconf
sed -i "/$USERH/d" $mainiplist
sed -i "/$USERH/d" $permittedlist
sed -i "/$USERH/d" $trustedlist
DROPDOWN_remove_ip_

pause_witout_exit_

  #run comand on selected item
  if [ "$counter" == 0 ];
  then
  export checkuuu=1
  USER_create_user_perm_menu_
  elif [ "$counter" == 1 ];
  then
  export checkuuu=2
  USER_create_user_perm_menu_
  elif [ "$counter" == 2 ];
  then
  export checkuuu=3
  USER_create_user_perm_menu_
  elif [ "$counter" == 3 ];
  then
  export checkuuu=4
  USER_create_user_perm_menu_
  elif [ "$counter" == 4 ];
  then
  export checkuuu=5
  USER_create_user_perm_menu_
  elif [ "$counter" == 5 ];
  then
  USER_reset_user_pw_
  elif [ "$counter" == 6 ];
  then
  USER_drop_user_
  elif [ "$counter" == 7 ];
  then
  DROPDOWN_main_menu_
  fi

  	fi
      # catch multi-char special key sequences

      read -sN1 -t 0.0001 k1; read -sN1 -t 0.0001 k2; read -sN1 -t 0.0001 k3
      key+=${k1}${k2}${k3}


      case "$key" in
$'\e') DROPDOWN_main_menu_ ;;
$'\e[D'|$'\e0D')   DROPDOWN_main_menu_ ;;
          # countersor up, left: previous item
          ""|i|j|$'\e[A'|$'\e0A'|$'\e[D'|$'\e0D') ((counter > 0)) && ((counter--))  ;;

          # countersor down, right: next item
          ""|k|l|$'\e[B'|$'\e0B'|$'\e[C'|$'\e0C') ((counter < ${#menu0_main[@]}-1)) && ((counter++)) ;;

          # home: first item
         ""|$'\e[1~'|$'\e0H'|$'\e[H')  counter=0;;
          # end: last item
          ""|$'\e[4~'|$'\e0F'|$'\e[F') ((counter=${#menu0_main[@]}-1));;

           # q, carriage return: quit
          #x|q|''|$'\e') color_ && exit_ ;;
  		x|q|b) DROPDOWN_main_menu_ ;;
      esac
      # Redraw menu

      clear_menu0_
      draw_menu0_
  done

  }
  select_from_list_

}
#
function DROPDOWN_choose_password_ () {
  clear && clear && clear
  BANNER_call_allert_title_
  echo -e "\n\t\t\t\t            ${menu}${menu1}Create User${normal}\n"
  printf "\t\t\t\t          ${menu}${menu1}Password options${normal}\n"
  LOGO_logo_findme_
   IFS=$'\n'
    set -f
    echo -e "\n"
    printf "\t\t          ${menu}Please choose input password manually or generate${normal}\n"
    echo -e "\n"
  local OPT1=`echo -e "Input password"`
  local OPT2=`echo -e "Auto Generate"`
  local EXIT=`echo -e "Back"`
echo -e "\t\t                    ${menu}Press [${number}ESC${normal}${menu}] or [${number}b${normal}${menu}] to Back${normal} \n"


   declare -a menu0_main=($OPT1 $OPT2 $EXIT)
   counter=0

   function draw_menu0_ () {
   for i in "${menu0_main[@]}";
   do if [[ ${menu0_main[$counter]} == $i ]];
   then tput setaf 2;
   echo -e "\t\t\t\t         ==>  ${number}${bggrey}$i${normal}"; tput setaf 4
          else
            echo -e "\t\t\t\t            ${menu}$i${normal}";
          fi

      done
  	}

  function clear_menu0_()  {
      for i in "${menu0_main[@]}"; do
  	tput cuu1 setaf 0;
  	done
  	tput ed setaf 0
  }

  # Draw initial Menu
  function select_from_list_ () {
  draw_menu0_

  while read -sn 1 key;

  do # 1 char (not delimiter), silent

      # Check for enter/space
      if [[ "$key" == "" ]];
  	then

  #run comand on selected item
  if [ "$counter" == 0 ];
  then
  export PASSWORD=2
  USER_create_user_perm_menu2_
  elif [ "$counter" == 1 ]; #Find pattern
  then
  export PASSWORD=`openssl rand -base64 12`
  USER_create_user_perm_menu2_
  elif [ "$counter" == 2 ];
  then
  DROPDOWN_create_user_menu_
  fi

  	fi
      # catch multi-char special key sequences

      read -sN1 -t 0.0001 k1; read -sN1 -t 0.0001 k2; read -sN1 -t 0.0001 k3
      key+=${k1}${k2}${k3}


      case "$key" in

          # countersor up, left: previous item
          ""|i|j|$'\e[A'|$'\e0A'|$'\e[D'|$'\e0D') ((counter > 0)) && ((counter--))  ;;

          # countersor down, right: next item
          ""|k|l|$'\e[B'|$'\e0B'|$'\e[C'|$'\e0C') ((counter < ${#menu0_main[@]}-1)) && ((counter++)) ;;

          # home: first item
         ""|$'\e[1~'|$'\e0H'|$'\e[H')  counter=0;;
          # end: last item
          ""|$'\e[4~'|$'\e0F'|$'\e[F') ((counter=${#menu0_main[@]}-1));;

           # q, carriage return: quit
          #x|q|''|$'\e') color_ && exit_ ;;
  		x|q) exit_ ;;
      esac
      # Redraw menu

      clear_menu0_
      draw_menu0_
  done

  }
  select_from_list_

}
#
function DROPDOWN_choose_db_or_ () {
  clear && clear && clear
  BANNER_call_allert_title_
  echo -e "\n\t\t\t\t            ${menu}${menu1}Create User${normal}\n"
   printf "\t\t\t\t          ${menu}${menu1}Database Options${normal}\n"
   IFS=$'\n'
    set -f
    BORDER_show_db_
    echo -e "\n"
  local OPT1=`echo -e "DB name as Username"`
  local OPT2=`echo -e "New DB"`
  local OPT3=`echo -e "Existing DB"`
  local OPT4=`echo -e "All DB"`
echo -e "\t\t                    ${menu}Press [${number}ESC${normal}${menu}] or [${number}b${normal}${menu}] to Back${normal} \n"


   declare -a menu0_main=($OPT1 $OPT2 $OPT3 $OPT4)
   counter=0

   function draw_menu0_ () {
   for i in "${menu0_main[@]}";
   do if [[ ${menu0_main[$counter]} == $i ]];
   then tput setaf 2;
   echo -e "\t\t\t\t         ==>  ${number}${bggrey}$i${normal}"; tput setaf 4
          else
            echo -e "\t\t\t\t            ${menu}$i${normal}";
          fi

      done
  	}

  function clear_menu0_()  {
      for i in "${menu0_main[@]}"; do
  	tput cuu1 setaf 0;
  	done
  	tput ed setaf 0
  }

  # Draw initial Menu
  function select_from_list_ () {
  draw_menu0_

  while read -sn 1 key;

  do # 1 char (not delimiter), silent

      # Check for enter/space
      if [[ "$key" == "" ]];
  	then

  #run comand on selected item
  if [ "$counter" == 0 ];
  then
  export POINTERR=1
  USER_create_user_perm_menu3_
  elif [ "$counter" == 1 ]; #Find pattern
  then
  export POINTERR=2
  USER_create_user_perm_menu3_
  elif [ "$counter" == 2 ];
  then
  export POINTERR=3
  USER_create_user_perm_menu3_
  elif [ "$counter" == 3 ];
  then
  export POINTERR=4
  USER_create_user_perm_menu3_
  fi

  	fi
      # catch multi-char special key sequences

      read -sN1 -t 0.0001 k1; read -sN1 -t 0.0001 k2; read -sN1 -t 0.0001 k3
      key+=${k1}${k2}${k3}


      case "$key" in

          # countersor up, left: previous item
          ""|i|j|$'\e[A'|$'\e0A'|$'\e[D'|$'\e0D') ((counter > 0)) && ((counter--))  ;;

          # countersor down, right: next item
          ""|k|l|$'\e[B'|$'\e0B'|$'\e[C'|$'\e0C') ((counter < ${#menu0_main[@]}-1)) && ((counter++)) ;;

          # home: first item
         ""|$'\e[1~'|$'\e0H'|$'\e[H')  counter=0;;
          # end: last item
          ""|$'\e[4~'|$'\e0F'|$'\e[F') ((counter=${#menu0_main[@]}-1));;

           # q, carriage return: quit
          #x|q|''|$'\e') color_ && exit_ ;;
  		x|q) exit_ ;;
      esac
      # Redraw menu

      clear_menu0_
      draw_menu0_
  done

  }
  select_from_list_

}
#
function DROPDOWN_allow_from_ () {
  clear && clear && clear
  BANNER_call_allert_title_
  LOGO_logo_findme_
   IFS=$'\n'
    set -f
    echo -e "\n"
    printf "\n\t\t\t\t          ${menu}Allow User From:${normal}\n"
    echo -e "\n"
  local OPT1=`echo "ANY IP"`
  local OPT2=`echo -e "Permitted IP"`

echo -e "\t\t                    ${menu}Press [${number}ESC${normal}${menu}] or [${number}b${normal}${menu}] to Back${normal} \n"

   declare -a menu0_main=($OPT1 $OPT2)
   counter=0

   function draw_menu0_ () {
   for i in "${menu0_main[@]}";
   do if [[ ${menu0_main[$counter]} == $i ]];
   then tput setaf 2;
   echo -e "\t\t\t\t         ==>  ${number}${bggrey}$i${normal}"; tput setaf 4
          else
            echo -e "\t\t\t\t            ${menu}$i${normal}";
          fi

      done
  	}

  function clear_menu0_()  {
      for i in "${menu0_main[@]}"; do
  	tput cuu1 setaf 0;
  	done
  	tput ed setaf 0
  }

  # Draw initial Menu
  function select_from_list_ () {
  draw_menu0_

  while read -sn 1 key;

  do # 1 char (not delimiter), silent

      # Check for enter/space
      if [[ "$key" == "" ]];
  	then

  #run comand on selected item
  if [ "$counter" == 0 ];
  then
  export ANYIP=true
  USER_create_user_perm_menu4_
  elif [ "$counter" == 1 ]; #Find pattern
  then
  export ANYIP=false
  USER_create_user_perm_menu4_
  elif [ "$counter" == 2 ];
  then
  DROPDOWN_create_user_menu_
  fi

  	fi
      # catch multi-char special key sequences

      read -sN1 -t 0.0001 k1; read -sN1 -t 0.0001 k2; read -sN1 -t 0.0001 k3
      key+=${k1}${k2}${k3}


      case "$key" in

          # countersor up, left: previous item
          ""|i|j|$'\e[A'|$'\e0A'|$'\e[D'|$'\e0D') ((counter > 0)) && ((counter--))  ;;

          # countersor down, right: next item
          ""|k|l|$'\e[B'|$'\e0B'|$'\e[C'|$'\e0C') ((counter < ${#menu0_main[@]}-1)) && ((counter++)) ;;

          # home: first item
         ""|$'\e[1~'|$'\e0H'|$'\e[H')  counter=0;;
          # end: last item
          ""|$'\e[4~'|$'\e0F'|$'\e[F') ((counter=${#menu0_main[@]}-1));;

           # q, carriage return: quit
          #x|q|''|$'\e') color_ && exit_ ;;
  		x|q) exit_ ;;
      esac
      # Redraw menu

      clear_menu0_
      draw_menu0_
  done

  }
  select_from_list_

}
#
function DROPDOWN_main_menu_ () {
  dbcount=`cat $dblist | wc -l`
  userscount=`cat $userslist | wc -l`
  trustedcount=`cat /tmp/helpme/pgsrv/trustedlist.log | wc -l`
  permittedcount=`cat /tmp/helpme/pgsrv/permittedlist.log | wc -l`
  sumcount=$((trustedcount+permittedcount))
fullversion=`find /usr -wholename '*/bin/postgres' | grep 'pgsql-' | cut -d/ -f3`
numbera=`echo $fullversion | grep -Eo '[0-9]+$'`
checksa=`systemctl status postgresql-${numbera} | grep 'active (running)' | wc -l`
if [[ $checksa > 0 ]]; then
 pgstatus='OK'
 aaa=$lgreen
 bbb=$menu
else
 pgstatus='BAD'
 aaa=$bggrey
fi
countera=1
clear && clear && clear
BANNER_call_allert_title_

fullversion=`find /usr -wholename '*/bin/postgres' | grep 'pgsql-' | cut -d/ -f3`
numbera=`echo $fullversion | grep -Eo '[0-9]+$'`
checksa=`systemctl status postgresql-${numbera} | grep 'active (running)' | wc -l`
 IFS=$'\n'
  set -f
  echo -e "\n"
LOGO_logo_findme_
echo -e "\n"
local OPT1=`echo -e "Manage Access IPs        ${number}$sumcount${normal}"`
local OPT2=`echo -e "Manage Users             ${number}$userscount${normal}"`
local OPT3=`echo -e "Manage Databases         ${number}$dbcount${normal}"`
if [[ $pgstatus == 'OK' ]]; then
 local OPT4=`echo -e "Stop service           ${lgreen}  $pgstatus ${normal}"`
else
 local OPT4=`echo -e "Restart Service        ${fgred}  $pgstatus ${normal}"`
fi
local EXIT=`echo -e "Exit"`


 declare -a menu0_main=($OPT1 $OPT2 $OPT3 $OPT4 $EXIT)
 counter=0

 function draw_menu0_ () {
 for i in "${menu0_main[@]}";
 do if [[ ${menu0_main[$counter]} == $i ]];
 then tput setaf 2;
 echo -e "\t\t\t          ==>${number}${bggrey}$i${normal}"; tput setaf 4
        else
          echo -e "${menu}\t\t\t             $i${normal}";
        fi

    done
	}

function clear_menu0_()  {
    for i in "${menu0_main[@]}"; do
	tput cuu1 setaf 0;
	done
	tput ed setaf 0
}

# Draw initial Menu
function select_from_list_ () {
draw_menu0_

while read -sn 1 key;

do # 1 char (not delimiter), silent

    # Check for enter/space
    if [[ "$key" == "" ]];
	then

#run comand on selected item
if [ "$counter" == 0 ];
then
DROPDOWN_permit_trust_
elif [ "$counter" == 1 ]; #Find pattern
then
DROPDOWN_create_user_menu_
elif [ "$counter" == 2 ];
then
DROPDOWN_database_menu_
elif [ "$counter" == 3 ];
then
if [[ $pgstatus == 'OK' ]]; then
 systemctl stop postgresql-*
 DROPDOWN_main_menu_
else
 export countera=1
 SERVICE_start_status_service_
 DROPDOWN_main_menu_
fi
elif [ "$counter" == 4 ];
then
LOGO_logo_p_goodbye_
fi

	fi
    # catch multi-char special key sequences

    read -sN1 -t 0.0001 k1; read -sN1 -t 0.0001 k2; read -sN1 -t 0.0001 k3
    key+=${k1}${k2}${k3}


    case "$key" in

        # countersor up, left: previous item
        ""|i|j|$'\e[A'|$'\e0A'|$'\e[D'|$'\e0D') ((counter > 0)) && ((counter--))  ;;

        # countersor down, right: next item
        ""|k|l|$'\e[B'|$'\e0B'|$'\e[C'|$'\e0C') ((counter < ${#menu0_main[@]}-1)) && ((counter++)) ;;

        # home: first item
       ""|$'\e[1~'|$'\e0H'|$'\e[H')  counter=0;;
        # end: last item
        ""|$'\e[4~'|$'\e0F'|$'\e[F') ((counter=${#menu0_main[@]}-1));;

         # q, carriage return: quit
        #x|q|''|$'\e') color_ && exit_ ;;
		x|q) exit_ ;;
    esac
    # Redraw menu

    clear_menu0_
    draw_menu0_
done

}
select_from_list_

}
#
function DROPDOWN_permit_trust_ () {
countera=1
clear && clear && clear
BANNER_call_allert_title_
permittedcountb=$((permittedcount-identcount-peercount))
fullversion=`find /usr -wholename '*/bin/postgres' | grep 'pgsql-' | cut -d/ -f3`
numbera=`echo $fullversion | grep -Eo '[0-9]+$'`
checksa=`systemctl status postgresql-${numbera} | grep 'active (running)' | wc -l`
 IFS=$'\n'
  set -f
echo -e "\n\t\t\t\t            ${menu}${menu1}Manage IPs${normal}"
printf "\n\t\t\t\t            ${menu}Trusted IPs${normal}\n"
BORDER_current_ip_list_
printf "\n\t\t\t\t           ${menu}Permitted IPs${normal}\n"
BORDER_current_ip_list_permitted_
echo -e "\n"
local OPT1=`echo -e "Add Permitted         ${number}$permittedcountb${normal}"`
local OPT2=`echo -e "Add Trusted           ${number}$trustedcount${normal}"`
local OPT3=`echo -e "Add Ident             ${number}$identcount${normal}"`
local OPT4=`echo -e "Add Peer              ${number}$peercount${normal}"`
local OPT5=`echo -e "Remove IPs"`
local EXIT=`echo -e "Back"`

echo -e "\t\t                    ${menu}Press [${number}ESC${normal}${menu}] or [${number}b${normal}${menu}] to Back${normal} \n"
 declare -a menu0_main=($OPT1 $OPT2 $OPT3 $OPT4 $OPT5 $EXIT)
 counter=0

 function draw_menu0_ () {
 for i in "${menu0_main[@]}";
 do if [[ ${menu0_main[$counter]} == $i ]];
 then tput setaf 2;
 echo -e "\t\t\t\t  ==>${number}${bggrey}$i${normal}"; tput setaf 4
        else
          echo -e "\t\t\t\t     ${menu}$i${normal}";
        fi

    done
	}

function clear_menu0_()  {
    for i in "${menu0_main[@]}"; do
	tput cuu1 setaf 0;
	done
	tput ed setaf 0
}

# Draw initial Menu
function select_from_list_ () {
draw_menu0_

while read -sn 1 key;

do # 1 char (not delimiter), silent

    # Check for enter/space
    if [[ "$key" == "" ]];
	then

#run comand on selected item
if [ "$counter" == 0 ];
then
CONFIG_add_ip_hba_
elif [ "$counter" == 1 ]; #Find pattern
then
CONFIG_add_ip_hba_trust_
elif [ "$counter" == 2 ]; #Find pattern
then
CONFIG_add_ip_hba_ident_
elif [ "$counter" == 3 ]; #Find pattern
then
CONFIG_add_ip_hba_peer_
elif [ "$counter" == 4 ]; #Find pattern
then
DROPDOWN_remove_ip_
elif [ "$counter" == 5 ]; #Find pattern
then
DROPDOWN_main_menu_
fi

	fi
    # catch multi-char special key sequences

    read -sN1 -t 0.0001 k1; read -sN1 -t 0.0001 k2; read -sN1 -t 0.0001 k3
    key+=${k1}${k2}${k3}


    case "$key" in

        # countersor up, left: previous item
        ""|i|j|$'\e[A'|$'\e0A'|$'\e[D'|$'\e0D') ((counter > 0)) && ((counter--))  ;;

        # countersor down, right: next item
        ""|k|l|$'\e[B'|$'\e0B'|$'\e[C'|$'\e0C') ((counter < ${#menu0_main[@]}-1)) && ((counter++)) ;;

        # home: first item
       ""|$'\e[1~'|$'\e0H'|$'\e[H')  counter=0;;
        # end: last item
        ""|$'\e[4~'|$'\e0F'|$'\e[F') ((counter=${#menu0_main[@]}-1));;

         # q, carriage return: quit
        #x|q|''|$'\e') color_ && exit_ ;;
		x|q) exit_ ;;
    esac
    # Redraw menu

    clear_menu0_
    draw_menu0_
done

}
select_from_list_

}
#
function DROPDOWN_database_menu_ () {
countera=1
DBNAME=a
USERNAME=b
clear && clear && clear
BANNER_call_allert_title_

fullversion=`find /usr -wholename '*/bin/postgres' | grep 'pgsql-' | cut -d/ -f3`
numbera=`echo $fullversion | grep -Eo '[0-9]+$'`
checksa=`systemctl status postgresql-${numbera} | grep 'active (running)' | wc -l`
 IFS=$'\n'
  set -f
  printf "\n\t\t\t\t          ${menu}${menu1}Manage Databases${normal}\n"
  printf "\n\t\t\t\t        ${menu}Existing Databases${normal} ${number}$dbcount${normal}\n"
  BORDER_show_db_
  echo -e "\n"
local OPT1=`echo -e "Create Database"`
local OPT2=`echo -e "Drop Database"`
local EXIT=`echo -e "Back"`
echo -e "\t\t                    ${menu}Press [${number}ESC${normal}${menu}] or [${number}b${normal}${menu}] to Back${normal} \n"

 declare -a menu0_main=($OPT1 $OPT2 $EXIT)
 counter=0

 function draw_menu0_ () {
 for i in "${menu0_main[@]}";
 do if [[ ${menu0_main[$counter]} == $i ]];
 then tput setaf 2;
 echo -e "\t\t\t\t    ==>${number}${bggrey}$i${normal}"; tput setaf 4
        else
          echo -e "\t\t\t\t       ${menu}$i${number}";
        fi

    done
	}

function clear_menu0_()  {
    for i in "${menu0_main[@]}"; do
	tput cuu1 setaf 0;
	done
	tput ed setaf 0
}

# Draw initial Menu
function select_from_list_ () {
draw_menu0_

while read -sn 1 key;

do # 1 char (not delimiter), silent

    # Check for enter/space
    if [[ "$key" == "" ]];
	then

#run comand on selected item
if [ "$counter" == 0 ];
then
DB_create_dbases_
elif [ "$counter" == 1 ]; #Find pattern
then
DROPDOWN_choose_db_
elif [ "$counter" == 2 ];
then
DROPDOWN_main_menu_
fi

	fi
    # catch multi-char special key sequences

    read -sN1 -t 0.0001 k1; read -sN1 -t 0.0001 k2; read -sN1 -t 0.0001 k3
    key+=${k1}${k2}${k3}


    case "$key" in

        # countersor up, left: previous item
        ""|i|j|$'\e[A'|$'\e0A'|$'\e[D'|$'\e0D') ((counter > 0)) && ((counter--))  ;;

        # countersor down, right: next item
        ""|k|l|$'\e[B'|$'\e0B'|$'\e[C'|$'\e0C') ((counter < ${#menu0_main[@]}-1)) && ((counter++)) ;;

        # home: first item
       ""|$'\e[1~'|$'\e0H'|$'\e[H')  counter=0;;
        # end: last item
        ""|$'\e[4~'|$'\e0F'|$'\e[F') ((counter=${#menu0_main[@]}-1));;

         # q, carriage return: quit
        #x|q|''|$'\e') color_ && exit_ ;;
		x|q) exit_ ;;
    esac
    # Redraw menu

    clear_menu0_
    draw_menu0_
done

}
select_from_list_

}
#
function DROPDOWN_choose_db_ () {
  clear && clear && clear
  BANNER_call_allert_title_

   IFS=$'\n'
    set -f

    printf "\n\t\t\t\t         ${menu}Existing Databases${normal}\n"

    #BORDER_show_users_

  local OPT1=`echo -e "Create User with Database"`
  local OPT2=`echo -e "Create User for Backup "`
  local OPT3=`echo -e "Create User read per DBs"`
  local OPT4=`echo -e "Create User Super Admin"`
  local OPT5=`echo -e "Assign user to database"`
  local OPT6=`echo -e "Reset password to User"`
  local OPT7=`echo -e "Delete User"`
  local EXIT=`echo -e "Back"`
  LOGO_logo_findme_
echo -e "\n\n\t\t           ${normal}Press [${number}ENTER${normal}] to Remove${normal} or [${number}ESC${normal}] / [${number}b${normal}] to go back\n"

   #declare -a menu0_main=($OPT1 $OPT2 $OPT3 $OPT4 $OPT5 $OPT6 $OPT7 $EXIT)
   rplist='/usr/lib/pgsrv/rplist.log'
   PGPASSWORD=myPassword psql -U postgres -c "\l" | awk '{print $1}' | grep -v 'List' | grep -v 'Name' | grep -v '-' | grep -v '|' | grep -v '(' | sed '/^$/d' > $rplist
   YYY=`cat $rplist`
   declare -a menu0_main=( $YYY )
   counter=0

   function draw_menu0_ () {
   for i in "${menu0_main[@]}";
   do if [[ ${menu0_main[$counter]} == $i ]];
   then tput setaf 2;
   echo -e "\t                              =>${menu1}${number}$i${normal}"; tput setaf 4
          else
            echo -e "\t                                ${menu}$i${normal}";
          fi
      done
  	}

  function clear_menu0_()  {
      for i in "${menu0_main[@]}"; do
  	tput cuu1 setaf 0;
  	done
  	tput ed setaf 0
  }

  # Draw initial Menu
  function select_from_list_ () {
  draw_menu0_

  while read -sn 1 key;

  do # 1 char (not delimiter), silent

      # Check for enter/space
      if [[ "$key" == "" ]];
  	then

      BANNER_call_allert_title_

       IFS=$'\n'
        set -f
        echo -e "\n"
        printf "\n\t\t\t\t           ${menu}Existing Users:${normal}"
        echo -e "\n"

USERH=`echo "${menu0_main[$counter]}"`
PGPASSWORD=myPassword psql -U postgres -c "DROP DATABASE $USERH;"
sed -i "/$USERH/d" $dblist
DROPDOWN_choose_db_

pause_witout_exit_

  #run comand on selected item
  if [ "$counter" == 0 ];
  then
  export checkuuu=1
  USER_create_user_perm_menu_
  elif [ "$counter" == 1 ];
  then
  export checkuuu=2
  USER_create_user_perm_menu_
  elif [ "$counter" == 2 ];
  then
  export checkuuu=3
  USER_create_user_perm_menu_
  elif [ "$counter" == 3 ];
  then
  export checkuuu=4
  USER_create_user_perm_menu_
  elif [ "$counter" == 4 ];
  then
  export checkuuu=5
  USER_create_user_perm_menu_
  elif [ "$counter" == 5 ];
  then
  USER_reset_user_pw_
  elif [ "$counter" == 6 ];
  then
  USER_drop_user_
  elif [ "$counter" == 7 ];
  then
  DROPDOWN_main_menu_
  fi

  	fi
      # catch multi-char special key sequences

      read -sN1 -t 0.0001 k1; read -sN1 -t 0.0001 k2; read -sN1 -t 0.0001 k3
      key+=${k1}${k2}${k3}


      case "$key" in
$'\e') DROPDOWN_main_menu_ ;;
$'\e[D'|$'\e0D')   DROPDOWN_main_menu_ ;;
          # countersor up, left: previous item
          ""|i|j|$'\e[A'|$'\e0A'|$'\e[D'|$'\e0D') ((counter > 0)) && ((counter--))  ;;

          # countersor down, right: next item
          ""|k|l|$'\e[B'|$'\e0B'|$'\e[C'|$'\e0C') ((counter < ${#menu0_main[@]}-1)) && ((counter++)) ;;

          # home: first item
         ""|$'\e[1~'|$'\e0H'|$'\e[H')  counter=0;;
          # end: last item
          ""|$'\e[4~'|$'\e0F'|$'\e[F') ((counter=${#menu0_main[@]}-1));;

           # q, carriage return: quit
          #x|q|''|$'\e') color_ && exit_ ;;
  		x|q|b) DROPDOWN_main_menu_ ;;
      esac
      # Redraw menu

      clear_menu0_
      draw_menu0_
  done

  }
  select_from_list_

}
#
 ##############
 # Start Here #
 ##############
# Main function
#
function MAIN_fun_ () {
 CHECK_check_postgres_info_
}
#
MAIN_fun_
#
 ###########
 # THE END #
 ###########
