
FROM elixir:1.9.4-slim

# basic dependencies to make it all work
RUN apt-get update -qq && apt-get -y --allow-unauthenticated install curl libpq-dev postgresql-client git make erlang-crypto apt-transport-https

RUN apt install -y build-essential

# creating a user for the app
ARG UID=1000
RUN useradd -m -u $UID paulo-silva
USER paulo-silva

RUN mkdir /home/paulo-silva/app
WORKDIR /home/paulo-silva/app
RUN mkdir -p /home/paulo-silva/app/deps; chown -R paulo-silva:paulo-silva /home/paulo-silva/app/deps
VOLUME ["/home/paulo-silva/app/deps"]

RUN mix local.hex --force
RUN mix local.rebar --force
