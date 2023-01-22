FROM node:19.4.0 as webassets-builder

WORKDIR /homepage

COPY src src/
COPY public public/
COPY package.json .
COPY tailwind.config.js .
RUN npm install
RUN npm run build

FROM alpine:3.17.1 as release
WORKDIR /homepage

RUN apk add --update npm

RUN npm install -g serve

COPY --from=webassets-builder /homepage/dist ./dist
COPY docker-entrypoint.sh /usr/local/bin
EXPOSE 3000
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["serve", "-s", "dist", "-l", "3000"]