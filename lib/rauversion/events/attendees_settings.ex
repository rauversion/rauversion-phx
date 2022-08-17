defmodule Rauversion.Events.AttendeesSettings do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime

    field :schedule_type, :string
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
end
