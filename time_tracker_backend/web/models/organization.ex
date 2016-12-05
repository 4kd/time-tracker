defmodule TimeTrackerBackend.Organization do
  @moduledoc """
  Organizations have many users and projects
  """

  use TimeTrackerBackend.Web, :model

  schema "organizations" do
    field :name, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
