# ======================
# STAGE 1: BUILD
# ======================
FROM node:18 AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# RUN npm run build  # si algún día necesitas un build

# ======================
# STAGE 2: PRODUCTION
# ======================
FROM node:18-alpine AS production

WORKDIR /app

# Copiar SOLO lo necesario desde build
COPY --from=build /app/package*.json ./
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app ./

ENV NODE_ENV=production
EXPOSE 3000

USER node

CMD ["node", "app/index.js"]
