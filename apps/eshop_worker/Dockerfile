FROM eshop_base:latest as build
COPY apps/eshop_mailer/mix.exs ./apps/eshop_mailer/mix.exs
COPY apps/eshop_worker/mix.exs ./apps/eshop_worker/mix.exs
RUN mix do deps.get, deps.compile

COPY apps/eshop_core ./apps/eshop_core
COPY apps/eshop_mailer ./apps/eshop_mailer
COPY apps/eshop_worker ./apps/eshop_worker
RUN cd apps/eshop_worker && mix do compile && cd ../..;
RUN mix release worker

FROM alpine:3.12 AS app
RUN apk add --no-cache openssl ncurses-libs
WORKDIR /app
RUN chown nobody:nobody /app
USER nobody:nobody
COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/worker ./
ENV HOME=/app
CMD bin/worker eval "EshopCore.Release.migrate" && bin/worker start
