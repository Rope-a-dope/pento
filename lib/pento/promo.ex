defmodule Pento.Promo do
  alias Pento.Promo.Recipient
  alias Pento.Accounts.UserNotifier

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def send_promo(recipient_params, current_user) do
    UserNotifier.deliver_promo(recipient_params, generate_code(), current_user)
  end

  defp generate_code do
    :crypto.strong_rand_bytes(4) |> Base.url_encode64()
  end
end
