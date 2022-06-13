mkdir /backups
sudo docker-compose exec railsmysql bash -c 'mysqldump -p$MYSQL_ROOT_PASSWORD --all-databases' > "/backups/Shopping_App_Backup/backup_$(date +"%d_%m_%Y")"
