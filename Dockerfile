# Do a build step that compiles the code
FROM node:10 as builder
ARG PATRONWEB_REPO=https://github.com/NYPL-Simplified/circulation-patron-web.git
ARG REPO_VERSION=master
ARG OPDSWEB_REPO=https://github.com/NYPL-Simplified/opds-web-client.git
ARG OPDSWEB_REPO_VERSION=master
ARG DEPLOY_TYPE=""
COPY . /build
RUN if [ "$DEPLOY_TYPE" = "" ] ; then /build/prebuild.sh "${PATRONWEB_REPO}" "${REPO_VERSION}"; else /build/prebuild_${DEPLOY_TYPE}.sh "${PATRONWEB_REPO}" "${REPO_VERSION}" "${OPDSWEB_REPO}" "${OPDSWEB_REPO_VERSION}"; fi

# Copy the compiled code from the builder and
# create a smaller conatiner using it.
FROM node:10-alpine
ENV NODE_ENV=production \
    UID=990 \
    GID=990
EXPOSE 3000
COPY . /build
COPY --from=builder /patron-web/dist /patron-web/dist
COPY --from=builder /patron-web/lib  /patron-web/lib
COPY --from=builder /patron-web/package*.json /patron-web/
COPY --from=builder /patron-web/webpack* /patron-web/
RUN /build/build.sh
WORKDIR /patron-web
CMD ./entrypoint.sh
