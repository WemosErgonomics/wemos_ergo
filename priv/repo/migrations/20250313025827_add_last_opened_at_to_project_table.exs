defmodule WemosErgo.Repo.Migrations.AddLastOpenedAtToProjectTable do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :last_opened_at, :utc_datetime, null: true
    end

    create index(:projects, [:last_opened_at])
  end
end
