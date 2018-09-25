class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table(:accounts, :id => :uuid) do |table|
      table.citext(:role_state, :null => false, :default => "user")
      table.timestamps(:null => false)

      table.index(:role_state)
    end
  end
end
