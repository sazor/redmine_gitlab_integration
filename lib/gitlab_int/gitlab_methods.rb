require 'gitlab'

module GitlabInt
	module GitlabMethods
		def gitlab_create(attrs)
			gitlab = gitlab_configure(attrs[:token])
			gitlab.create_project(attrs[:title], description: attrs[:description], visibility_level: attrs[:visibility])
		end

		def gitlab_configure(token)
			Gitlab.client(endpoint: (Setting.plugin_gitlab_int['gitlab_url'] + '/api/v3'), private_token: token)
		end

		def gitlab_add_member(options={})
			gitlab = gitlab_configure(attrs[:token])
		end
	end
end
