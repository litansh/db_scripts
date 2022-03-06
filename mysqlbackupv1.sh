function bckp_sql_ () {
echo  Starting sql beckup ....
 LD2="$(date +"Date-%d.%m.%Y-%H:%M")"
  sleep 3
   mysql -uroot -pI_will_backup_you -N -e 'show databases;' |
    while read dbname;
     do
      cd /home/wwwbckp && mysqldump -uroot -pI_will_backup_you --complete-insert --routines --triggers --single-transaction "$dbname" > "$dbname-$LD2".sql;
       rm -rf performance*.sql
        rm -rf mysql-*.sql
         done
          echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
           echo  MySQL backup finished. Going sleep
}

function reset_mariadb_root_p_ () {
pkill -9 mysqld
 pkill -9 mariadb
  sudo mysqld_safe --skip-grant-tables --skip-networking  >res 2>&1 &
   printf "Resetting password... hold on\n"
    sleep 7
     mysql mysql -e "UPDATE user SET Password=PASSWORD('I_will_backup_you') WHERE User='root' AND host='localhost';FLUSH PRIVILEGES;"
      systemctl stop mariadb
       clear
        pkill -9 mysqld
         pkill -9 mariadb
          clear
            sudo systemctl start mariadb
             echo 'Cleaning up...'
              sleep 3
               pkill -9 mysqld
                pkill -9 mariadb
                 systemctl stop mariadb
                  sudo systemctl start mariadb
                   sleep 3
                    bckp_sql_
}

function copy_remote_mysql_ () {
#SSHRIP="138.201.116.161"
SSHRIP="213.52.174.32"
 echo "Stoping MySQL"
  systemctl stop mariadb
   rm -rf /var/lib/mysql/*
    rsync -avzhe 'ssh -p 44433' --progress root@$SSHRIP:/var/lib/mysql/ /var/lib/mysql/
     chown -R mysql:mysql /var/lib/mysql/
      reset_mariadb_root_p_
}

copy_remote_mysql_
