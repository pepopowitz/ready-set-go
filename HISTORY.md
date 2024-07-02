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

  - Except I really followed this guide instead, because I knew I wanted the HTML scaffold instead of API: https://medium.com/@breathethenmove/learning-phoenix-part-2-mix-tasks-and-ecto-25a49b456749

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

3. Sockets and Channels

- Followed https://hexdocs.pm/phoenix/channels.html#generating-a-socket

  - Generate a RaceSpace socket:

    ```
    ❯ mix phx.gen.socket RaceSpace
    * creating lib/ready_set_go_web/channels/race_space_socket.ex
    * creating assets/js/race_space_socket.js

    Add the socket handler to your `lib/ready_set_go_web/endpoint.ex`, for example:

        socket "/socket", ReadySetGoWeb.RaceSpaceSocket,
          websocket: true,
          longpoll: false

    For the front-end integration, you need to import the `race_space_socket.js`
    in your `assets/js/app.js` file:

        import "./race_space_socket.js"
    ```

  - I think the docs are missing the step to create a channel?????

    ```
    ❯ mix phx.gen.channel Event
    * creating lib/ready_set_go_web/channels/event_channel.ex
    * creating test/ready_set_go_web/channels/event_channel_test.exs
    * creating test/support/channel_case.ex

    The default socket handler - ReadySetGoWeb.UserSocket - was not found.

    Do you want to create it? [Yn] n

    To create it, please run the mix task:

        mix phx.gen.socket User

    Then add the channel to the newly created file, at `lib/ready_set_go_web/channels/user_socket.ex`:

        channel "event:lobby", ReadySetGoWeb.EventChannel
    ```

    - I'm not sure why it doesn't let me specify the associated socket in the command, maybe it does?

    - Whoa, I think I misunderstood! Channels/sockets are different than Liveview. Liveview looks very similar to hotwire/ajax/asp.net updatepanels? I think it will actually work really well so I'm going to restart with that.

  - RESTART
    - https://www.youtube.com/watch?v=GsOcNO0NlHU
    - 1. do I want user auth? skipping for now but there's a generator for it.
    - 2. `mix phx.gen.live RaceSpace Event events ...` -- same as before but with .live, and then I cleaned up the overlap.

4. Liveview

- at some point I think I decided that I want a LiveView controller, but I also need to use PubSub to push updates to other LiveView users.
- I started by attempting to implement a liveview controller that does basically the same thing as my Event scaffold.
  - `mix phx.gen.live TrackerSpace Tracker trackers name:string start_time:naive_datetime_usec end_time:naive_datetime_usec`
  - I then pointed the generated TrackerSpace implementation functions at the existing Event entity, and removed the overlap.
  - this seemed to work fine, but I wanted something more specific to my use case of a liveview that can do simple edits, and pubsub so that all active liveviews see the edits realtime.
- I started over with https://github.com/dwyl/phoenix-liveview-chat-example.
  - I asked Copilot to write the `def handle_event("update_start_time"` function for me, and it nailed it.
  - now I have a working liveview that does simple inline edits to the "start time" property.
- next I need to subscribe to something so that other users see the edits.
  - this also came from https://github.com/dwyl/phoenix-liveview-chat-example

5. Deployment

- https://hexdocs.pm/phoenix/gigalixir.html
- I did this to link the project locally to my gigalixir app: `gigalixir git:remote ready-set-go-test`
  - I set versions in tool-versions instead of whatever that doc recommends, because this said so: https://www.gigalixir.com/docs/getting-started-guide/phoenix-releases-deploy
- the hexdocs re: running migrations did not work. Apparently when deploying via elixir releases, there is no `mix` available so `gigalixir run mix ecto.migrate` doesn't work.
  - the gigalixir docs tell me to use a different command: https://www.gigalixir.com/docs/database#runnning-migrations
    - first, add an ssh key to gigalixir. Those instructions reference an ssh key that I don't have (id*rsa.pub), but https://www.gigalixir.com/docs/runtime tells me I can use a key that I \_do* have: `gigalixir account:ssh_keys:add "$(cat ~/.ssh/id_ed25519.pub)"`
    - then, I tried to run the gigalixir recommended command: `gigalixir ps:migrate`
    - that kept crashing my app! It would run out of memory every time.
      - I was able to identify this by tailing the logs: `gigalixir logs`
    - but apparently I could scale it in the gigalixir console for free? I'm not sure what the upper limit is, but I bumped the app from 0.3 gb to 0.5 gb. Then the migrations ran!
