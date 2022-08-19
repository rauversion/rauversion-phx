defmodule Rauversion.Cldr do
  use Cldr,
    locales: ~w(en es pt),
    providers: [Cldr.Number, Cldr.Calendar, Cldr.DateTime],
    data_dir: "./priv/cldr",
    otp_app: :rauversion
end
