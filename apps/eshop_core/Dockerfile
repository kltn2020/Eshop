FROM bitwalker/alpine-elixir-phoenix:1.10.3 AS build

# install build dependencies
RUN apk add --no-cache yarn

ENV MIX_ENV=prod
WORKDIR /app

# install eshop core
COPY mix.exs mix.lock ./
COPY config config
COPY apps/eshop_core/mix.exs ./apps/eshop_core/mix.exs
RUN mix do deps.get, deps.compile
