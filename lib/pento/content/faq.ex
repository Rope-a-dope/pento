defmodule Pento.Content.FAQ do
  use Ecto.Schema

  import Ecto.Changeset

  schema "faqs" do
    field :question, :string
    field :answer, :string
    field :vote_count, :integer, default: 0
    belongs_to :user, Pento.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(faq, attrs) do
    faq
    |> cast(attrs, [:question, :answer, :user_id])
    |> validate_required([:question, :answer, :user_id])
  end

  def upvote_changeset(faq, attrs) do
    faq
    |> cast(attrs, [:vote_count])
    |> validate_required([:vote_count])
  end
end
