# ReadySetGo

An app for timing and tracking a triathlon, built with [Phoenix](https://www.phoenixframework.org/).

## Get started

1. Install prerequisites

   [The Phoenix installation guide](https://hexdocs.pm/phoenix/installation.html) covers this best. You'll need Erlang, Elixir, the Hex package manager, and the Phoenix framework.

   You'll also need Docker, to run a PostgreSQL instance locally.

2. Run a PostgreSQL database locally

   ```sh
   docker compose up -d
   ```

3. Set up the environment

   ```sh
   mix setup
   ```

   This command will:

   - install dependencies
   - create the database
   - run all data migrations
   - seed data
     - a Camundathlon event
     - multiple athletes for that event
     - an admin user with credentials `readysetgo@example.com` / `letsrace!!!!!`

4. Run locally

   To start your local Phoenix server:

   ```sh
   mix phx.server
   ```

5. Visit [`localhost:4000`](http://localhost:4000) from your browser

   When unauthenticated:

   - http://localhost:4000 shows only a "Track the Camundathlon" button.
   - http://localhost:4000/track/1 subscribes to athlete times, but does not allow users to advance/roll back athletes.
   - Admin pages are not accessible.

   When authenticated (see seed user above):

   - http://localhost:4000 now shows additional `Manage events` and `Manage athletes` buttons
   - http://localhost:4000/track/1 allows the user to advance/roll back athletes.
   - Admin scaffolds are available to [manage events](http://localhost:4000/events) and [manage athletes](http://localhost:4000/athletes).

## Learn more about Phoenix

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
