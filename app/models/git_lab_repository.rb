class GitLabRepository < ActiveRecord::Base
  unloadable
  belongs_to :project
  include GitlabInt::GitlabMethods

  def smart_attributes=(attrs)
    if attrs[:repository_url] 
      # Just add repository by url
      self.url = attrs[:repository_url] 
    else
      # Create repository in gitlab and add it in redmine
      attrs[:token] = User.current.gitlab_token # add token in attributes hash
      glp = gitlab_create(attrs) # create repository in gitlab
      self.url = get_url_of glp
      self.gitlab_id = get_id_of glp # repository id in gitlab
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
  	str.gsub('http://localhost', Setting.plugin_gitlab_int['gitlab_url']) # if redmine and gitlab are hosted on same server
  end
end
