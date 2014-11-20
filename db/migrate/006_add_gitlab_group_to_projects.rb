class AddGitlabGroupToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :gitlab_group, :integer
  end
end