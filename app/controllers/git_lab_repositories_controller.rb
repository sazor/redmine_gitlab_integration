class GitLabRepositoriesController < ApplicationController
  unloadable
  before_filter :set_project, only: [:index, :destroy]
  before_filter :set_repository, only: [:destroy]

  def index
  	@repositories = @project.git_lab_repositories
  end

  def destroy
		@repository.destroy
		respond_to do |format|
			format.html { redirect_to git_lab_path(params[:project_id]) }
			format.json { head :no_content }
		end
	end

	private
	def set_project
		@project = Project.find(params[:project_id])
	end

	def set_repository
		@repository = GitLabRepository.find(params[:id])
	end
end