- and now I have a running app at:
  - https://ready-set-go-test.gigalixirapp.com/
  - https://ready-set-go-test.gigalixirapp.com/events to add/edit events
  - https://ready-set-go-test.gigalixirapp.com/track for liveview!

6. More data

- Adding a Wave entity
  - `mix phx.gen.html RaceSpace Wave waves event_id:references:events race_index:integer start_time:naive_datetime_usec end_time:naive_datetime_usec`
    - note the `event_id` for a 1:m relationship
    - and add the resource to the router:
      - `resources "/waves", WaveController`
    - and then I also added associations to models:
      - `has_many :waves, ReadySetGo.RaceSpace.Wave`
      - `belongs_to :event, ReadySetGo.RaceSpace.Event`
    - I also had to remove the `event_id` field that had been added to the Wave model
      - `field :event_id, :id`
      - but _add_ it to the `cast` and `validate_required` calls in `changeset`
    - and then run the migration
      - `mix ecto.migrate`
    - ## I also added a field to the forms:
    - copilot told me how to do most of this, but https://www.alanvardy.com/post/associations-phoenix described the things I was missing.
- Displaying an association in the scaffolded forms

  - I had to do a lot of manual twiddling to get the associated event showing on a wave.
  - New

    - in WaveController#new, look up the events that can be associated to, map them to name/id tuples, and then pass them in the `assigns` map:

      ```
      events = RaceSpace.list_events()
        |> Enum.map(&{&1.name, &1.id})

      render(conn, :new, changeset: changeset, events: events)
      ```

    - pass the events through the `new` template into `wave_form`: `<.wave_form ... events={@events} />`
    - add a select field to `wave_form` for the events:
      ```
      <.input field={f[:event_id]} type="select" label="Event"
        options={@events} />
      ```

  - Index
    - tell the repo to preload the associated event, so I can drill over to it: `Repo.all(Wave) |> Repo.preload(:event)`
    - drill over to the event name in the table: `<:col :let={wave} label="Event"><%= wave.event.name %></:col>`
  - Show
    - same thing as Index, mostly
    - instead of preloading in RaceSpace (context), I did it in WaveController, like this: `wave = RaceSpace.get_wave!(id) |> Repo.preload(:event)`
    - I'm not sure how much I like accessing Repo in the WaveController.
    - This seems like a really nice solution: https://elixirforum.com/t/where-do-you-preload-associations/45031/14
    - and then render the event name in the view, like in Index: `<:item title="Event"><%= @wave.event.name %></:item>`
  - Edit

    - because New added `@events` to the shared `wave_form`, I need to add that to the assigns in the controller again
    - this time I extracted a function named `get_events()` and called that from both new and edit.
    - and I also needed to pass the events through `edit.html.heex`.

  - Update
    - no changes
  - Delete
    - no changes

