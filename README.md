# IRIS-Systems-Recs
## Task 3: Setup a reverse proxy through Nginx: 
### Steps:
* Create a new folder in your project Directory called `nginx`
* Create a new file in the `nginx` folder called `nginx.conf`
* Copy the following code into the `nginx.conf` file[^1]:
```
events { worker_connections 1024; }

http {
    upstream RailsServer {
        server railsserver:3000;
    }
    server {
        listen 8080;
        location / {
            proxy_set_header  X-Real-IP  $remote_addr;   
            proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header  Host $http_host; 
            proxy_pass         http://RailsServer;
        }
    }
}
```
* We do this to configure our Nginx server to reverse proxy. The server is listening at 8080 and passing thorugh incoming packets to http://railsserver:3000
* We will use docker compose to setup all the containers. Check out the `docker-compose` branch for more info on docker-compose.
* Make the necessary change to compose.yaml file:
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
    expose:
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
      - railsapp
    ports:
      - "8080:8080"
    links:
      - railsapp:railsserver
    restart: on-failure:10
```
* By setting up volumes, the nginx.conf file in the container will always track the nginx.conf file in the host machine.
* Run docker compose to setup all containers
```bash
docker compose up
```
* Check that the app is running by visiting http://localhost:8080/
