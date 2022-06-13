# IRIS-Systems-Recs
## Task 6: Use Docker Compose to bring up all containers:
* We are already using docker compose by setting up the compose.yaml file and running the following command to start the containers.
    ```
    docker compose up
    ```
* Compose.yaml:
    ```
    version: '3'
    name: 'IrisSystems'
    services:
    railsapp0: &app
        build: ./Shopping-App-IRIS
        command: bash -C '/usr/bin/deploy.sh'
        depends_on:
        railsmysql:
            condition: service_healthy
        expose:
        - "8080:3000"
        env_file: 
        - iris_app.env
        links:
        - railsmysql:db
        restart: on-failure:10
    
    railsapp1: *app
    railsapp2: *app

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
            interval: 10s
            timeout: 10s
            retries: 30
            start_period: 10s
        restart: on-failure:10
    
    reverseproxy:
        image: nginx:latest
        volumes:
        - ./nginx/nginx.conf:/etc/nginx/nginx.conf
        depends_on:
        - railsapp0
        - railsapp1
        - railsapp2
        ports:
        - "8080:8080"
        links:
        - railsapp0:railsserver0
        - railsapp1:railsserver1
        - railsapp2:railsserver2
        restart: on-failure:10
    ```
* Docker compose allows us to bring up all containers of the App in one command.
* We are specifying the image, environment file, and ports for each container.
* We are also using the links to make the containers accessible from each other with a particular keyword.
* We are also using the healthcheck to check if the mysql container is accepting connections. Only after the mysql container is ready we are starting the Rails server containers.
* We are using the depends_on to make sure that the mysql container is ready before starting the Rails server containers and that the rails server containers are ready before starting our nginx load balancer.
* We are using the restart: on-failure:10 to restart the containers if they fail for a maximum of 10 times.
* `docker compose down` brings down all containers and removes them from docker.
* `docker compose stop` stops all containers of the app.
* `docker compose start` starts all containers of the app.
