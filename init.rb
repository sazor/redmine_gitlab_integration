Rails.application.config.to_prepare do
  Project.send(:include, GitlabInt::ProjectPatch)
end

Redmine::Plugin.register :gitlab_int do
  name 'Gitlab Integration'
  author 'Andrew Kozlov'
  description 'A plugin for close warm relations between Redmine and Gitlab.'
  version '0.0.1'
  url 'https://github.com/Sazor/redmine_gitlab_integration'
  author_url 'https://github.com/Sazor'
  settings :default => {'empty' => true}, :partial => 'settings/gitlab_int_settings'
  menu :project_menu, :git_lab_repositories, { :controller => 'git_lab_repositories', :action => 'index' }, :caption => 'GitLab', :after => :activity, :param => :project_id
  project_module 'GitLab' do
    permission :git_lab_repositories, :git_lab_repositories => :index
  end
end
