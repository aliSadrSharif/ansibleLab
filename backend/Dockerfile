# syntax=docker/dockerfile:1
FROM node:24-alpine3.22

# Non-root user for the runtime process
RUN addgroup -S app && adduser -S app -G app

WORKDIR /app

# Install dependencies first so this layer is cache-hit on source-only changes
COPY package*.json ./
RUN npm install --omit=dev && npm cache clean --force

# Copy application source
COPY . .

RUN chown -R app:app /app
USER app

EXPOSE 3001

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD node -e "require('http').get('http://127.0.0.1:3001/users', r => process.exit(r.statusCode < 500 ? 0 : 1)).on('error', () => process.exit(1))"

CMD ["node", "index.js"]
