# Setting this thing up

I used a mish mash of resources to get started with this app.

1. Configured things from https://github.com/aisrael/elixir-phoenix-typescript-react

- Erlang
- Elixir
- Postgres via Docker Compose
- Hex
- Phoenix application generator

2. Set up a new phoenix/react app from https://blog.logrocket.com/to-do-list-phoenix-react-typescript/

- Setting up our Phoenix application
- Using TypeScript with Phoenix

## Notes

- Run locally: `mix phx.server`
- Start postgres: `docker compose up -d`
- List all databases: `psql -h localhost -l -U postgres`
- Local db connection: `psql -h localhost -U postgres`
