# IRIS-Systems-Recs
## Task 5: Setup Persistence of NGINX config data and DB data:
### Steps:
* This can be done by using the volumes feature of the docker-compose file.
* The volumes feature is used to sync the data from the host machine to the container and vice versa.
* We have already setup persistence in NGINX for the nginx.conf file in this line:
    ```
    volumes:
        - /nginx/nginx.conf:/etc/nginx/nginx.conf
    ```
* We have also setup persistence in the compose.yaml file for the database in this line under railsmysql:
    ```
    volumes:
      - ../data/ShoppingApp/backup/mysql:/var/lib/mysql
    ```
* All Mysql data will be stored in the host in the directory:
    ```
    ../data/ShoppingApp/backup/mysql
    ```
* Thus we can restart the containers without suffering any data loss or needing to reconfigure.
