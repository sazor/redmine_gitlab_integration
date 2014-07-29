# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get '/projects/:project_id/gitlab', to: 'git_lab_repositories#index', as: 'git_lab'
delete '/projects/:project_id/gitlab/:id', to: 'git_lab_repositories#destroy', as: 'git_lab_repository_destroy'
