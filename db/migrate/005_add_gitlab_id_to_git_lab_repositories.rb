class AddGitlabIdToGitLabRepositories < ActiveRecord::Migration
  def change
    add_column :git_lab_repositories, :gitlab_id, :integer
  end
end
