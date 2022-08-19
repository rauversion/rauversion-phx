defmodule Rauversion.Cldr do
  use Cldr,
    locales: ~w(en es pt),
    providers: [Cldr.Number, Cldr.Calendar, Cldr.DateTime]
end
