require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')
require File.dirname(__FILE__) + '/factories.rb'
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
Setting.plugin_redmine_gitlab_integration['gitlab_url'] = 'https://gitlab.com'