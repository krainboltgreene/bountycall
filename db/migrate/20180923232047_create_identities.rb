class CreateIdentities < ActiveRecord::Migration[5.2]
  def change
    create_table :identities, :id => :uuid do |table|
      table.uuid :account_id, :null => false, :foreign_key => :accounts
      table.citext :subtype, :null => false
      table.text :external_id, :null => false
      table.jsonb :raw, :null => false
      table.timestamps :null => false

      table.index [:account_id, :subtype, :external_id], :unique => true
      table.index [:subtype, :external_id]
    end
  end
end
