defmodule Pento.ContentFixtures do
  import Pento.AccountsFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Content` context.
  """

  @doc """
  Generate a faq.
  """
  def faq_fixture(attrs \\ %{}) do
    {:ok, faq} =
      attrs
      |> Enum.into(%{
        user_id: user_fixture().id,
        answer: "some answer",
        question: "some question"
      })
      |> Pento.Content.create_faq()

    faq
  end
end
