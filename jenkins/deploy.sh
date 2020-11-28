#!/bin/bash

docker rm -f eshop-backend

docker run -d --name eshop-backend \
  --network my-net \
  -e DATABASE_URL=postgres://phathdt379:password123@10.148.0.13:5432/eshop \
  -e SECRET_KEY_BASE=43HToczwEtbLIujVyC/L7syuUDAEHklOVydWoxt6Tu33IfUGT8ZaQbpVTcH5jnw8 \
  -e SECRET_JOKEN=43HToczwEtbLIujVyC/L7syuUDAEHklOVydWoxt6Tu33IfUGT8ZaQbpVTcH5jnw8 \
  -e CLOUDEX_API_KEY=141644434633821 \
  -e CLOUDEX_SECRET=02TvjPRBlZa7rnhp8MOUy_HVoWM \
  -e CLOUDEX_CLOUD_NAME=dudnown4z \
  -e CLOUDEX_CLOUD_ENV=test \
  -e SENTRY_DSN=https://de992d97744c4527a8ba64ce3d7141e9:688b0a2f41c14a6a97b533d755b71dce@o437505.ingest.sentry.io/5400205 \
  -e ELASTIC_HOST=http://10.148.0.13:9200 \
  -p 4000:4000 \
  ${DOCKER_IMAGE}:$BUILD_NUMBER
