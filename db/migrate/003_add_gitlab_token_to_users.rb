class AddGitlabTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gitlab_token, :string
  end
end
