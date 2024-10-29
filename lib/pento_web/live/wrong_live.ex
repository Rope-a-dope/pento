defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       random_number: random_number(),
       score: 0,
       message: "Guess a number",
       time: time(),
       game_over: false
     )}
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %> It's <%= @time %>
    </h2>
    <h2>
      <%= if @game_over do %>
        <.link patch={~p"/guess"}>restart</.link>
      <% else %>
        <%= for n <- 1..10 do %>
          <.link href="#" phx-click="guess" phx-value-number={n}><%= n %></.link>
        <% end %>
        <pre>
          <%= @current_user.username %>
          <%= @session_id %>
        </pre>
      <% end %>
    </h2>
    """
  end

  def time() do
    DateTime.utc_now() |> to_string
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    handle_guess(String.to_integer(guess), socket, time())
  end

  defp handle_guess(guess, socket, current_time) when guess == socket.assigns.random_number do
    message = "Congratulations! You guessed the right number: #{guess}."
    score = socket.assigns.score + 1

    {:noreply,
     assign(
       socket,
       message: message,
       score: score,
       time: current_time,
       game_over: true
     )}
  end

  defp handle_guess(_guess, socket, current_time) do
    message = "Wrong guess. Try again."
    score = socket.assigns.score - 1

    {:noreply,
     assign(
       socket,
       message: message,
       score: score,
       time: current_time
     )}
  end

  def handle_params(_params, _url, socket) do
    {:noreply,
     assign(
       socket,
       random_number: random_number(),
       score: 0,
       message: "Guess a number",
       time: time(),
       game_over: false
     )}
  end

  defp random_number() do
    Enum.random(1..10)
  end
end
