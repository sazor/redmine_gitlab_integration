module GitLabRepositoriesHelper
  def ssh_url(url)
    url.gsub(/https?\:\/\//, "git@")
  end

  def btn_id(type, id)
    "#{type}_btn_#{id}"
  end

  def project_clone_id(id)
    "project_clone_#{id}"
  end

  def user_has_token?
    User.current.gitlab_token && !User.current.gitlab_token.empty?
  end

  def user_allowed_to_add?
    User.current.allowed_to?(:add_new_repositories, @project)
  end

  def show_description(repo)
    if !repo.description || repo.description.empty?
      "No description."
    else
      "#{repo.description}..."
    end
  end
end
