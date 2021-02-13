FROM eshop_base:latest as build
COPY apps/eshop_admin/mix.exs ./apps/eshop_admin/mix.exs
COPY apps/eshop_client/mix.exs ./apps/eshop_client/mix.exs
RUN mix do deps.get, deps.compile

COPY apps/eshop_core ./apps/eshop_core
COPY apps/eshop_admin ./apps/eshop_admin
COPY apps/eshop_client ./apps/eshop_client
RUN cd apps/eshop_client && mix do compile && cd ../..;
RUN mix release backend

FROM alpine:3.12 AS app
RUN apk add --no-cache openssl ncurses-libs
WORKDIR /app
RUN chown nobody:nobody /app
USER nobody:nobody
COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/backend ./
ENV HOME=/app
CMD bin/backend eval "EshopCore.Release.migrate" && bin/backend start
