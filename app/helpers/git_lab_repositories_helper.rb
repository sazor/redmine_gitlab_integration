module GitLabRepositoriesHelper
	def ssh_url(url)
		url.gsub('http://', 'git@')
	end

	def btn_id(type, id)
		"#{type}_btn_#{id}"
	end

	def project_clone_id(id)
		"project_clone_#{id}"
	end
end
