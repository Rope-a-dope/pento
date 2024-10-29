defmodule PentoWeb.SurveyLiveTest do
  use PentoWeb.ConnCase

  import Phoenix.LiveViewTest

  @demographic_params %{
    "gender" => "male",
    "year_of_birth" => "1990",
    "education" => "bachelor's degree"
  }

  describe "Survey" do
    setup [:register_and_log_in_user]

    test "submitting the demographic form updates the page", %{conn: conn, user: user} do
      # Mount the parent SurveyLive view
      {:ok, view, _html} = live(conn, ~p"/survey")

      # Verify that the demographic form is initially rendered (since no demographic exists)
      assert has_element?(view, "#demographic-form")

      form_id = "#demographic-form"

      # Simulate changes in the form
      assert view
             |> element(form_id)
             |> render_change(%{
               "demographic" => %{"education" => "bachelor's degree"}
             }) =~
               ~s(<option selected=\"selected"\ value="bachelor&#39;s degree">bachelor&#39;s degree</option>)

      # Submit the form
      html =
        view
        |> form(form_id, demographic: @demographic_params)
        |> render_submit()

      # Ensure the demographic details are displayed on the page after submission
      # assert html =~ "Demographic created successfully"
      assert html =~ "male"
      assert html =~ "1990"
      assert html =~ "bachelor&#39;s degree"

      # Confirm that the form is replaced with the demographic details view
      assert has_element?(view, "table")
      refute has_element?(view, "#demographic-form")
    end
  end
end
