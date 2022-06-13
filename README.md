# IRIS-Systems-Recs
The Repo for 2022 IRIS Systems Team Recruitments
```bash
sudo cp cronjob.sh /usr/bin/
sudo chmod 777 /usr/bin/cronjob.sh
#write out current crontab
crontab -l > tempcron
#echo new cron into cron file
echo "0 0     * * *   root    /usr/bin/cronjob" >> tempcron
#install new cron file
crontab tempcron
rm tempcron
```
