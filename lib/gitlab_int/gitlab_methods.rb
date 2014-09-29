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

		def gitlab_member(options={})
			login, repo_ids, role_id, op = options[:login], options[:repositories], options[:role], options[:op]
			gitlab = gitlab_configure(options[:token])
			# There is no searching by login, so we have to do it manually
			all_users = gitlab.users
			user = all_users.bsearch { |u| u.to_h['username'] == login }
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

		def gitlab_configure(token)
			Gitlab.client(endpoint: (Setting.plugin_gitlab_int['gitlab_url'] + '/api/v3'), private_token: token)
		end
	end
end
