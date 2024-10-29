defmodule Pento.Accounts.UserNotifier do
  import Swoosh.Email
  require Logger

  alias Pento.Mailer
  alias Pento.TokenFetcher

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"Pento", "ropeadope2021@gmail.com"})
      |> subject(subject)
      |> text_body(body)

    Logger.info("Sending email to #{recipient} with subject: #{subject}")

    with {:ok, _metadata} <-
           Mailer.deliver(email,
             access_token: TokenFetcher.get_access_token()
           ) do
      {:ok, email}
    else
      {:error, reason} ->
        :logger.error("Failed to send email to #{recipient}: #{reason}")
        {:error, reason}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Confirmation instructions", """

    ==============================

    Hi #{user.username},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "Reset password instructions", """

    ==============================

    Hi #{user.username},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Update email instructions", """

    ==============================

    Hi #{user.username},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver promo code to a user email.
  """
  def deliver_promo(recipient_params, promo_code, current_user) do
    deliver(recipient_params["email"], "Promo code for 10% off", """

    ==============================

    Hi #{recipient_params["first_name"]},

    Your friend #{current_user.username} sends you a promo code: #{promo_code} for 10% off your first game purchase!

    ==============================
    """)
  end
end
