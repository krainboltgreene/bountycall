class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts, :id => :uuid do |table|
      table.uuid :account_id, :null => false, :index => true, :foreign_key => true
      table.text :subtype, :null => false, :index => true
      table.text :value, :null => false
      table.citext :confirmation_state, :null => false, :index => true, :default => "unconfirmed"
      table.timestamps :null => false
    end
  end
end
