# migrate.rb

require 'sequel'
DB = Sequel.sqlite('inventory.db')  # SQLite database

unless DB.table_exists?(:parts)
DB.create_table :parts do
    primary_key :id
    String :name, null: false
    String :description
    Integer :quantity, default: 0
    Float :price, default: 0.0
    DateTime :created_at
    DateTime :updated_at
  end
end

unless DB.table_exists?(:users)
  DB.create_table :users do
    primary_key :id
    String :username
    String :user_password
    String :role
    DateTime :created_at
    DateTime :updated_at
  end
end

