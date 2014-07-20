Redmine::Plugin.register :gitlab_int do
  name 'Gitlab Integration'
  author 'Andrew Kozlov'
  description 'A plugin for close warm relations between Redmine and Gitlab.'
  version '0.0.1'
  url 'https://github.com/Sazor/redmine_gitlab_integration'
  author_url 'https://github.com/Sazor'
  settings :default => {'empty' => true}, :partial => 'settings/gitlab_int_settings'
  permission :git_lab_repositories, { :git_lab_repositories => :index }, :public => true
  menu :project_menu, :git_lab_repositories, { :controller => 'git_lab_repositories', :action => 'index' }, :caption => 'GitLabRepository', :after => :activity, :param => :project_id
end
