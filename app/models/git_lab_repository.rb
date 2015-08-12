class GitLabRepository < ActiveRecord::Base
  unloadable
  extend GitlabInt::GitlabMethods

  belongs_to :project
  belongs_to :user # Author

  validates :url, presence: true

  before_destroy :destroy_repository
  attr_accessible :description, :title, :url, :gitlab_id, :user_id, :project_id

  def build(attrs)
    case attrs[:context]
    when :add
      add_gitlab_repository(attrs)
    when :create
      create_gitlab_repository(attrs)
    end
  end

  private

  def destroy_repository
    self.class.gitlab_destroy({ token: User.current.gitlab_token, id: self.gitlab_id }) if autoremove_enabled?
  end

  def autoremove_enabled?
    self.gitlab_id && Setting.plugin_redmine_gitlab_integration['gitlab_autoremove'] == "enabled"
  end

  def add_gitlab_repository(attrs)
    assign_attributes({
                        title:       attrs[:title],
                        url:         attrs[:repository_url],
                        user_id:     attrs[:user_id],
                        project_id:  attrs[:project_id]
                      })
    self
  end

  def create_gitlab_repository(attrs)
    create_gitlab_group(attrs) unless attrs[:group] # project new or has no repositories
    glp = self.class.gitlab_create(attrs) # create repository in gitlab
    if glp.present? # So if we didn't create repository properly then url field would be nil and .save return false because of validation
      assign_attributes({
                          description: attrs[:description],
                          title:       attrs[:title],
                          url:         glp.http_url_to_repo,
                          gitlab_id:   glp.id,
                          user_id:     attrs[:user_id],
                          project_id:  attrs[:project_id]
                        })
    end
    self
  end

  def create_gitlab_group(attrs)
    attrs[:group], attrs[:op] = self.class.gitlab_create_group(attrs).id, :add
    self.class.gitlab_member(attrs) # add project owner to group
    set_gitlab_group(attrs)
  end

  def set_gitlab_group(attrs)
    project = Project.find(attrs[:project_id])
    project.update_attributes({ gitlab_group: attrs[:group] })
    members = project.members.map { |m| { token: m.user.gitlab_token, role: m.roles.first.id } }
    self.class.gitlab_add_members({ group: attrs[:group], members: members })
  end
end
