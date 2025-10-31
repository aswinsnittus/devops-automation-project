FROM node:18-alpine
WORKDIR /usr/src/app
COPY app/package.json app/package-lock.json* ./app/
RUN cd app && npm install --production
COPY app ./app
WORKDIR /usr/src/app/app
EXPOSE 8080
CMD ["node","server.js"]
