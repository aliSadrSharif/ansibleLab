# syntax=docker/dockerfile:1

# ---- Build stage ---------------------------------------------------------
FROM node:24-alpine3.22 AS build
WORKDIR /app

# Install dependencies first so this layer is cache-hit on source-only changes
COPY package*.json ./
RUN npm install

# Copy source and produce the optimized production build
COPY . .
ARG REACT_APP_API_URL=/api
ENV REACT_APP_API_URL=${REACT_APP_API_URL}
RUN npm run build

# ---- Runtime stage ---------------------------------------------------------
FROM node:24-alpine3.22 AS runtime
RUN addgroup -S app && adduser -S app -G app \
    && npm install -g serve

WORKDIR /app
COPY --from=build --chown=app:app /app/build ./build

USER app
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD node -e "require('http').get('http://127.0.0.1:3000', r => process.exit(r.statusCode < 500 ? 0 : 1)).on('error', () => process.exit(1))"

CMD ["serve", "-s", "build", "-l", "3000"]
