class CreateGitLabRepositories < ActiveRecord::Migration
  def change
    create_table :git_lab_repositories do |t|
      t.string :url
      t.references :project
    end
    add_index :git_lab_repositories, :project_id
  end
end
