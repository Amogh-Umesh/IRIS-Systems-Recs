# IRIS-Systems-Recs
## Task 8: Setup a cronjob to create backups of the database every day:
### Steps:
* Create a new file called `cronjob.sh` wih the following content:
    ```bash
    cd /home/amogh/IRIS/SystemsRecs/Repo
    docker compose exec railsmysql bash -c 'mysqldump -p$MYSQL_ROOT_PASSWORD --all-databases' > "/home/amogh/IRIS/SystemsRecs/backups/backup_$(date +"%d_%m_%Y")"
    ```
* Now run the following commands:
    ```bash
    sudo cp cronjob.sh /usr/bin/
    ```
    ```bash
    sudo chmod 777 /usr/bin/cronjob.sh
    ```
* write out current crontab
    ```bash
    crontab -l > tempcron
    ```
* add to tempcron file
    ```bash
    echo "0 0     * * *   root    /usr/bin/cronjob.sh" >> tempcron
    ```
* install new cron file
    ```bash
    crontab tempcron
    ```
* remove tempcron file
    ```bash
    rm tempcron
    ```
* create backup directory:
    ```bash
    mkdir /home/amogh/IRIS/SystemsRecs/backups
    ```
* Check the cronjob is added:
    ```bash
    crontab -l
    ```
* Manually create backup:
    ```bash
    cronjob.sh
    ```
* This creates a backup once every day and names the backup with the date of the day.
* The backup:
![backup](https://github.com/Amogh-Umesh/IRIS-Systems-Recs/blob/Cronjob/backup.png?raw=true)
