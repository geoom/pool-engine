defmodule PoolEngine.Messaging.Room do
  use Ecto.Schema
  import Ecto.Changeset


  schema "rooms" do
    field :name, :string
    field :topic, :string
    many_to_many :users, PoolEngine.Accounts.User, join_through: "user_rooms"

    timestamps()
  end

  @doc false
  def changeset(room, attrs \\ %{}) do
    room
    |> cast(attrs, [:name, :topic])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
