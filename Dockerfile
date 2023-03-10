FROM node:19.4.0 as webassets-builder

WORKDIR /homepage

COPY homepage/src src/
COPY homepage/public public/
COPY homepage/package.json .
COPY homepage/tailwind.config.js .
RUN npm install
RUN npm run build

FROM alpine:3.17.1 as release
WORKDIR /homepage
ARG VERSION
ENV VERSION=${VERSION:-1.0.0}
RUN echo $VERSION > image_version

RUN apk add --update npm

RUN npm install -g serve

COPY --from=webassets-builder /homepage/dist ./dist
COPY docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 3000
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["serve", "-s", "dist", "-l", "3000"]