defmodule VirgilErpWeb.DashboardLive do
  use VirgilErpWeb, :live_view

  def mount(_params, _, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.dashboard_component />
    </div>
    """
  end
end
