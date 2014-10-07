require 'gitlab'

module GitlabInt
	module GitlabMethods
		# Roles converter
		ROLES = []
		# Master
		ROLES[3] = 40
		# Developer
		ROLES[4] = 30
		# Reporter
		ROLES[5] = 20

		def gitlab_create(attrs)
			gitlab = gitlab_configure(attrs[:token])
			gitlab.create_project(attrs[:title], description: attrs[:description], visibility_level: attrs[:visibility])
		end

		def gitlab_destroy(attrs)
			gitlab = gitlab_configure(attrs[:token])
			gitlab.delete_project(attrs[:id])
		end

		def gitlab_destroy_all(attrs)
			gitlab = gitlab_configure(attrs[:token])
			projects = gitlab.projects.map(&:to_h)
			projects.each do |p|
				gitlab.delete_project(p["id"])
			end
		end

		def gitlab_get_members(options={})
			gitlab = gitlab_configure(options[:token])
			gitlab.team_members(options[:id])
		end

		def gitlab_member(options={})
			login, repo_ids, role_id, op = options[:login], options[:repositories], options[:role], options[:op]
			gitlab = gitlab_configure(options[:token])
			# There is no searching by login, so we have to do it manually
			user =  if Setting.plugin_redmine_gitlab_integration['gitlab_members_sync'] == "ldap"
								gitlab.users(per_page: 100, page: 0).select { |u| u.username == login }.first
							else
								gitlab_get_user(login) # by Gitlab token
							end
			#  Each repository from our list
			repo_ids.each do |id|
				if op == :add
					gitlab.add_team_member(id, user.id, ROLES[role_id])
				elsif op == :remove
					gitlab.remove_team_member(id, user.id)
				else
					gitlab.edit_team_member(id, user.id, ROLES[role_id])
				end
			end
		end

		def gitlab_add_members(options={})
			members, repo_id = options[:members], options[:repository]
			gitlab = gitlab_configure(options[:token])
			# There is no searching by login, so we have to do it manually
			all_users = gitlab.users(per_page: 100, page: 0) if Setting.plugin_redmine_gitlab_integration['gitlab_members_sync'] == "ldap"
			members.each do |member|
				user =  if Setting.plugin_redmine_gitlab_integration['gitlab_members_sync'] == "ldap"
					all_users.select { |u| u.username == login }.first
				else
					gitlab_get_user(login)
				end
				gitlab.add_team_member(repo_id, user.id, ROLES[member[:role]])
			end
		end

		def gitlab_token_valid?(token)
			begin
				gitlab_configure(token).user
			rescue
				false
			end
		end

		def gitlab_configure(token)
			Gitlab.client(endpoint: get_gitlab_url, private_token: token)
		end

		def gitlab_get_user(login)
			user = User.where(login: login).first
			gitlab = Gitlab.client(endpoint: get_gitlab_url, private_token: user.gitlab_token)
			gitlab.user
		end

		private
		def get_gitlab_url
			Setting.plugin_redmine_gitlab_integration['gitlab_url'] + '/api/v3'
		end
	end
end
