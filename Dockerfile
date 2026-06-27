#===== ETAPA 1: construcción (instalación de dependencias) ======
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY . .

# ====== ETAPA 2: producción (solo dependencias de producción) ======
FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY --from=build /app /app
USER appuser
EXPOSE 8081
CMD ["node", "server.js"]