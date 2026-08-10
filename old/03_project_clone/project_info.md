# Project Information

## URL

`https://github.com/aliSadrSharif/ansibleLab` (this repository — the team's own web
application, used as the "cloned project" for the Docker/Ansible practice required by this
assignment).

## Description

A small full-stack **user directory** application:

- **Frontend**: React SPA (Create React App) that lists users and lets you add/delete a user
  by name.
- **Backend**: Express.js REST API (`GET/POST /users`, `DELETE /users/:name`) backed by
  MongoDB.
- **Database**: MongoDB, with a Mongo Express web UI for inspection.
- **Reverse proxy**: Nginx in front of everything (TLS termination + routing).

This matches the assignment's requirement of "a web application that uses a database and is
suitable for Docker practice."

## Technology Stack

| Layer | Technology |
|---|---|
| Frontend | React 19, Axios |
| Backend | Node.js 24, Express 5, MongoDB driver |
| Database | MongoDB 4.4, Mongo Express |
| Web/Proxy | Nginx |
| Containerization | Docker, Docker Compose |
| Automation | Ansible |

## Dependencies

**Frontend** (`frontend/package.json`): `react`, `react-dom`, `react-scripts`, `axios`,
`web-vitals`, `@testing-library/*` (dev/test only).

**Backend** (`backend/package.json`): `express`, `mongodb`/`mongoose`, `cors`, `dotenv`,
`cookie-parser`, `nodemon` (dev only).

## Ports

| Service | Container port | Host binding |
|---|---|---|
| web (frontend) | 3000 | 127.0.0.1:3000 (proxied by Nginx) |
| api (backend) | 3001 | 127.0.0.1:3001 (proxied by Nginx at `/api/`) |
| db (MongoDB) | 27017 | not published to host — internal Docker network only |
| mongo-express | 8081 | 127.0.0.1:8081 (proxied by Nginx at `/mongo/`) |
| nginx | 80, 443 | 0.0.0.0:80, 0.0.0.0:443 (public entry point) |
