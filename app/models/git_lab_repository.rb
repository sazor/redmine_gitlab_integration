class GitLabRepository < ActiveRecord::Base
  unloadable
  belongs_to :project
  include GitlabInt::GitlabMethods

  def smart_attributes=(attrs)
    if attrs[:url] 
      self.url = attrs[:url] 
    else
      glp = gitlab_create(attrs)
      self.url = get_url_of glp
      self.gitlab_id = get_id_of glp
    end
  end

  private

  def get_url_of(obj)
  	replace_localhost(obj.to_h['http_url_to_repo'])
  end

  def get_id_of(obj)
    obj.to_h['id']
  end
  
  def replace_localhost(str)
  	str.gsub('http://localhost', Setting.plugin_gitlab_int['gitlab_url'])
  end
end
