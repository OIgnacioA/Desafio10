# dependencias
FROM node:18-alpine AS deps
WORKDIR /app
COPY package.json ./
RUN npm install
# construcción
FROM node:18-alpine AS builder

WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN npm run build
# Etapa final
FROM node:18-alpine AS runner

WORKDIR /app
COPY --from=builder --chown=node:node /app/dist ./dist
COPY --from=builder --chown=node:node /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

USER node
# Expone el puerto en el que corre la aplicación
EXPOSE 3000
CMD ["node", "dist/main.js"]
