FROM ruby:2.1.9-alpine

LABEL maintainer "Knut Ahlers <knut@ahlers.me>"

COPY . /src
WORKDIR /src

RUN set -ex \
 && bundle install --full-index

ENTRYPOINT ["./watch.rb"]
