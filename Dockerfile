# Do a build step that compiles the code
FROM node:8 as builder
ARG PATRONWEB_REPO=https://github.com/NYPL-Simplified/circulation-patron-web.git
ARG REPO_VERSION=master
COPY . /build
RUN /build/prebuild.sh "${PATRONWEB_REPO}" "${REPO_VERSION}"

# Copy the compiled code from the builder and
# create a smaller conatiner using it.
FROM node:8-alpine
ENV NODE_ENV=production \
    UID=990 \
    GID=990
EXPOSE 3000
COPY . /build
COPY --from=builder /patron-web/dist /patron-web/dist
COPY --from=builder /patron-web/lib  /patron-web/lib
COPY --from=builder /patron-web/package*.json /patron-web/
RUN /build/build.sh
WORKDIR /patron-web
CMD ./entrypoint.sh
