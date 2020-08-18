FROM elixir:1.10.3-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base

ENV MIX_ENV=prod
# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
  mix local.rebar --force

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# compile and build release
COPY priv priv
COPY lib lib

RUN mix do compile, release

# prepare release image
FROM alpine:3.12 AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/eshop ./

ENV HOME=/app

CMD bin/eshop eval "Eshop.Release.migrate" && bin/eshop start
