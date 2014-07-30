class GitLabRepositoriesController < ApplicationController
  unloadable
  before_filter :set_project, only: [:index, :destroy, :create]
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

	def create
		@repository = GitLabRepository.new
		@repository.smart_attributes = { url: params[:repository_url], token: User.current.gitlab_token }
		respond_to do |format|
			if @repository.save
				@project.git_lab_repositories << @repository
				format.html { redirect_to git_lab_url(@project.id), notice: 'Repository was successfully connected.' }
			else
				format.html { redirect_to git_lab_url(@project.id), notice: 'Errors while connecting repository!' }
			end
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
