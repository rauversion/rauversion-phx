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
      |> add_attachments(options[:attachments])
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

  def deliver_event_tickets(purchase_order, message \\ nil, inviter \\ nil, options \\ []) do
    defaults = [subject: nil, event: nil]
    options = Keyword.merge(defaults, options)

    purchase_order = purchase_order |> Repo.preload([:user])

    user = purchase_order.user

    tickets =
      user
      |> Ecto.assoc(:purchased_tickets)
      |> Rauversion.PurchasedTickets.filter_by_purchase_order(purchase_order.id)
      |> Repo.all()
      |> Repo.preload(event_ticket: [:event])

    attachments =
      tickets
      |> Enum.map(fn t ->
        Swoosh.Attachment.new(
          {:data, Rauversion.PurchasedTickets.qr_png(t)},
          # cid: "qrcode-#{t.id}.png",
          filename: "qrcode-#{t.id}.png",
          content_type: "image/png",
          type: :inline
        )
      end)

    deliver(
      user.email,
      options[:subject] || gettext("Event Tickets confirmation"),
      [
        "deliver_event_tickets.html",
        %{
          user: user,
          tickets: tickets,
          purchase_order: purchase_order,
          message: message,
          inviter: inviter,
          attachments: attachments,
          event: options[:event]
        }
      ]
    )
  end

  def deliver_event_streaming_url(user, event) do
    deliver(user.email, "The #{event.title} live streaming", """

    ==============================

    Hi #{user.email},

    This is the event streaming link

    ==============================
    """)
  end

  defp add_attachments(email, attachments) do
    if Enum.any?(attachments) do
      attachments
      |> Enum.reduce(email, fn att, acc ->
        acc |> attachment(att)
      end)
    else
      email
    end
  end
end
