defmodule Mix.Tasks.Cy.Account do
  use Mix.Task

  @shortdoc "Generates fake contacts for cypress."
  def run(_id) do
    Mix.Task.run("app.start")

    Rauversion.Accounts.create_user(%{
      email: "test@test.cl",
      username: "test",
      first_name: "Test",
      last_name: "User",
      password: "12345678"
    })
  end
end
