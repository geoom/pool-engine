defmodule PoolEngine.UserRoom do
  use Ecto.Schema
  import Ecto.Changeset


  schema "user_rooms" do
    belongs_to :user, PoolEngine.Accounts.User
    belongs_to :room, PoolEngine.Messaging.Room

    timestamps()
  end

  @doc false
  def changeset(user_room, attrs \\ %{}) do
    user_room
    |> cast(attrs, [:user_id, :room_id])
    |> validate_required([:user_id, :room_id])
    |> unique_constraint(:user_id_room_id)
  end
end
