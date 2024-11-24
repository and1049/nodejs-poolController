FROM node:lts-alpine AS build
RUN apk add --no-cache make gcc g++ python linux-headers udev tzdata
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build
RUN npm ci --production

FROM node:lts-alpine as prod
# add additional packages here
RUN apk add --no-cache bash bash-completion 
RUN mkdir /app && chown node:node /app
WORKDIR /app
COPY --chown=node:node --from=build /app .
USER node
ENV NODE_ENV=production
ENTRYPOINT ["node", "dist/app.js"]
