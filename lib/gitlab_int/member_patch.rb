module GitlabInt
	module MemberPatch
		def self.included(base)
			base.send(:include, InstanceMethods)
			base.class_eval do
				# Modify only if module was enabled, gitlab_token exists and option`s selected
				after_save { member_in_gitlab(:add) if gitlab_module_enabled_and_token_exists? }
				before_destroy { member_in_gitlab(:remove) if gitlab_module_enabled_and_token_exists? }
				after_update { member_in_gitlab(:edit) if gitlab_module_enabled_and_token_exists? }
			end
		end

		module InstanceMethods
			include GitlabMethods
			def gitlab_module_enabled_and_token_exists?
				(project.module_enabled?("GitLab") && Setting.plugin_redmine_gitlab_integration['gitlab_members_sync'] != "disabled" &&
										  User.current.gitlab_token && !User.current.gitlab_token.empty?)
			end

			def member_in_gitlab(op)
				repo_ids = project.git_lab_repositories.map(&:gitlab_id).compact
				role = case op
					     when :add  then member_roles.first.role_id
					     when :edit then member_roles.last.role_id
					     else nil
					     end
				gitlab_member(login: user.login, repositories: repo_ids, token: User.current.gitlab_token, role: role, op: op)
			end
		end
	end
end