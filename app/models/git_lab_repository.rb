class GitLabRepository < ActiveRecord::Base
  unloadable
  belongs_to :project

  def smart_attributes=(attrs)
  	self.title = attrs[:title]
  end
end
