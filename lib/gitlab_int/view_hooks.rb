module RedmineGitlabIntegration
  module GitlabInt
    class Hooks  < Redmine::Hook::ViewListener
      render_on(:view_projects_form, partial: 'git_lab_repositories/gitlab')
      render_on(:view_layouts_base_html_head, partial: 'git_lab_repositories/scripts')
      render_on(:view_my_account, partial: 'git_lab_repositories/token_form')
      render_on(:view_layouts_base_html_head, partial: 'git_lab_repositories/flash')
    end
  end
end
