FROM eshop_base:latest as build
COPY apps/eshop_api_client/mix.exs ./apps/eshop_api_client/mix.exs
COPY apps/eshop_client/mix.exs ./apps/eshop_client/mix.exs
RUN mix do deps.get, deps.compile

FROM build as build-backend
COPY apps/eshop_core ./apps/eshop_core
COPY apps/eshop_api_client ./apps/eshop_api_client
COPY apps/eshop_client/config ./apps/eshop_client/config
COPY apps/eshop_client/lib ./apps/eshop_client/lib
COPY apps/eshop_client/mix.exs ./apps/eshop_client/mix.exs
RUN cd apps/eshop_client mix do compile

FROM build as build-frontend
WORKDIR /app/apps/eshop_client/assets
COPY apps/eshop_client/assets/package.json ./
COPY apps/eshop_client/assets/yarn.lock ./yarn.lock
RUN yarn install
COPY apps/eshop_client/assets/ ./
RUN yarn deploy

FROM build-backend as build-final
COPY --from=build-frontend --chown=nobody:nobody /app/apps/eshop_client/assets ./apps/eshop_client/assets
COPY --from=build-frontend --chown=nobody:nobody /app/apps/eshop_client/priv ./apps/eshop_client/priv
RUN cd apps/eshop_client && mix do compile, phx.digest && cd ../..;
RUN mix release client

FROM alpine:3.12
RUN apk add --no-cache openssl ncurses-libs
WORKDIR /app
RUN chown nobody:nobody /app
USER nobody:nobody
COPY --from=build-final --chown=nobody:nobody /app/_build/prod/rel/client ./
ENV HOME=/app
EXPOSE 6000
CMD bin/client eval "EshopCore.Release.migrate" && bin/client start
