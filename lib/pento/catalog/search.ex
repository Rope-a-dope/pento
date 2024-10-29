defmodule Pento.Catalog.Search do
  import Ecto.Changeset

  defstruct [:sku]

  @types %{sku: :string}

  def changeset(%__MODULE__{} = search, attrs) do
    {search, @types}
    |> cast(attrs, [:sku])
    |> validate_required([:sku])
    |> validate_length(:sku, min: 7)
    |> validate_format(:sku, ~r/^\d+$/, message: "must contain only digits")
  end
end
