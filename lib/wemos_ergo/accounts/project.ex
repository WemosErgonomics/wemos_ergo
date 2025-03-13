defmodule WemosErgo.Accounts.Project do
  use Ecto.Schema
  import Ecto.Changeset

  @enum_type_to_int %{circular_29: 0, working_environment: 1}
  @enum_int_to_type Enum.into(@enum_type_to_int, %{}, fn {k, v} -> {v, k} end)

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "projects" do
    field :name, :string
    field :type, :integer
    field :last_opened_at, :utc_datetime

    belongs_to :user, WemosErgo.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :type])
    |> validate_required([:name, :type], message: "this field can't be blank")
    |> validate_length(:name, max: 1000)
    |> validate_format(:name, ~r/^[a-zA-Z0-9À-ỹ ]*$/, message: "project name cannot contains special characters")
    |> validate_inclusion(:type, Map.values(@enum_type_to_int), message: "please select project type")
    |> cast_assoc(:user)
  end
end
