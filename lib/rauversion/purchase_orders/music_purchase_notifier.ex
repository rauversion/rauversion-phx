defmodule Rauversion.PurchaseOrders.MusicPurchaseNotifier do
  import Swoosh.Email
  import RauversionWeb.Gettext

  use Phoenix.Swoosh,
    view: RauversionWeb.MusicPurchaseNotifierView,
    layout: {RauversionWeb.LayoutView, :email}

  # root: "path_to/templates"

  alias Rauversion.{Mailer, Repo}

  def notify_album_purchase(purchase_order, message \\ nil, options \\ []) do
    defaults = [subject: nil, event: nil]
    options = Keyword.merge(defaults, options)

    purchase_order = purchase_order |> Repo.preload([:user])

    user = purchase_order.user
    album = purchase_order.albums |> List.first()

    deliver(
      user.email,
      "Confirmation of Completed Order for #{album.title} Album Record",
      [
        "deliver_album_notification.html",
        %{
          user: user,
          purchase_order: purchase_order,
          album: album,
          message: message
        }
      ]
    )
  end

  def notify_album_purchase_to_author(purchase_order, message \\ nil, options \\ []) do
    defaults = [subject: nil, event: nil]
    _options = Keyword.merge(defaults, options)

    purchase_order = purchase_order |> Repo.preload([:user])

    user = purchase_order.user
    album = purchase_order.albums |> List.first()

    deliver(
      album.user.email,
      "Notification of Purchase for #{album.title} Album Record",
      [
        "deliver_album_purchase_to_artist.html",
        %{
          user: user,
          purchase_order: purchase_order,
          album: album,
          message: message
        }
      ]
    )
  end

  def notify_tracks_purchase(purchase_order, message \\ nil, options \\ []) do
    defaults = [subject: nil, event: nil]
    options = Keyword.merge(defaults, options)

    purchase_order = purchase_order |> Repo.preload([:user])

    user = purchase_order.user
    track = purchase_order.tracks |> List.first()

    deliver(
      user.email,
      options[:subject] || gettext("Your music order"),
      [
        "deliver_track_notification.html",
        %{
          user: user,
          purchase_order: purchase_order,
          message: message,
          track: track
        }
      ]
    )
  end

  def notify_track_purchase_to_author(purchase_order, message \\ nil, options \\ []) do
    defaults = [subject: nil, event: nil]
    _options = Keyword.merge(defaults, options)

    purchase_order = purchase_order |> Repo.preload([:user])

    user = purchase_order.user
    track = purchase_order.tracks |> List.first()

    deliver(
      track.user.email,
      "Notification of Purchase for #{track.title} track",
      [
        "deliver_track_purchase_to_artist.html",
        %{
          user: user,
          purchase_order: purchase_order,
          track: track,
          message: message
        }
      ]
    )
  end

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
end
