FROM node:6 as builder
COPY . /build
RUN /build/prebuild.sh

FROM node:6-alpine

ENV NODE_ENV=production \
    UID=990 \
    GID=990

EXPOSE 3000
COPY . /build
COPY --from=builder /patron-web/dist /patron-web/dist
COPY --from=builder /patron-web/lib  /patron-web/lib
COPY --from=builder /patron-web/package*.json /patron-web/.
RUN /build/build.sh
WORKDIR /patron-web
CMD ./entrypoint.sh
