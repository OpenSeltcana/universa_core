defmodule Universa.Core.Repo.Migrations.CreateComponents do
  use Ecto.Migration

  def up do
		create table(:components) do
			add :type,				:string, 	null: false
			add :entity_uuid,	:string,	null: false
      add :value, 			:jsonb, 	null: false, default: "{}"
      add :value_index, :jsonb, 	null: false, default: "{}"
    end

    #TODO: Probably need a different index?
		execute("CREATE INDEX components_value_index ON components USING GIN ((value_index))")
  end
end
