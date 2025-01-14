defmodule Pento.Repo.Migrations.AddUsernameToUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :username, :string, size: 20, null: false
    end

    create unique_index(:users, [:username])
  end
end
