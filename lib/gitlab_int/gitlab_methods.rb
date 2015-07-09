require 'gitlab'

module GitlabInt
  module GitlabMethods
    def gitlab_connect(token = nil)
      token ||= Setting.plugin_redmine_gitlab_integration['gitlab_bot']
      Gitlab.client(endpoint: get_gitlab_url, private_token: token)
    end

    def gitlab_create(attrs)
      gitlab = gitlab_connect
      visibility = attrs[:visibility].to_i * 10
      project = gitlab.create_project(attrs[:title], description: attrs[:description], visibility_level: visibility) rescue nil
      if project.present?
        gitlab.transfer_project_to_group(attrs[:group], project.id)
        gitlab.project(project.id)
      end
    end

    def gitlab_create_group(attrs)
      gitlab_connect.create_group(attrs[:title], attrs[:identifier]) rescue nil
    end

    def gitlab_member(attrs)
      operations =  {
                      add:    ->(gid, uid, rid) { gitlab_connect.add_group_member(gid, uid, rid) },
                      remove: ->(gid, uid, _)   { gitlab_connect.remove_group_member(gid, uid) },
                      edit:   ->(gid, uid, rid) {
                                                  gitlab_connect.remove_group_member(gid, uid)
                                                  gitlab_connect.add_group_member(gid, uid, rid)
                                                }
                    }
      role = attrs[:role] ? Setting.plugin_redmine_gitlab_integration['gitlab_role']["#{attrs[:role]}"] : 50
      user = gitlab_connect(attrs[:token]).user
      operations[attrs[:op]].call(attrs[:group], user.id, role) rescue nil
    end

    def gitlab_destroy(attrs)
      gitlab_connect.delete_project(attrs[:id])
    end

    def gitlab_add_members(attrs)
      attrs[:members].each do |m|
        gitlab_member({ group: attrs[:group], op: :add, token: m[:token], role: m[:role] }) rescue nil
      end
    end

    def gitlab_token_valid?(token)
      gitlab_connect(token).user rescue false
    end

    def get_gitlab_url
      Setting.plugin_redmine_gitlab_integration['gitlab_url']
    end

    # For tests
    def gitlab_destroy_all(attrs)
      gitlab_connect.projects.each do |p|
        gitlab.delete_project(p.id)
      end
    end

    def gitlab_get_members(options = {})
      gitlab = gitlab_connect
      gitlab.team_members(options[:id])
    end
  end
end
