FROM node:18 AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
# Si tuvieras un proceso de build (React, Nest, etc.), aquí iría:
# RUN npm run build

# Stage 2: Runtime (más ligero)
FROM node:18-alpine AS production

WORKDIR /app

COPY package*.json ./
RUN npm install --production

# Copiamos solo lo necesario desde el stage de build
COPY --from=build /app ./ 

ENV NODE_ENV=production
EXPOSE 3000

USER node

CMD ["node", "app/index.js"]
