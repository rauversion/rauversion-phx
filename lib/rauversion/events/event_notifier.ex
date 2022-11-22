defmodule Rauversion.Events.EventNotifier do
  import Swoosh.Email
  import RauversionWeb.Gettext

  use Phoenix.Swoosh,
    view: RauversionWeb.EventNotifierView,
    layout: {RauversionWeb.LayoutView, :email}

  # root: "path_to/templates"

  alias Rauversion.{Mailer, Repo}

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, _body = [template, %{} = options]) do
    email =
      new()
      |> to(recipient)
      |> from({"Rauversion", System.get_env("EMAIL_ACCOUNT", "foo@bar.com")})
      |> subject(subject)
      |> render_body(template, options)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"Rauversion", System.get_env("EMAIL_ACCOUNT", "foo@bar.com")})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  def deliver_event_tickets(purchase_order, message \\ nil, inviter \\ nil) do
    purchase_order = purchase_order |> Repo.preload([:user])

    user = purchase_order.user

    tickets =
      user
      |> Ecto.assoc(:purchased_tickets)
      |> Rauversion.PurchasedTickets.filter_by_purchase_order(purchase_order.id)
      |> Repo.all()
      |> Repo.preload(event_ticket: [:event])

    deliver(user.email, gettext("Event Tickets confirmation"), [
      "deliver_event_tickets.html",
      %{
        user: user,
        tickets: tickets,
        purchase_order: purchase_order,
        message: message,
        inviter: inviter
      }
    ])
  end

  def deliver_event_streaming_url(user, event) do
    deliver(user.email, "The #{event.title} live streaming", """

    ==============================

    Hi #{user.email},

    This is the event streaming link

    ==============================
    """)
  end
end
