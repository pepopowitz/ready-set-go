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
  - extra ts configuration (compile time checking) described here: https://buildwithelixir.com/react-typescript-phoenix
    - and that didn't actually work for me. I found a working project in GitHub: https://github.com/mbta/arrow/blob/7bbddec284ee698e3b2ceffcb4492a58132aa431/config/dev.exs#L24
    - and that _still_ didn't work for me, because the `--jsx` option needed to be set to `preserve` in VS code and the watcher, but _not_ in the actual build.
    - It turns out, what I wanted was `--jsx react` in my tsconfig.json, to accomodate all cases.
- Using React with Phoenix

## Notes

- Start postgres: `docker compose up -d`
- Create db: `mix ecto.create`
- Run locally: `mix phx.server`
- List all databases: `psql -h localhost -l -U postgres`
- Local db connection: `psql -h localhost -U postgres`
- run inside iex: `iex -S mix phx.server`

## TODO

- liveview components
- building forms the phoenix way?
- connecting react components to liveview
- deployment
-
