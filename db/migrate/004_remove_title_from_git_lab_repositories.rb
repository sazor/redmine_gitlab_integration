class RemoveTitleFromGitLabRepositories < ActiveRecord::Migration
  def change
    remove_column :git_lab_repositories, :title
  end
end
