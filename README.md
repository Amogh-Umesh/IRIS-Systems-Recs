# IRIS-Systems-Recs
## Task 4: Setup a Nginx load balancer among 3 Rails server instances:
### Steps:
* We have to create the three instances of Rails server.
* Modify the compose.yaml file to include the three instances and set Nginx to start after these have started. Also link the three instances to the nginx container.
* compose.yaml:
```yaml
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
* Alter the nginx.conf file to setup the load balancer:
```conf
events { worker_connections 1024; }

http {
    upstream RailsServer {
        server railsserver0:3000;
        server railsserver1:3000;
        server railsserver2:3000;
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
* If we need requests to be passed through to one instance more than the other, we can do so by setting a weight property after the server name in the upstream section.
* All the running containers:
![running containers](https://github.com/Amogh-Umesh/IRIS-Systems-Recs/blob/nginx_load_balancer/running%20services.png?raw=true)
