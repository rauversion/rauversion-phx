defmodule Rauversion.Accounts.EventNotifier do
  import Swoosh.Email

  alias Rauversion.Mailer

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

  def deliver_event_tickets(user, event) do
    deliver(user.email, "Event Tickets confirmation", """

    ==============================

    Hi #{user.email},

    The purchase of the tickets was successful

    ==============================
    """)
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
