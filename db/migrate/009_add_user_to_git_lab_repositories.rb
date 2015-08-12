class AddUserToGitLabRepositories < ActiveRecord::Migration
  def change
    add_column :git_lab_repositories, :user_id, :integer
  end
end