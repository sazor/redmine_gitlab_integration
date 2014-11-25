require 'gitlab_int/view_hooks'

Rails.application.config.to_prepare do
  Project.send(:include, GitlabInt::ProjectPatch)
  User.send(:include, GitlabInt::UserPatch)
  Member.send(:include, GitlabInt::MemberPatch)
end

Redmine::Plugin.register :redmine_gitlab_integration do
  name 'Gitlab Integration'
  author 'Andrew Kozlov'
  description 'A plugin for close warm relations between Redmine and Gitlab.'
  version '0.3.0'
  url 'https://github.com/Sazor/redmine_gitlab_integration'
  author_url 'https://github.com/Sazor'
  settings partial: 'settings/gitlab_int_settings', default: {
                                                              gitlab_url:          "https://gitlab.com",
                                                              gitlab_members_sync: "disabled",
                                                              gitlab_autoremove:   "enabled"
                                                             }
  project_module 'GitLab' do
    permission :access_to_gitlab_tab, { git_lab_repositories: :index }
    permission :add_new_repositories, { git_lab_repositories: :create }
  end
  menu :project_menu, :git_lab_repositories, { controller: 'git_lab_repositories', action: 'index' }, caption: 'GitLab', after: :activity, param: :project_id
end

Redmine::Activity.register :git_lab_repositories