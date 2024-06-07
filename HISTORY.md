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
  - extra ts configuration (compile time checking) described here: https://buildwithelixir.com/react-typescript-phoenix and https://disusered.com/blog/phoenix-with-typescript/
    - and that didn't actually work for me. I found a working project in GitHub: https://github.com/mbta/arrow/blob/7bbddec284ee698e3b2ceffcb4492a58132aa431/config/dev.exs#L24
    - and that _still_ didn't work for me, because the `--jsx` option needed to be set to `preserve` in VS code and the watcher, but _not_ in the actual build.
    - It turns out, what I wanted was `--jsx react` in my tsconfig.json, to accomodate all cases.
    - if I decide I want to convert app.jsx to app.tsx, this article helps: https://disusered.com/blog/phoenix-with-typescript/
- Using React with Phoenix
- Creating the todo-list schema

  - Another helpful doc at this point: https://medium.com/@breathethenmove/learning-phoenix-part-2-mix-tasks-and-ecto-25a49b456749

  - I started with a `race` schema instead of todo

    - `mix phx.gen.html Race Race races name:string start_time:naive_datetime_usec end_time:naive_datetime_usec`

      - this doesn't work because the Context name (first `Race`) must be different than the Schema name (second `Race`).
      - instead I'll name the schema `Event`:

        ```sh
        ❯ mix phx.gen.html Race Event events name:string start_time:naive_datetime_usec end_time:naive_datetime_usec
        * creating lib/ready_set_go_web/controllers/event_controller.ex
        * creating lib/ready_set_go_web/controllers/event_json.ex
        * creating lib/ready_set_go_web/controllers/changeset_json.ex
        * creating test/ready_set_go_web/controllers/event_controller_test.exs
        * creating lib/ready_set_go_web/controllers/fallback_controller.ex
        * creating lib/ready_set_go/race/event.ex
        * creating priv/repo/migrations/20240607152737_create_events.exs
        * creating lib/ready_set_go/race.ex
        * injecting lib/ready_set_go/race.ex
        * creating test/ready_set_go/race_test.exs
        * injecting test/ready_set_go/race_test.exs
        * creating test/support/fixtures/race_fixtures.ex
        * injecting test/support/fixtures/race_fixtures.ex

        Add the resource to your :api scope in lib/ready_set_go_web/router.ex:

            resources "/events", EventController, except: [:new, :edit]


        Remember to update your repository by running migrations:

            $ mix ecto.migrate
        ```

  - Two steps required after generating the schema:
    1. Add new resource to router.ex (inside the `web` scope)
    2. Migrate the database! `mix ecto.migrate`
  - ha ha ha oops I accidentally ran `json` instead of `html` the first time. It generated an API, not web, obvs. I updated the commands above to say `html` instead of `json`.
    - note that I discovered I ran json because I tried to run `mix test`, and the generated tests failed.
      - 404s on the API endpoints. Discovered they were testing the api not the forms!
  - Oh no! My form comes up at /events, but I didn't mark start and end times optional!
    - rolled it back again & made things optional, by removing the start_time/end_time fields from `validate_required` in `event.ex#changeset`:
      - `|> validate_required([:name, :start_time, :end_time])` to `|> validate_required([:name])`

## Notes

- Start postgres: `docker compose up -d`
- Create db: `mix ecto.create`
- Run locally: `mix phx.server`
- List all databases: `psql -h localhost -l -U postgres`
- Local db connection: `psql -h localhost -U postgres`
- run inside iex: `iex -S mix phx.server`
- re: phx.gen.json vs phx.gen.html -- if I want API endpoints, use .json. If I want scaffolded forms, use .html.
  - I _think_ I can add .json after I add .html for the same resource if I need both?
- naive_datetime_usec vs utc_datetime_usec -- I'm choosing naive because we will all be in the same time zone for this event.
- `mix ecto.rollback` to roll back a schema migration
- running `mix test` will auto-run migrations against the test db, but if I want to do something with migrations against test db manually, use an env variable: `MIX_ENV=test mix ecto.rollback`
- annoying thing -- prettier wants me to use parens for every function call; phx generates ruby-like calls without parens. How do I get prettier to use the phx standard?
- a nice article about pros/cons of elixir/phoenix ecosystem: https://www.sean-lawrence.com/things-to-consider-before-starting-an-elixir-phoenix-project/
-

## Schema

### Context: Race

#### Event

name:string
waves 1:n
start-time:naive_datetime_usec
end-time:naive_datetime_usec

#### Wave

race
race-index:integer
athletes 1:n
start-time:naive_datetime_usec
end-time:naive_datetime_usec

#### Athlete

wave
wave-index:integer
race
name:string
number:integer
start-time:naive_datetime_usec
t1-time:naive_datetime_usec
t2-time:naive_datetime_usec
finish-time:naive_datetime_usec

## TODO

- liveview components
- building forms the phoenix way?
  - and scaffolding crud?
- connecting react components to liveview
- deployment

1. scaffold a crud operation to get the concept of a "race"
2. view a race via liveview (phoenix way)
3. view a race via liveview (react way)
4. update a race via liveview (react way)
5. deploy
