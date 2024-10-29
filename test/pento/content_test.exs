defmodule Pento.ContentTest do
  use Pento.DataCase

  alias Pento.Content

  describe "faqs" do
    alias Pento.Content.FAQ

    import Pento.ContentFixtures

    @invalid_attrs %{question: nil, answer: nil}

    test "list_faqs/0 returns all faqs" do
      faq = faq_fixture()
      assert Content.list_faqs() == [faq]
    end

    test "get_faq!/1 returns the faq with given id" do
      faq = faq_fixture()
      assert Content.get_faq!(faq.id) == faq
    end

    test "create_faq/1 with valid data creates a faq" do
      assert %FAQ{} = faq = faq_fixture()
      assert faq.question == "some question"
      assert faq.answer == "some answer"
      assert faq.vote_count == 0
    end

    test "create_faq/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_faq(@invalid_attrs)
    end

    test "update_faq/2 with valid data updates the faq" do
      faq = faq_fixture()
      update_attrs = %{question: "some updated question", answer: "some updated answer"}

      assert {:ok, %FAQ{} = faq} = Content.update_faq(faq, update_attrs)
      assert faq.question == "some updated question"
      assert faq.answer == "some updated answer"
      assert faq.vote_count == 0
    end

    test "update_faq/2 with invalid data returns error changeset" do
      faq = faq_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_faq(faq, @invalid_attrs)
      assert faq == Content.get_faq!(faq.id)
    end

    test "delete_faq/1 deletes the faq" do
      faq = faq_fixture()
      assert {:ok, %FAQ{}} = Content.delete_faq(faq)
      assert_raise Ecto.NoResultsError, fn -> Content.get_faq!(faq.id) end
    end

    test "change_faq/1 returns a faq changeset" do
      faq = faq_fixture()
      assert %Ecto.Changeset{} = Content.change_faq(faq)
    end
  end
end
