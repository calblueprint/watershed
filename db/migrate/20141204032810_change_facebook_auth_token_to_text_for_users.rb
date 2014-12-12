class ChangeFacebookAuthTokenToTextForUsers < ActiveRecord::Migration
  def change
    change_column :users, :facebook_auth_token, :text
  end
end
