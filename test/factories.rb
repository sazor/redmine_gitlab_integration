include GitlabInt::GitlabMethods
FactoryGirl.define do
	factory :admin, class: User do
		id 100
		created_on Time.now
		status 1 
		language 'en'
		salt "7599f9963ec07b5a3b55b354407120c0"
		hashed_password "8f659c8d7c072f189374edacfa90d6abbc26d8ed"
		admin true
		mail "test_admin@gmail.com"
		lastname "Admin"
		firstname "User"
		login "sazor_test_admin"
		gitlab_token "oim9b_ZecCzxnThLtvGg"
	end

	factory :user_1, class: User do
		id 101
		created_on Time.now
		status 1 
		language 'en'
		salt "7599f9963ec07b5a3b55b354407120c0"
		hashed_password "8f659c8d7c072f189374edacfa90d6abbc26d8ed"
		admin false
		mail "test_user1@gmail.com"
		lastname "Admin"
		firstname "User"
		login "sazor_test_1"
		gitlab_token "WzFj8mBgZPCDdn1NzgLc"
	end

	factory :user_2, class: User do
		id 102
		created_on Time.now
		status 1 
		language 'en'
		salt "7599f9963ec07b5a3b55b354407120c0"
		hashed_password "8f659c8d7c072f189374edacfa90d6abbc26d8ed"
		admin false
		mail "test_user2@gmail.com"
		lastname "Admin"
		firstname "User"
		login "sazor_test_2"
		gitlab_token "nxW6g9pptEmy34Hsd_bw"
	end

	factory :repo_1, class: GitLabRepository do
		id 1
		project nil
		before(:create) do |repo|
			attrs = { token: User.current.gitlab_token, title: "Test1", description: "td", visibility: "20" }
		  glp = gitlab_create(attrs)
      repo.url = glp.to_h['http_url_to_repo'].gsub('http://localhost', Setting.plugin_redmine_gitlab_integration['gitlab_url'])
      repo.gitlab_id = glp.to_h['id']
      members = repo.project.members.map { |m| { login: m.user.login, role: m.roles.first.id } }
      gitlab_add_members(members: members, repository: repo.gitlab_id, token: attrs[:token])
		end
	end

	factory :repo_2, class: GitLabRepository do
		id 2
		project nil
		before(:create) do |repo|
			attrs = { token: User.current.gitlab_token, title: "Test2", description: "td", visibility: "20" }
		  glp = gitlab_create(attrs)
      repo.url = glp.to_h['http_url_to_repo'].gsub('http://localhost', Setting.plugin_redmine_gitlab_integration['gitlab_url'])
      repo.gitlab_id = glp.to_h['id']
      members = repo.project.members.map { |m| { login: m.user.login, role: m.roles.first.id } }
      gitlab_add_members(members: members, repository: repo.gitlab_id, token: attrs[:token])
		end
	end

	factory :project_alpha, class: Project do
		created_on Time.now
		name "Project Alpha"
		updated_on Time.now
		id 100
		description "This is test project"
		homepage ""
		is_public true
		identifier "alpha"
		parent_id nil
		after(:create) do |project|
				project.enable_module! "GitLab"
				create(:repo_1, project: project)
				create(:repo_2, project: project)
		end
	end

	factory :project_beta, class: Project do
		created_on Time.now
		name "Project Beta"
		updated_on Time.now
		id 101
		description "This is test project"
		homepage ""
		is_public true
		identifier "beta"
		parent_id nil
		after(:create) do |project|
			project.enable_module! "GitLab"
		end
	end

	factory :project_gamma, class: Project do
		created_on Time.now
		name "Project Gamma"
		updated_on Time.now
		id 102
		description "This is test project"
		homepage ""
		is_public true
		identifier "gamma"
		parent_id nil
		after(:create) do |project|
			project.enable_module! "GitLab"
			create(:repo_1, project: project)
			create(:repo_2, project: project)
			project.git_lab_repositories.last.destroy
		end
	end
end