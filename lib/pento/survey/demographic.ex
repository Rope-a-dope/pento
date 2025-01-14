defmodule Pento.Survey.Demographic do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pento.Accounts.User

  schema "demographics" do
    field :gender, :string
    field :year_of_birth, :integer
    field :education, :string
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(demographic, attrs) do
    demographic
    |> cast(attrs, [:gender, :year_of_birth, :education, :user_id])
    |> validate_required([:gender, :year_of_birth, :education, :user_id])
    |> validate_inclusion(:education, [
      "high school",
      "bachelor's degree",
      "master's degree",
      "other",
      "prefer not to say"
    ])
    |> validate_inclusion(:year_of_birth, 1900..2024)
    |> unique_constraint(:user_id)
  end
end
