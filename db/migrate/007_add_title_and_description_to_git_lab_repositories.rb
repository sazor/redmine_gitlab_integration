class AddTitleAndDescriptionToGitLabRepositories < ActiveRecord::Migration
  def change
    add_column :git_lab_repositories, :title, :string
    add_column :git_lab_repositories, :description, :string
  end
end