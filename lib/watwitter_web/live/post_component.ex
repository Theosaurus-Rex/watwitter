defmodule WatwitterWeb.PostComponent do
  use WatwitterWeb, :live_component

  def render(assigns) do
    ~L"""
      <div id="post-<%= @post.id %>"></div>
    """
  end
end
