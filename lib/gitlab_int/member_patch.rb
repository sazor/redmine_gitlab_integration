module GitlabInt
	module MemberPatch
		include GitlabMethods
		def self.included(base)
			base.send(:include, InstanceMethods)
			base.class_eval do
				# Patch only if module was enabled
				after_save { member_in_gitlab(:add) if gitlab_module_enabled_and_token_exists? }
				before_destroy { member_in_gitlab(:remove) if gitlab_module_enabled_and_token_exists? }
				after_update { member_in_gitlab(:edit) if gitlab_module_enabled_and_token_exists? }
			end
		end

		module InstanceMethods
			def gitlab_module_enabled_and_token_exists?
				(self.project.module_enabled?("GitLab") && Setting.plugin_gitlab_int['gitlab_members_sync'] == "true" &&
										  User.current.gitlab_token && !User.current.gitlab_token.empty?)
			end

			def member_in_gitlab(op)
				repo_ids = self.project.git_lab_repositories.map(&:gitlab_id).compact
				role = (op == :add) ? self.member_roles.first.role_id : self.member_roles.last.role_id
				gitlab_member(login: self.user.login, repositories: repo_ids, token: User.current.gitlab_token, role: role, op: op)
			end
		end
	end
end