Redmine::Plugin.register :gitlab_int do
  name 'Gitlab Integration'
  author 'Andrew Kozlov'
  description 'This plugin create redmine and gitlab project at the same time.'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  settings :default => {'empty' => true}, :partial => 'settings/gitlab_int_settings'
end
