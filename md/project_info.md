# Project Information

## Source

- **Application**: DaneshkarTeamProject (team MERN-style user management app)
- **Repository**: local workspace `/home/ali/wd/DaneshkarTeamProject` (GitHub remote `origin`)
- **Description**: React frontend + Express API + MongoDB. Users can be listed, created, and deleted via a simple UI. Three API replicas sit behind host Nginx with `least_conn` load balancing. mongo-express provides a DB UI under `/mongo/`.

## Technologies

| Layer | Stack |
|-------|-------|
| Frontend | React (Create React App), served by `serve` |
| Backend | Node.js, Express 5, native `mongodb` driver |
| Database | MongoDB 4.4 |
| Admin UI | mongo-express 1.0.2 |
| Reverse proxy / TLS | Host Nginx (Ubuntu package) + self-signed cert |
| Orchestration | Docker Compose v2 |
| Automation | Ansible (roles: common, docker, nginx, app, ssl, proxy, evidence) |

## Dependencies

### Backend (`backend/package.json`)

- `express`, `cors`, `dotenv`, `mongodb`

### Frontend (`frontend/package.json`)

- React / CRA toolchain; production image is a multi-stage build

### Infrastructure

- Docker CE + Compose plugin
- Nginx
- OpenSSL (via Ansible `community.crypto`)

## Ports

| Service | Container port | Host bind | Public path |
|---------|----------------|-----------|-------------|
| web | 3000 | `127.0.0.1:3000` | `/` via Nginx |
| api-1 | 3001 | `127.0.0.1:3001` | `/api/` (pool) |
| api-2 | 3001 | `127.0.0.1:3002` | `/api/` (pool) |
| api-3 | 3001 | `127.0.0.1:3003` | `/api/` (pool) |
| mongo-express | 8081 | `127.0.0.1:8081` | `/mongo/` |
| MongoDB | 27017 | not published | internal only |
| Nginx HTTP | — | `0.0.0.0:80` | redirect → HTTPS |
| Nginx HTTPS | — | `0.0.0.0:443` | TLS termination |

All application containers bind to loopback only so Docker port publishing cannot bypass UFW. External access is exclusively through host Nginx on 80/443.
