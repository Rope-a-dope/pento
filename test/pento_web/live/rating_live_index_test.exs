defmodule PentoWeb.RatingLive.IndexTest do
  use PentoWeb.ConnCase
  import Phoenix.LiveViewTest

  alias PentoWeb.RatingLive.Index

  @product_without_rating %{
    id: 1,
    name: "Sample Product",
    ratings: []
  }

  @product_with_rating %{
    id: 2,
    name: "Rated Product",
    # Example rating
    ratings: [%{stars: 4, user_id: 1}]
  }

  @user %{id: 1, name: "Test User"}

  describe "Product Rating" do
    setup do
      {:ok, user: @user}
    end

    test "renders product rating form when no product rating exists", %{user: user} do
      assigns = %{
        product: @product_without_rating,
        current_user: user,
        index: 0
      }

      html = render_component(&Index.product_rating/1, assigns)

      # Form ID for the product rating
      assert html =~ "rating-form-1"
      # Product name is displayed
      assert html =~ "Sample Product"
    end

    test "renders rating details when ratings exist", %{user: user} do
      assigns = %{
        product: @product_with_rating,
        current_user: user,
        index: 0
      }

      html = render_component(&Index.product_rating/1, assigns)

      # Product name is displayed
      assert html =~ "Rated Product"
      # Assuming the stars are rendered as text or HTML
      assert html =~ "★ ★ ★ ★ ☆"
      # Additional assertions can be added based on the actual rendering of stars.
    end
  end
end
