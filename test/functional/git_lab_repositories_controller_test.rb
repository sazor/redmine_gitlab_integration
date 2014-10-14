require File.expand_path('../../test_helper', __FILE__)
require 'net/http'

class GitLabRepositoriesControllerTest < ActionController::TestCase
  include FactoryGirl::Syntax::Methods
  fixtures :projects, :users, :roles

  def setup
    @admin = create(:admin)
    @request.session[:user_id] = @admin.id
    User.current = @admin 
    gitlab_destroy_all({ token: User.current.gitlab_token })
  end

  test "view_gitlab_tab_without_repos" do
    project = create(:project_beta)
    get :index, project_id: project.id
    assert_response :success
    assert_select "div.git_holder", 0
    project.destroy
  end

  test "view_gitlab_tab_with_repos" do
    project = create(:project_alpha)
    get :index, project_id: project.id
    assert_response :success
    assert_select "div.git_holder", 2
    project.destroy
  end

  test "add_repository_by_link" do
    project = create(:project_beta)
    get :index, project_id: project.id
    assert_response :success
    assert_select "div.git_holder", 0
    post :create, repository_url: "https://gitlab.com/sazor_test_2/test_project_1.git", project_id: project.id
    get :index, project_id: project.id
    assert_select "div.git_holder", 1
    project.destroy
  end

  test "add_repository_with_creation" do
    project = create(:project_beta)
    get :index, project_id: project.id
    assert_response :success
    assert_select "div.git_holder", 0
    post :create, title: "Test1", description: "td", visibility: "20", project_id: project.id
    uri = URI(assigns[:repository].url.chomp('.git'))
    res = Net::HTTP.get_response(uri)
    assert_equal "200", res.code
    get :index, project_id: project.id
    assert_select "div.git_holder", 1
    project.destroy
  end

  test "destroy_repository_with_autoremove" do
    Setting.plugin_redmine_gitlab_integration['gitlab_autoremove'] = "enabled"
    project = create(:project_alpha)
    repo = project.git_lab_repositories.first
    uri = URI(repo.url.chomp('.git'))
    get :index, project_id: project.id
    assert_select "div.git_holder", 2
    delete :destroy, project_id: project.id, id: repo.id
    get :index, project_id: project.id
    assert_select "div.git_holder", 1
    res = Net::HTTP.get_response(uri)
    assert_equal "302", res.code
    project.destroy
  end

  test "destroy_repository_without_autoremove" do
    Setting.plugin_redmine_gitlab_integration['gitlab_autoremove'] = "disabled"
    project = create(:project_alpha)
    repo = project.git_lab_repositories.first
    uri = URI(repo.url.chomp('.git'))
    get :index, project_id: project.id
    assert_select "div.git_holder", 2
    delete :destroy, project_id: project.id, id: repo.id
    get :index, project_id: project.id
    assert_select "div.git_holder", 1
    res = Net::HTTP.get_response(uri)
    assert_equal "200", res.code
    project.destroy
  end
end
