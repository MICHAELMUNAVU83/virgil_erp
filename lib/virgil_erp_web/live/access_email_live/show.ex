defmodule VirgilErpWeb.AccessEmailLive.Show do
  use VirgilErpWeb, :live_view

  alias VirgilErp.AcessEmails

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:access_email, AcessEmails.get_access_email!(id))}
  end

  defp page_title(:show), do: "Show Access email"
  defp page_title(:edit), do: "Edit Access email"
end
