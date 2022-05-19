defmodule WatwitterWeb.TimelineLive do
  use WatwitterWeb, :live_view

  alias Watwitter.{Accounts, Timeline}
  alias WatwitterWeb.PostComponent

  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    posts = Timeline.list_posts()

    {:ok, assign(socket, posts: posts, current_user: current_user)}
  end
end
