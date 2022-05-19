defmodule WatwitterWeb.PostComponentTest do
  use WatwitterWeb.ConnCase
  import Phoenix.LiveViewTest
  import Watwitter.Factory
  alias WatwitterWeb.PostComponent
  alias WatwitterWeb.DateHelpers

  test "renders post body and date" do
    post = insert(:post)

    html = render_component(PostComponent, post: post)

    assert html =~ post.body
    assert html =~ DateHelpers.format_short(post.inserted_at)
  end

  test "renders the author's name, username and avatar url" do
    author = insert(:user)
    post = insert(:post, user: author)

    html = render_component(PostComponent, post: post)

    assert html =~ author.name
    assert html =~ "@#{author.username}"
    assert html =~ author.avatar_url
  end
end
