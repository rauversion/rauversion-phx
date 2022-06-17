defmodule Mix.Tasks.FakeAccounts do
  @moduledoc "The hello mix task: `mix help hello`"
  use Mix.Task

  @shortdoc "Generates fake contacts."
  def run(_id) do
    Mix.Task.run("app.start")
    Faker.start()

    # [i] = id
    # app = Chaskiq.Apps.get_app!(i)
    Enum.each(0..50, fn _x ->
      Rauversion.Accounts.create_user(%{
        email: Faker.Internet.email(),
        username: Faker.Internet.user_name(),
        first_name: Faker.Person.first_name(),
        last_name: Faker.Person.last_name(),
        password: Faker.UUID.v4()
      })

      # Ecto.changeset(
      #   app,
      #   :app_users,
      #   state: "passive",
      #   type: "AppUser",
      #   name: Faker.Person.first_name(),
      #   email: Faker.Internet.email(),
      #   properties: %{
      #     last_name: Faker.StarWars.character(),
      #     first_name: Faker.StarWars.character(),
      #     company_name: Faker.Company.name()
      #   }
      # )
      # |> Rauversion.Repo.insert()

      # calling our Hello.say() function from earlier
    end)
  end
end
