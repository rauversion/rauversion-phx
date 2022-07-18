defmodule Rauversion.Accounts.NotificationSettings do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :new_follower_email, :boolean
    field :new_follower_app, :boolean

    field :repost_of_your_post_email, :boolean
    field :repost_of_your_post_app, :boolean

    field :new_post_by_followed_user_email, :boolean
    field :new_post_by_followed_user_app, :boolean

    field :like_and_plays_on_your_post_email, :boolean
    field :like_and_plays_on_your_post_app, :boolean

    field :comment_on_your_post_email, :boolean
    field :comment_on_your_post_app, :boolean

    field :suggested_content_email, :boolean
    field :suggested_content_app, :boolean

    field :new_message_email, :boolean
    field :new_message_app, :boolean
  end

  @required_fields []
  @optional_fields [
    :new_follower_email,
    :new_follower_app,
    :repost_of_your_post_email,
    :repost_of_your_post_app,
    :new_post_by_followed_user_email,
    :new_post_by_followed_user_app,
    :like_and_plays_on_your_post_email,
    :like_and_plays_on_your_post_app,
    :comment_on_your_post_email,
    :comment_on_your_post_app,
    :suggested_content_email,
    :suggested_content_app,
    :new_message_email,
    :new_message_app
  ]

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  # TODO: this is the same as the track metadata, consider unify this
end
