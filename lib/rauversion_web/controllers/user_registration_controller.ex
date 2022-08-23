defmodule RauversionWeb.UserRegistrationController do
  use RauversionWeb, :controller

  alias Rauversion.Accounts
  alias Rauversion.Accounts.User
  alias RauversionWeb.UserAuth

  def new(conn, _params) do
    user =
      case conn |> get_session(:post_register_oauth_credential) do
        %{provider: _provider, name: name, email: email} ->
          %User{first_name: name, email: email}

        _ ->
          %User{}
      end

    changeset = Accounts.change_user_registration(user)

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    register_user(conn, user_params)
  end

  defp register_user(conn, user_params) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :edit, &1)
          )

        case conn |> get_session(:post_register_oauth_credential) do
          user_data = %{provider: _provider} ->
            case Accounts.create_oauth_credential(user, user_data) |> Rauversion.Repo.insert!() do
              {:ok, _r} -> conn |> delete_session(:post_register_oauth_credential)
              _ -> nil
            end

          _ ->
            nil
        end

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
