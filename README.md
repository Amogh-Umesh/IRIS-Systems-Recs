# IRIS-Systems-Recs

## Task 2: Setup MYSQL Database to work with the App:

### Steps:
* Start a MYSQL Container with the following parameters:
  * image: mysql:5.7
  * name: railsmysql
  * Environment Variables: MYSQL_ROOT_PASSWORD=iris &
MYSQL_ROOT_HOST='%'
  * ports: 3306

* This can be done easy by using a docker compose or by running some commands.
* By Using Docker Compose:
    * Create a file called compose.yaml
    ```yaml
    version: '3'
    name: 'IrisSystems'
    services:
    railsapp:
        build: ./Shopping-App-IRIS
        command: bash -C '/usr/bin/deploy.sh'
        depends_on:
        railsmysql:
            condition: service_healthy
        ports:
        - "8080:3000"
        env_file: 
        - iris_app.env
        links:
        - railsmysql:db
        restart: on-failure:10

    railsmysql:
        image: mysql:5.7
        volumes:
        - ../data/ShoppingApp/backup/mysql:/var/lib/mysql
        env_file:
        - iris_mysql.env
        expose: 
        - "3306"
        healthcheck:
            test: ["CMD", 'mysqladmin', 'ping', '-h', 'localhost', '-u', 'root', '-p$$MYSQL_ROOT_PASSWORD' ]
            interval: 30s
            timeout: 30s
            retries: 10
            start_period: 30s
        restart: on-failure:10
    ```
    * Now run:
    ```bash
    docker compose up
    ```
* By Running Commands:
    * Run the following commands:
    ```bash
    docker run --env-file iris_mysql.env --expose 3306 --name railsmysql mysql:5.7
    ```
    * Check if the database is running by connceting to it from the hist by using the appropriate password.
    * Once the database is up and running, run the following command:

    ```bash
    docker run --env-file iris_app.env --link railsmysql:db -p 8080:3000 --name railsapp iris_shopping_app bash -C '/usr/bin/deploy.sh'
    ```
* Check if the app is running by visiting http://localhost:8080/

![Running App] app.png
