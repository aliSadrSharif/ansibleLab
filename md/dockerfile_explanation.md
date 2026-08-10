# Dockerfile Explanation

## Frontend (`frontend/Dockerfile`) — multi-stage

| Line / block | Purpose |
|--------------|---------|
| `# syntax=docker/dockerfile:1` | Enable BuildKit features |
| `FROM node:24-alpine3.22 AS build` | Small official Node image for compile stage |
| `WORKDIR /app` | App working directory |
| `COPY package*.json ./` then `npm install` | Cache dependency layer separately from source |
| `COPY . .` | Copy application source |
| `ARG REACT_APP_API_URL=/api` | Bake API base path for CRA at build time |
| `ARG NODE_OPTIONS=--max-old-space-size=1536` | Cap Node heap for low-RAM VMs (1–2 GB) |
| `RUN npm run build` | Produce optimized static assets in `/app/build` |
| `FROM node:24-alpine3.22 AS runtime` | Fresh runtime image without build toolchain |
| `adduser` / `addgroup` | Run as non-root `app` user |
| `npm install -g serve` | Static file server for SPA |
| `COPY --from=build --chown=app:app /app/build` | Copy only built artifacts |
| `USER app` | Drop privileges |
| `EXPOSE 3000` | Document listen port |
| `HEALTHCHECK` | Probe `http://127.0.0.1:3000` |
| `CMD ["serve", "-s", "build", "-l", "3000"]` | Serve SPA with client-side routing |

## Backend (`backend/Dockerfile`)

| Line / block | Purpose |
|--------------|---------|
| `FROM node:24-alpine3.22` | Official Alpine Node runtime |
| Non-root `app` user | Security best practice |
| `COPY package*.json` + `npm install --omit=dev` | Production deps only, layer-cached |
| `COPY . .` | Application source (`index.js`) |
| `chown` + `USER app` | Non-root runtime |
| `EXPOSE 3001` | API port |
| `HEALTHCHECK` | Probe `/users` |
| `CMD ["node", "index.js"]` | Start Express server |

## `.dockerignore`

Both `frontend/.dockerignore` and `backend/.dockerignore` exclude `node_modules`, build output, and local junk so images stay small and rebuilds stay fast.
