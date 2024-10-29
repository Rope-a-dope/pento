defmodule Pento.Catalog.Product do
  use Ecto.Schema

  import Ecto.Changeset
  alias Pento.Survey.Rating

  schema "products" do
    field :name, :string
    field :description, :string
    field :unit_price, :float
    field :sku, :integer
    field :image_upload, :string

    timestamps(type: :utc_datetime)

    has_many :ratings, Rating
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku, :image_upload])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
    |> validate_number(:unit_price, greater_than: 0.0)
  end

  # Changeset for updating the unit price
  def price_decrease_changeset(product, attrs) do
    product
    |> cast(attrs, [:unit_price])
    |> validate_required([:unit_price])
    |> validate_price_decrease()
  end

  # Custom validation to ensure the price only decreases
  defp validate_price_decrease(changeset) do
    current_price = changeset.data.unit_price

    if changeset.changes[:unit_price] do
      new_price = changeset.changes.unit_price

      if new_price >= current_price do
        add_error(changeset, :unit_price, "Price must be decreased.")
      end
    end

    changeset
  end
end
