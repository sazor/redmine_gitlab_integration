require File.expand_path('../../test_helper', __FILE__)

class GitLabRepositoriesControllerTest < ActionController::TestCase
  include FactoryGirl::Syntax::Methods
  fixtures :projects, :roles, :users

  def setup
  	Rails.logger.debug Setting.plugin_redmine_gitlab_integration['gitlab_url']
    @user = create(:user_1)
  end

  def test
  	assert true
  end
end
