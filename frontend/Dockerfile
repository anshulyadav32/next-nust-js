# Build stage
FROM node:20-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# Production stage  
FROM node:20-alpine AS runtime

WORKDIR /app
COPY --from=builder /app/.output ./.output
COPY --from=builder /app/package*.json ./

EXPOSE 3002

ENV NITRO_PORT=3002
ENV NITRO_HOST=0.0.0.0

CMD ["node", ".output/server/index.mjs"]
