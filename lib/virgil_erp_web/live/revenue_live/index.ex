defmodule VirgilErpWeb.RevenueLive.Index do
  use VirgilErpWeb, :live_view

  alias VirgilErp.Revenues
  alias VirgilErp.Revenues.Revenue

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :revenues, Revenues.list_revenues())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Revenue")
    |> assign(:revenue, Revenues.get_revenue!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Revenue")
    |> assign(:revenue, %Revenue{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Revenues")
    |> assign(:revenue, nil)
  end

  @impl true
  def handle_info({VirgilErpWeb.RevenueLive.FormComponent, {:saved, revenue}}, socket) do
    {:noreply, stream_insert(socket, :revenues, revenue)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    revenue = Revenues.get_revenue!(id)
    {:ok, _} = Revenues.delete_revenue(revenue)

    {:noreply, stream_delete(socket, :revenues, revenue)}
  end
end
