FROM node:14-alpine AS base

WORKDIR app

COPY package*.json ./

FROM base AS dev
RUN npm ci && npm cache clean --force

FROM base AS prod
RUN npm ci --only=prod && npm cache clean --force
COPY . .
CMD ["node", "src/index.js"]
