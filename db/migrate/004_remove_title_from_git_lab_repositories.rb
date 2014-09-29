class RemoveTitleFromGitLabRepositories < ActiveRecord::Migration
  def up
    remove_column :git_lab_repositories, :title
  end
end