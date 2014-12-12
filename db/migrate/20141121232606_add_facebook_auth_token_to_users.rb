class AddFacebookAuthTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_auth_token, :string
  end
end
