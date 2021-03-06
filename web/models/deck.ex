defmodule SprintPoker.Deck do
  @moduledoc """
  Deck database schema
  """
  use SprintPoker.Web, :model

  schema "decks" do
    field :name, :string
    field :cards, {:array, :string}

    timestamps()
  end

  @required_fields ~w(name cards)a
  @optional_fields ~w()a

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> update_change(:name, &(String.slice(&1, 0..254)))
  end
end
