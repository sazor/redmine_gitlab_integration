include GitlabInt::GitlabMethods
FactoryGirl.define do
  trait :created_on_and_updated_on_now do
    created_on { Time.now }
    updated_on { Time.now }
  end

  sequence :repo_name do |n|
    "Test#{n}"
  end

  trait :user_defaults do
    status 1 
    language 'en'
    salt "7599f9963ec07b5a3b55b354407120c0"
    hashed_password "8f659c8d7c072f189374edacfa90d6abbc26d8ed"
    lastname "Gitlab"
    firstname "User"
  end

  trait :project_defaults do
    description "This is test project"
    homepage ""
    is_public true
    parent_id nil
  end

  factory :admin, class: User do
    id 100
    created_on_and_updated_on_now
    user_defaults
    admin true
    mail "test_admin@gmail.com"
    login "sazor_test_admin"
    gitlab_token "5si-PJhPN-Ct8Y7MBXQs"
  end

  factory :user_1, class: User do
    id 101
    created_on_and_updated_on_now
    user_defaults
    admin false
    mail "test_user1@gmail.com"
    login "sazor_test_1"
    gitlab_token "oYFoQsnFGpy3tSqVtdzV"
  end

  factory :user_2, class: User do
    id 102
    created_on_and_updated_on_now
    user_defaults
    admin false
    mail "test_user2@gmail.com"
    login "sazor_test_2"
    gitlab_token "dzKetg8Lrjc1vrb935gy"
  end

  factory :repo, class: GitLabRepository do
    project nil
    before(:create) do |repo|
      attrs = { token: User.current.gitlab_token, title: generate(:repo_name), description: "td", visibility: "20" }
      glp = gitlab_create(attrs)
      repo.url = glp.to_h['http_url_to_repo'].gsub('http://localhost', Setting.plugin_redmine_gitlab_integration['gitlab_url'])
      repo.gitlab_id = glp.to_h['id']
      members = repo.project.members.map { |m| { login: m.user.login, role: m.roles.first.id } }
      gitlab_add_members(members: members, repository: repo.gitlab_id, token: attrs[:token])
    end
  end

  factory :project_alpha, class: Project do
    id 100
    name "Project Alpha"
    identifier "alpha"
    created_on_and_updated_on_now
    project_defaults
    after(:create) do |project|
        project.enable_module! "GitLab"
        2.times { create(:repo, project: project) }
    end
  end

  factory :project_beta, class: Project do
    id 101
    name "Project Beta"
    identifier "beta"
    created_on_and_updated_on_now
    project_defaults
    after(:create) do |project|
      project.enable_module! "GitLab"
    end
  end

  factory :project_gamma, class: Project do
    id 102
    name "Project Gamma"
    identifier "gamma"
    created_on_and_updated_on_now
    project_defaults
    after(:create) do |project|
      project.enable_module! "GitLab"
      2.times { create(:repo, project: project) }
      project.git_lab_repositories.last.destroy
    end
  end
end