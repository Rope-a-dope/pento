defmodule PentoWeb.SearchLive do
  use PentoWeb, :live_view

  alias Pento.Catalog
  alias Pento.Catalog.Search

  def mount(_params, _session, socket) do
    changeset = Search.changeset(%Search{}, %{})
    {:ok, socket |> assign_form(changeset) |> assign(search_result: nil, search_attempted: false)}
  end

  defp assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def handle_event("validate", %{"search" => search_params}, socket) do
    changeset =
      %Search{}
      |> Search.changeset(search_params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign_form(changeset)}
  end

  def handle_event("search", %{"search" => search_params}, socket) do
    changeset = Search.changeset(%Search{}, search_params)

    if changeset.valid? do
      sku = search_params["sku"]
      product = Catalog.get_product_by_sku(sku)

      {:noreply,
       socket
       |> assign(search_result: product, search_attempted: true)
       |> assign(form: to_form(changeset))}
    else
      {:noreply, assign(socket, form: to_form(changeset), search_result: nil)}
    end
  end

  def humanize(atom) when is_atom(atom) do
    atom
    |> to_string()
    |> String.replace("_", " ")
    |> String.capitalize()
  end
end
