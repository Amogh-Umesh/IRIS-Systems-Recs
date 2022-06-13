# IRIS-Systems-Recs
## Task 8: Setup a cronjob to create backups of the database every day:
### Steps:
* Create a new file called `cronjob.sh` wih the following content:
```bash
mkdir /backups
sudo docker-compose exec railsmysql bash -c 'mysqldump -p$MYSQL_ROOT_PASSWORD --all-databases' > "/backups/Shopping_App_Backup/backup_$(date +"%d_%m_%Y")"
```
* Now run the following commands:
    ```bash
    sudo cp cronjob.sh /usr/bin/
    ```
    ```bash
    sudo chmod 777 /usr/bin/cronjob.sh
    ```
    ```bash
    #write out current crontab
    crontab -l > tempcron
    ```
    ```bash
    #echo new cron into cron file
    echo "0 0     * * *   root    /usr/bin/cronjob" >> tempcron
    ```
    ```bash
    #install new cron file
    crontab tempcron
    ```
    ```bash
    rm tempcron
    ```

