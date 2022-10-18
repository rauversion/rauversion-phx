defmodule RauversionWeb.ErrorView do
  use RauversionWeb, :view

  # In order to test error views on development, we need to set debug_errors: false in config/dev.exs.

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #  " a suuuper Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
