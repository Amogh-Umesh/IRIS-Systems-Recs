FROM ruby:2.5.1

WORKDIR /iris_shopping_app

COPY Gemfile ./

RUN bundle update

RUN bundle install

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt install -y nodejs

COPY initialize.sh /usr/bin/

RUN chmod 777 /usr/local/bin/initialize.sh

COPY . .

EXPOSE 3000

ENTRYPOINT ["initialize.sh"]

CMD rails server -b 0.0.0.0 -p 3000