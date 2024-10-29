defmodule PentoWeb.PromoLive do
  use PentoWeb, :live_view

  alias Pento.Promo
  alias Pento.Promo.Recipient

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_recipient()
     |> clear_form()}
  end

  def assign_recipient(socket) do
    socket
    |> assign(:recipient, %Recipient{})
  end

  def clear_form(socket) do
    form =
      socket.assigns.recipient
      |> Promo.change_recipient()
      |> to_form()

    assign(socket, :form, form)
  end

  def assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def handle_event(
        "validate",
        %{"recipient" => recipient_params},
        %{assigns: %{recipient: recipient}} = socket
      ) do
    changeset =
      recipient
      |> Promo.change_recipient(recipient_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event(
        "save",
        %{"recipient" => recipient_params},
        %{assigns: %{current_user: current_user}} = socket
      ) do
    case Promo.send_promo(recipient_params, current_user) do
      {:ok, _recipient} ->
        {:noreply,
         socket
         |> put_flash(:info, "Sent promo!")
         |> clear_form()}

      {:error, %Ecto.Changeset{} = changeset} ->
        {
          :noreply,
          socket
          |> put_flash(:error, "Failed to send promo")
          |> assign_form(changeset)
        }
    end
  end
end
