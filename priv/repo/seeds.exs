# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ReadySetGo.Repo.insert!(%ReadySetGo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# seed a camundathlon event...

event =
  ReadySetGo.Repo.insert!(%ReadySetGo.RaceSpace.Event{
    name: "Camundathlon"
  })

# then some athletes....
ReadySetGo.Repo.insert!(%ReadySetGo.RaceSpace.Athlete{
  event_id: event.id,
  name: "Dipsy",
  number: 1,
  wave: 1,
  wave_index: 1
})

ReadySetGo.Repo.insert!(%ReadySetGo.RaceSpace.Athlete{
  event_id: event.id,
  name: "Lala",
  number: 2,
  wave: 1,
  wave_index: 2
})

ReadySetGo.Repo.insert!(%ReadySetGo.RaceSpace.Athlete{
  event_id: event.id,
  name: "Po",
  number: 3,
  wave: 2,
  wave_index: 1
})

ReadySetGo.Repo.insert!(%ReadySetGo.RaceSpace.Athlete{
  event_id: event.id,
  name: "Tinky Winky",
  number: 4,
  wave: 2,
  wave_index: 2
})

# then an admin user
user_attrs = %{
  email: "readysetgo@mailinator.com",
  password: "letsrace!!!!!"
}

%ReadySetGo.Accounts.User{}
|> ReadySetGo.Accounts.User.registration_changeset(user_attrs)
|> ReadySetGo.Repo.insert!()