- Adding an Athlete entity

  - mix phx.gen.html RaceSpace Athlete athletes name:string wave_index:integer wave_id:references:waves number:integer start_time:naive_datetime_usec t1_time:naive_datetime_usec t2_time:naive_datetime_usec end_time:naive_datetime_usec
  - mix ecto.migrate
  - add the resource to the router:
    - `resources "/athletes", AthleteController`
  - add associations to models:
    - wave: `has_many :athletes, ReadySetGo.RaceSpace.Athlete`
    - athlete: `belongs_to :wave, ReadySetGo.RaceSpace.Wave`
  - remove the :wave_id field from athlete.ex
    - add it to the `cast` and `validate_required` calls in `changeset`
  - remove optional fields from validate_required
  - add field to scaffolded forms

    - Index
      - preload the :wave from the athlete lookup, so I can drill over to it.
        - I did this with the `preloads` argument to the space function `load_athletes`:
          ```
          def list_athletes(preload \\ []) do
            Repo.all(Athlete)
            |> Repo.preload(preload)
          end
          ```
        - usage from controller:
          - `athletes = RaceSpace.list_athletes([:wave])`
      - drill over to the event name in the table: `<:col :let={athlete} label="Wave"><%= athlete.wave.name %></:col>`
    - New

      - in AthleteController#new, look up the waves that can be associated to, map them to name/id tuples, and then pass them in the `assigns` map:

        ```
        waves = RaceSpace.list_waves()
          |> Enum.map(&{&1.name, &1.id})

        render(conn, :new, changeset: changeset, waves: waves)
        ```

      - pass the waves through the `new` template into `athlete_form`: `<.athlete_form ... waves={@waves} />`
      - add a select field to `athlete_form` for the waves:
        ```
        <.input field={f[:wave_id]} type="select" label="Wave"
          options={@waves} />
        ```

      ```

      ```

    - Show
      - same thing as Index
        - add preload param to RaceSpace#get_athlete!
        - preload [:wave] from AthleteController#show
        - render the wave name in the view: `<:item title="Wave"><%= @athlete.wave.name %></:item>`
    - Edit
      - because New added `@waves` to the shared `athlete_form`, I need to add that to the assigns in the controller again
      - I already extracted a function named `get_waves()` so call that
      - and pass the waves through `edit.html.heex`.

- Add athletes to tracker

  - Update the tracker_space query to join the other tables proactively:

    ```
      query =
      from(e in Event,
        where: e.id == ^id,
        join: w in assoc(e, :waves),
        join: a in assoc(w, :athletes),
        order_by: [asc: w.index, asc: a.wave_index],
        preload: [waves: {w, athletes: a}]
      )

      Repo.one!(query)
    ```

  - Update the view to emit nested arrays (lots of tailwind changes here)
  -

## Notes

- Start postgres: `docker compose up -d`
- Create db: `mix ecto.create`
- Run locally: `mix phx.server`
- List all databases: `psql -h localhost -l -U postgres`
- Local db connection: `psql -h localhost -U postgres`
- run inside iex: `iex -S mix phx.server`
- re: phx.gen.json vs phx.gen.html -- if I want API endpoints, use .json. If I want scaffolded forms, use .html.
  - I _think_ I can add .json after I add .html for the same resource if I need both?
    - nope, at least not in the same context.
    - and even in a different context, it will overwrite controllers!
    - That's dumb. If a "context" is a logical namespace, it should namespace it physically, too.
- naive_datetime_usec vs utc_datetime_usec -- I'm choosing naive because we will all be in the same time zone for this event.
- `mix ecto.rollback` to roll back a schema migration
- running `mix test` will auto-run migrations against the test db, but if I want to do something with migrations against test db manually, use an env variable: `MIX_ENV=test mix ecto.rollback`
- annoying thing -- prettier wants me to use parens for every function call; phx generates ruby-like calls without parens. How do I get prettier to use the phx standard?
- a nice article about pros/cons of elixir/phoenix ecosystem: https://www.sean-lawrence.com/things-to-consider-before-starting-an-elixir-phoenix-project/
- deploy to gigalixir: `git push gigalixir`

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

1. [x] scaffold a crud operation to get the concept of a "race"
2. [x] view a race via liveview (phoenix way)
3. ~view a race via liveview (react way)~ I don't think I need this!
4. [x] update a race via liveview (react way)
5. [x] deploy
6. [x] Add waves
   1. [x] what does the scaffold editor look like when there's a relationship?
7. [x] list waves in full tracker
   1. [x] how to list relationships in the tracker?
8. [x] Add athletes
9. [x] interactivity for full tracker
   1. [x] display athletes by wave
   2. [x] move to next step
   3. [x] move back a step
10. [x] Sort tracker by fastest & furthest along
    1. [x] show waves as a field instead of grouping?
11. [x] Make it obvious when someone gets updated
12. [ ] Show durations instead of timestamps
    1. [ ] Sort by durations instead of timestamps
13. [ ] Show live timers
14. Make it look nicer
15. [ ] Add auth
    1. [ ] Add admin user
    2. [ ] Hide buttons for non-admin user
16. ci deployment?
17.
