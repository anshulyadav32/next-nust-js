# Build stage
FROM node:20-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Production stage  
FROM node:20-alpine AS runtime

WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .

RUN npm run build

EXPOSE 3002

ENV NITRO_PORT=3002
ENV NITRO_HOST=0.0.0.0

CMD ["npm", "start"]
