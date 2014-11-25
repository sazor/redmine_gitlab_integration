class AddTimestampsToGitLabRepositories < ActiveRecord::Migration
  def change
    add_column :git_lab_repositories, :created_at, :datetime
  end
end