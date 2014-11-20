require 'gitlab'

module GitlabInt
  module GitlabMethods
    def gitlab_create(attrs)
      gitlab = gitlab_configure
      visibility = attrs[:visibility].to_i * 10
      project = gitlab.create_project(attrs[:title], description: attrs[:description], visibility_level: visibility)
      gitlab.transfer_project_to_group(attrs[:group], project.id)
      gitlab.project(project.id)
    end

    def gitlab_create_group(attrs)
      gitlab_configure.create_group(attrs[:title], attrs[:identifier]).id
    end

    def gitlab_add_to_group(attrs)
      user = gitlab_configure(attrs[:token]).user
      gitlab_configure.add_group_member(attrs[:group], user.id, 50)
    end

    def gitlab_destroy(attrs)
      gitlab = gitlab_configure
      gitlab.delete_project(attrs[:id])
    end

    def gitlab_destroy_all(attrs)
      gitlab = gitlab_configure
      projects = gitlab.projects.map(&:to_h)
      projects.each do |p|
        gitlab.delete_project(p['id'])
      end
    end

    def gitlab_get_members(options = {})
      gitlab = gitlab_configure
      gitlab.team_members(options[:id])
    end

    def gitlab_member(options = {})
      roles = get_roles
      operations =  {
                      add:    ->(id, uid, rid, gitlab) { gitlab.add_team_member(id, uid, rid) },
                      remove: ->(id, uid, _, gitlab) { gitlab.remove_team_member(id, uid) },
                      edit:   ->(id, uid, rid, gitlab) { gitlab.edit_team_member(id, uid, rid) }
                    }
      login, repo_ids, role_id, op = options[:login], options[:repositories], options[:role], options[:op]
      gitlab = gitlab_configure
      # There is no searching by login, so we have to do it manually
      user = find_user(gitlab, login)
      #  Each repository from our list
      repo_ids.each do |id|
        operations[op].call(id, user.id, roles[role_id], gitlab)
      end
    end

    def gitlab_add_members(options = {})
      roles = get_roles
      members, repo_id = options[:members], options[:repository]
      gitlab = gitlab_configure
      members.each do |member|
        user = find_user(gitlab, login)
        gitlab.add_team_member(repo_id, user.id, roles[member[:role]])
      end
    end

    def gitlab_token_valid?(token)
      begin
        gitlab_configure(token).user
      rescue
        false
      end
    end

    def gitlab_configure(token = nil)
      token ||= Setting.plugin_redmine_gitlab_integration['gitlab_bot']
      Gitlab.client(endpoint: get_gitlab_url, private_token: token)
    end

    def gitlab_get_user(login)
      user = User.where(login: login).first
      gitlab = Gitlab.client(endpoint: get_gitlab_url, private_token: user.gitlab_token)
      gitlab.user
    end

    def get_roles
      {
        Role.where(name: I18n.t(:default_role_manager)).first.id   => 40,
        Role.where(name: I18n.t(:default_role_developer)).first.id => 30,
        Role.where(name: I18n.t(:default_role_reporter)).first.id  => 20
      }
    end

    def find_user(gitlab, login)
      if Setting.plugin_redmine_gitlab_integration['gitlab_members_sync'] == 'ldap'
        gitlab.users(per_page: 100, page: 0).select { |u| u.username == login }.first
      else
        gitlab_get_user(login) # by Gitlab token
      end
    end

    private
    def get_gitlab_url
      Setting.plugin_redmine_gitlab_integration['gitlab_url'] + '/api/v3'
    end
  end
end
