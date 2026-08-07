# Dockerfile Explanation

This project has two Dockerfiles: `backend/Dockerfile` and `frontend/Dockerfile`.

## `backend/Dockerfile`

```dockerfile
FROM node:24-alpine3.22                        # official, small Alpine-based Node image
RUN addgroup -S app && adduser -S app -G app   # dedicated non-root user
WORKDIR /app
COPY package*.json ./                          # copy manifests first -> better layer cache
RUN npm install --omit=dev && npm cache clean --force   # prod deps only, smaller image
COPY . .                                       # copy source after deps are cached
RUN chown -R app:app /app
USER app                                       # drop root before running the app
EXPOSE 3001
HEALTHCHECK ...                                # container reports healthy/unhealthy
CMD ["node", "index.js"]                       # production start command (no nodemon)
```

Key decisions:
- `--omit=dev` skips `nodemon` (a dev-only tool) from the final image.
- Copying `package*.json` before the rest of the source lets Docker reuse the
  `npm install` layer whenever only application code changes.
- The container runs as the unprivileged `app` user, not root.
- `HEALTHCHECK` lets `docker compose ps` / Ansible report real service health instead of
  just "container is running".

## `frontend/Dockerfile` (multi-stage build)

```dockerfile
# Stage 1: build
FROM node:24-alpine3.22 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
ARG REACT_APP_API_URL=/api
ENV REACT_APP_API_URL=${REACT_APP_API_URL}
RUN npm run build                              # produces static, minified assets

# Stage 2: runtime
FROM node:24-alpine3.22 AS runtime
RUN addgroup -S app && adduser -S app -G app && npm install -g serve
WORKDIR /app
COPY --from=build --chown=app:app /app/build ./build   # only the static build is copied
USER app
EXPOSE 3000
HEALTHCHECK ...
CMD ["serve", "-s", "build", "-l", "3000"]
```

Key decisions:
- **Multi-stage build**: the `build` stage contains the full `node_modules` and the
  React/Babel toolchain (~300+ MB); only the compiled `build/` output (a few hundred KB)
  is copied into the final `runtime` image, which never sees `node_modules` or dev tooling.
- `serve` is a minimal static file server — no full Nginx/React dev server is needed inside
  the container, since the system-level Nginx (installed in stage 2/6) already handles
  TLS termination and reverse proxying in front of it.
- Non-root user, `HEALTHCHECK`, and small final image size follow the assignment's security
  and optimization hints.
