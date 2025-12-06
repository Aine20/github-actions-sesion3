FROM node:18 AS build

WORKDIR /app

# Copia los package.json desde la carpeta app
COPY app/package*.json ./

RUN npm install

# Copia TODO el código de /app dentro del contenedor
COPY app/. .

# ------------------------------
# STAGE 2: Producción
# ------------------------------
FROM node:18-alpine AS production

WORKDIR /app

COPY app/package*.json ./
RUN npm install --production

# Copiamos todo desde build
COPY --from=build /app ./

ENV NODE_ENV=production
EXPOSE 3000

USER node

CMD ["node", "index.js"]
