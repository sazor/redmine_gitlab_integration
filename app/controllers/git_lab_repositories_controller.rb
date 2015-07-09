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
    ext_hash = params[:repository_url]  ? { context: :add }
                                        : { project_id: @project.id,
                                            identifier: @project.identifier,
                                            group: @project.gitlab_group,
                                            context: :create,
                                            user_id: User.current.id }
    begin
      @repository = GitLabRepository.new.build(params.merge(ext_hash)) # set attributes and optionally create repository in gitlab
    rescue
    end
    respond_to do |format|
      if @repository.save
        format.html { redirect_to git_lab_url(@project.id), notice: t(:gitlab_create_success) }
      else
        format.html { redirect_to git_lab_url(@project.id), alert: t(:gitlab_create_error) }
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
