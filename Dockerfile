FROM debian AS builder


ENV HARMONY_API_VERSION=2.3.5

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y wget

WORKDIR /src
RUN wget -O- https://github.com/maddox/harmony-api/archive/${HARMONY_API_VERSION}.tar.gz | tar xz && \
    mv harmony-api-${HARMONY_API_VERSION} harmony-api

RUN echo $PWD
RUN ls



FROM node:argon

COPY --from=builder /src/harmony-api /src/harmony-api

WORKDIR /src/harmony-api
RUN npm install

RUN chown 1234:1234 -R /src/harmony-api  && \
    cp ./config/config.sample.json ./config/config.json

USER 1234
ENV HOME=/src/harmony-api

EXPOSE 8282
ENTRYPOINT ["npm", "start"]
