defmodule WatwitterWeb.TimelineLiveTest do
  # Provides a connection struct for tests
  use WatwitterWeb.ConnCase
  import Phoenix.LiveViewTest

  setup :register_and_log_in_user

  test "user can visit home page", %{conn: conn} do
    # Returns the connected HTML
    # For most tests, we interact with the view
    {:ok, view, html} = live(conn, "/")

    assert render(view) =~ "Home"
  end
end
