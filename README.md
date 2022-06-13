# IRIS-Systems-Recs
## Task 7: Setup Rate Limiting:
### Steps:
* To setup rate limiting we need to make the following changes to the nginx/nginx.conf file:
```conf
events { worker_connections 1024; }

http {
    limit_req_zone $binary_remote_addr zone=one:10m rate=10r/s;
    upstream RailsServer {
        server railsserver0:3000;
        server railsserver1:3000;
        server railsserver2:3000;
    }
    server {
        listen 8080;
        location / {
            limit_req zone=one burst=20 nodelay;
            proxy_set_header  X-Real-IP  $remote_addr;   
            proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header  Host $http_host; 
            proxy_pass         http://RailsServer;
        }
    }
}
```
* This limits a single IP to 10 requests per second.
* If more requests come within that time it is put into a queue of size 20(burst). 
* All requests that are recieved after the queue is filled is dropped.
* The nodelay option instantly passes on the queued requests but does not empty the queue until the relevant time has passed.
