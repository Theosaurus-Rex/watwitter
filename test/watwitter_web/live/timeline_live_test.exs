defmodule WatwitterWeb.TimelineLiveTest do
  use WatwitterWeb.ConnCase

  import Phoenix.LiveViewTest
  import Watwitter.Factory

  alias Watwitter.Timeline

  setup :register_and_log_in_user

  test "user can visit home page", %{conn: conn} do
    {:ok, view, html} = live(conn, "/")

    assert html =~ "Home"
    assert render(view) =~ "Home"
  end

  test "current user can see own avatar", %{conn: conn, user: user} do
    {:ok, view, _html} = live(conn, "/")

    avatar = element(view, "img[src*=#{user.avatar_url}]")

    assert has_element?(avatar)
  end

  test "renders a list of posts", %{conn: conn} do
    [post1, post2] = insert_pair(:post)
    {:ok, view, _html} = live(conn, "/")

    assert has_element?(view, "#post-#{post1.id}")
    assert has_element?(view, "#post-#{post2.id}")
  end

  test "user can highlight post by clicking on it", %{conn: conn} do
    post = insert(:post)
    {:ok, view, _html} = live(conn, "/")

    view
    |> element("#post-#{post.id} [data-role=show-post]", post.body)
    |> render_click()

    assert has_element?(view, "#show-post-#{post.id}")
  end

  test "user can navigate to user settings", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    {:ok, conn} =
      view
      |> element("#user-avatar")
      |> render_click()
      |> follow_redirect(conn, Routes.user_settings_path(conn, :edit))

    assert html_response(conn, 200) =~ "Settings"
  end

  test "user can compose new post from timeline", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    {:ok, _view, html} =
      view
      |> element("#compose-button")
      |> render_click()
      |> follow_redirect(conn, Routes.compose_path(conn, :new))

    assert html =~ "Compose Watweet"
  end

  test "user recieves notification of new posts in timeline (direct)", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    send(view.pid, {:post_created, insert(:post)})
    send(view.pid, {:post_created, insert(:post)})

    assert has_element?(view, "#new-posts-notice", "Show 2 posts")
  end

  test "user recieves notification of new posts in timeline (pubsub)", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    [post1, post2] = insert_pair(:post)
    Phoenix.PubSub.broadcast(Watwitter.PubSub, "timeline", {:post_created, post1})
    Phoenix.PubSub.broadcast(Watwitter.PubSub, "timeline", {:post_created, post2})

    assert has_element?(view, "#new-posts-notice", "Show 2 posts")
  end

  test "user recieves notification of new posts in timeline (Timeline.create_post)", %{conn: conn} do
    user = insert(:user)
    {:ok, view, _html} = live(conn, "/")
    [post1, post2] = insert_pair(:post)

    Timeline.create_post(params_for(:post, user: user))
    Timeline.create_post(params_for(:post, user: user))

    assert has_element?(view, "#new-posts-notice", "Show 2 posts")
  end

  test "user recieves notification of new posts in timeline", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    [post1, post2] = insert_pair(:post)
    Timeline.broadcast_post_created(post1)
    Timeline.broadcast_post_created(post2)
    assert has_element?(view, "#new-posts-notice", "Show 2 posts")
  end
end
