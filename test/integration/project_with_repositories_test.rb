require File.expand_path('../../test_helper', __FILE__)
 
class ProjectWithRepositoriesTest < ActionDispatch::IntegrationTest
  fixtures :projects, :roles, :users
  include FactoryGirl::Syntax::Methods

  test "gitlab_form_was_added?" do
    create(:admin)
    log_user("sazor_test_admin", "foo")
  	get 'projects/new'
  	assert :success
  	assert_select "#project_gitlab_create", true
  	assert_select "#gitlab_auth_form", false
  	assert_select "#gitlab_fieldset", true
	end

  test "gitlab_auth_was_added?" do
    create(:admin, gitlab_token: '')
    log_user("sazor_test_admin", "foo")
    get 'projects/new'
    assert :success
    assert_select "#project_gitlab_create", true
    assert_select "#gitlab_auth_form", true
    assert_select "#gitlab_fieldset", true
  end

  test "gitlab_repository_was_created?" do 
    create(:admin)
    log_user("sazor_test_admin", "foo")
    post 'projects', project: { name: "Test1", description: "test_desc", identifier: "test_project", homepage: "", 
                               is_public: "1", parent_id: "", inherit_members: "0", gitlab_create: "true", gitlab_name: "sazor_test_project", 
                               gitlab_description: "test_description", visibility: "20", gitlab_token: User.current.gitlab_token, 
                               enabled_module_names: ["issue_tracking", "time_tracking", "news", "documents", "files", "wiki", "repository", "boards", "calendar", "gantt", "GitLab"], 
                               tracker_ids: [] }
    assert :success
    assert_redirected_to '/projects/test_project/settings'
    #get "https://gitlab.com/sazor_test_admin/sazor_test_project"
    destroy_project
  end

	private

  # Against duplication
  def destroy_project
    Project.last.destroy
  end

	def log_user(login, password)
    get "/login"
    assert_equal nil, session[:user_id]
    assert_response :success
    assert_template "account/login"
    post "/login", :username => login, :password => password
    assert_equal login, User.find(session[:user_id]).login
  end
end