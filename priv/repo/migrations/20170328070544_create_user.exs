defmodule BlogTest.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
      create table(:users) do
          add(:user_name, :string)
          add(:email, :string)
          add(:password, :string)
          add(:first_name, :string)
          add(:last_name, :string)
          add(:gender, :string)
          add(:provider, :string)
          add(:token, :string)

          timestamps()
      end
  end
end
