# IRIS-Systems-Recs

## Task 1: Dockerize the rails app:

* Create a Dockerfile inside the app directory with the following contents:
```Dockerfile
FROM ruby:2.5.1

WORKDIR /iris_shopping_app

COPY Gemfile ./

RUN bundle update

RUN bundle install

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt install -y nodejs

COPY initialize.sh /usr/bin/

RUN chmod 777 /usr/bin/initialize.sh

COPY . .

EXPOSE 3000

ENTRYPOINT ["initialize.sh"]

CMD rails server -b 0.0.0.0 -p 3000
```
* Create a file of the name ``initialize.sh`` with the following contents:
```bash
#!/bin/bash
set -e
rm -rf /iris_shopping_app/tmp/pids/server.pid
exec "$@"
```
* We do this as we need to delete the tmp/pids/server.pid or otherwise the container cannot be stopped and started again as rails thinks it is already running.

* build the image by running the following from within the directory:
```bash
docker build -t iris_shopping_app .
```
* Run the image by running the following command:
```bash
docker run -p 8080:3000 iris_shopping_app
```
* Check that the app is running by visiting http://localhost:8080/

Note: We will get an error message on http://localhost:8080/ as we have not yet setup a database.


