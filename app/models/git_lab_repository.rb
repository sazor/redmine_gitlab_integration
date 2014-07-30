class GitLabRepository < ActiveRecord::Base
  unloadable
  belongs_to :project
  include GitlabInt::GitlabMethods

  def smart_attributes=(attrs)
  	self.url = attrs[:url] || (get_url gitlab_create(attrs))
  end

  private

  def get_url(obj)
  	replace_localhost(obj.to_h['http_url_to_repo'])
  end
  
  def replace_localhost(str)
  	str.gsub('http://localhost', Setting.plugin_gitlab_int['gitlab_url'])
  end
end
