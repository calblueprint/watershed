class AddAuthenticationTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token_authenticatable, :string
    add_index :users, :token_authenticatable, unique: true
  end
end
