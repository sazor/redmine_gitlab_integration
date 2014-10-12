require File.expand_path('../../test_helper', __FILE__)
require 'net/http'

class ProjectWithRepositoriesTest < ActionDispatch::IntegrationTest
	include FactoryGirl::Syntax::Methods
	fixtures :projects, :users, :roles

	def setup
		create(:admin)
		log_user("sazor_test_admin", "foo")
		uri = URI('https://gitlab.com/sazor_test_admin/test1')
		res = Net::HTTP.get_response(uri) 
		if res.code == "200"
			gitlab_destroy_all({ token: User.current.gitlab_token })
		end
	end

	test "gitlab_form_was_added?" do
		get 'projects/new'
		assert_response :success
		assert_select "#project_gitlab_create", true
		assert_select "#gitlab_auth_form", false
		assert_select "#gitlab_fieldset", true
	end

	test "gitlab_auth_was_added?" do
		User.find(100).destroy
		create(:admin, gitlab_token: "")
		get 'projects/new'
		assert :success
		assert_select "#project_gitlab_create", true
		assert_select "#gitlab_auth_form", true
		assert_select "#gitlab_fieldset", true
	end

	test "gitlab_repository_was_created?" do 
		post 'projects', project: { name: "Test1", description: "test_desc", identifier: "test_project", homepage: "", 
															 is_public: "1", parent_id: "", inherit_members: "0", gitlab_create: "true", gitlab_name: "Test1", 
															 gitlab_description: "test_description", visibility: "20", gitlab_token: User.current.gitlab_token, 
															 enabled_module_names: ["issue_tracking", "time_tracking", "news", "documents", "files", "wiki", "repository", "boards", "calendar", "gantt", "GitLab"], 
															 tracker_ids: [] }
		assert_redirected_to '/projects/test_project/settings'
		uri = URI('https://gitlab.com/sazor_test_admin/test1')
		res = Net::HTTP.get_response(uri)
		assert_equal "200", res.code
		assigns(:project).destroy
	end

	test "gitlab_repository_fields_with_error" do 
		post 'projects', project: { name: "Test1", description: "test_desc", identifier: "test_project", homepage: "", 
															 is_public: "1", parent_id: "", inherit_members: "0", gitlab_create: "true", gitlab_name: "test~project", 
															 gitlab_description: "test_description", visibility: "20", gitlab_token: User.current.gitlab_token, 
															 enabled_module_names: ["issue_tracking", "time_tracking", "news", "documents", "files", "wiki", "repository", "boards", "calendar", "gantt", "GitLab"], 
															 tracker_ids: [] }
		project = assigns(:project)
		assert !project.errors.empty?
		uri = URI('https://gitlab.com/sazor_test_admin/test~project')
		res = Net::HTTP.get_response(uri)
		assert_equal "404", res.code
	end

	test "project_without_gitlab" do 
		post 'projects', project: { name: "Test1", description: "test_desc", identifier: "test_project", homepage: "", 
															 is_public: "1", parent_id: "", inherit_members: "0", gitlab_create: "false",
															 enabled_module_names: ["issue_tracking", "time_tracking", "news", "documents", "files", "wiki", "repository", "boards", "calendar", "gantt", "GitLab"], 
															 tracker_ids: [] }
		assert_redirected_to '/projects/test_project/settings'
		assigns(:project).destroy
	end

	test "create_from_factory" do
		project = create(:project_alpha)
		assert_equal 2, project.git_lab_repositories.to_a.length 
		assert project.enabled_module_names.include?("GitLab"), "GitLab Module was not enabled"
		project.destroy
	end

	test "add_member_to_project" do
		Setting.plugin_redmine_gitlab_integration['gitlab_members_sync'] = "token"
		user_1 = create(:user_1)
		user_2 = create(:user_2)
		project = create(:project_alpha)
		get "/projects/#{project.identifier}/settings/members"
		post "/projects/#{project.identifier}/memberships", project_id: 100, membership: { user_ids: [user_1.id, user_2.id], role_ids: [1] }
		assert_redirected_to "/projects/#{project.identifier}/settings/members"
		assert User.find(101).member_of?(Project.find(100))
		assert User.find(102).member_of?(Project.find(100))
		assert_equal 2, project.memberships.length
		members = gitlab_get_members(token: User.current.gitlab_token, id: project.git_lab_repositories.first.gitlab_id)
		assert_equal 3, members.length # owner with 2 new members
		project.destroy
	end

	test "update_member_in_project" do
		Setting.plugin_redmine_gitlab_integration['gitlab_members_sync'] = "token"
		user_1 = create(:user_1)
		user_2 = create(:user_2)
		project = create(:project_alpha)
		get "/projects/#{project.identifier}/settings/members"
		post "/projects/#{project.identifier}/memberships", project_id: 100, membership: { user_ids: [user_1.id, user_2.id], role_ids: [1] }
		member_1 = gitlab_get_members(token: User.current.gitlab_token, id: project.git_lab_repositories.first.gitlab_id)[1]
		member = project.memberships.first
		assert_equal 40, member_1.access_level
		put "/memberships/#{member.id}", id: member.id, membership: { role_ids: [2], user_id: user_1.id }
		assert_equal 2, project.memberships.length
		member_1 = gitlab_get_members(token: User.current.gitlab_token, id: project.git_lab_repositories.first.gitlab_id)[0]
		assert_equal 30, member_1.access_level
		project.destroy
	end

	test "remove_member_from_project" do
		Setting.plugin_redmine_gitlab_integration['gitlab_members_sync'] = "token"
		user_1 = create(:user_1)
		user_2 = create(:user_2)
		project = create(:project_alpha)
		get "/projects/#{project.identifier}/settings/members"
		post "/projects/#{project.identifier}/memberships", project_id: 100, membership: { user_ids: [user_1.id, user_2.id], role_ids: [1] }
	  member = project.memberships.first
	  delete "/memberships/#{member.id}", id: member.id
		assert_equal 1, project.memberships.length
		members = gitlab_get_members(token: User.current.gitlab_token, id: project.git_lab_repositories.first.gitlab_id)
		assert_equal 2, members.length
		project.destroy
	end

	test "add_member_to_project_without_gitlab" do
		Setting.plugin_redmine_gitlab_integration['gitlab_members_sync'] = "disabled"
		user_1 = create(:user_1)
		user_2 = create(:user_2)
		project = create(:project_alpha)
		get "/projects/#{project.identifier}/settings/members"
		post "/projects/#{project.identifier}/memberships", project_id: 100, membership: { user_ids: [user_1.id, user_2.id], role_ids: [1] }
		assert_redirected_to "/projects/#{project.identifier}/settings/members"
		assert User.find(101).member_of?(Project.find(100))
		assert User.find(102).member_of?(Project.find(100))
		assert_equal 2, project.memberships.length
		project.destroy
	end

	test "set_invalid_token" do
		user = User.current
		get 'my/account'
		assert_response :success
		assert_select '#errorExplanation', false
		post 'my/account', user: { firstname: user.firstname, lastname: user.lastname, mail: user.mail, 
															 language: user.language, gitlab_token: "iS5qULJySt4UkrM9xnTR", mail_notification: "all", 
															 notified_project_ids: [""] }
		assert_select '#errorExplanation', true
	end

	test "set_valid_token" do
		user = User.current
		get 'my/account'
		assert_response :success
		assert_select '#errorExplanation', false
		post 'my/account', user: { firstname: user.firstname, lastname: user.lastname, mail: user.mail, 
															 language: user.language, gitlab_token: "WzFj8mBgZPCDdn1NzgLc", mail_notification: "all", 
															 notified_project_ids: [""] }
		assert_select '#errorExplanation', false
	end

	test "view_gitlab_tab" do
		project = create(:project_alpha)
		get "projects/#{project.identifier}"
		assert_select "a.git-lab-repositories", true
		get "projects/#{project.identifier}/gitlab"
		assert_response :success
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