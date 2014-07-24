module GitlabInt
  module GitlabInt
    class Hooks  < Redmine::Hook::ViewListener
      render_on(:view_projects_form, partial: 'git_lab_repositories/gitlab')
      render_on(:view_layouts_base_html_head, partial: 'git_lab_repositories/scripts')
      render_on(:view_users_form, partial: 'git_lab_repositories/token_form')
    end
  end
end
