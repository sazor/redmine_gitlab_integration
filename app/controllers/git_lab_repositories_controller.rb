class GitLabRepositoriesController < ApplicationController
  unloadable


  def index
  	@project = Project.find(params[:project_id])
  	@repositories = @project.git_lab_repositories
  end
end
