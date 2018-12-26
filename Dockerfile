FROM elixir:1.7.4

LABEL maintainer <hi.geoom@gmail.com>

# update and install software
RUN apt-get update && apt-get upgrade -y \ 
    && apt-get install -y curl wget git make sudo \
    && apt-get update \
    && apt-get clean

# install the Phoenix Mix archive
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/1.4-dev/phx_new.ez
RUN mix local.hex --force \
    && mix local.rebar --force

# install Node.js (>= 8.0.0) and NPM in order to satisfy brunch.io dependencies
# See https://hexdocs.pm/phoenix/installation.html#node-js-5-0-0
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && sudo apt-get install -y inotify-tools nodejs

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app/poolEngine

EXPOSE 4000