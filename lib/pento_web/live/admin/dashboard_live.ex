defmodule PentoWeb.Admin.DashboardLive do
  use PentoWeb, :live_view

  alias PentoWeb.Admin.{SurveyResultsLive, UserActivityLive, UserSurveyLive}
  alias PentoWeb.Endpoint
  @survey_results_topic "survey_results"
  @user_activity_topic "user_activity"
  @user_survey_topic "user_survey"

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(@survey_results_topic)
      Endpoint.subscribe(@user_activity_topic)
      Endpoint.subscribe(@user_survey_topic)
    end

    {:ok,
     socket
     |> assign(:survey_results_component_id, "survey-results")
     |> assign(:user_activity_component_id, "user-activity")
     |> assign(:user_survey_component_id, "user-survey")}
  end

  def handle_info(%{event: "rating_created"}, socket) do
    send_update(
      SurveyResultsLive,
      id: socket.assigns.survey_results_component_id
    )

    {:noreply, socket}
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    if socket.assigns[:user_activity_component_id] do
      send_update(UserActivityLive, id: socket.assigns.user_activity_component_id)
    end

    if socket.assigns[:user_survey_component_id] do
      send_update(UserSurveyLive, id: socket.assigns.user_survey_component_id)
    end

    {:noreply, socket}
  end
end
