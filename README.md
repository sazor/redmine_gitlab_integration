[![Build Status](https://travis-ci.org/sazor/redmine_gitlab_integration.svg?branch=master)](https://travis-ci.org/Sazor/redmine_gitlab_integration)[![Code Climate](https://codeclimate.com/github/sazor/redmine_gitlab_integration/badges/gpa.svg)](https://codeclimate.com/github/sazor/redmine_gitlab_integration)
# Redmine Gitlab Integration Plugin
This plugin provides ability to connect gitlab repositories to your redmine project. 
For now plugin works only with Gitlab.
## Features
- Gitlab Repository creation in process of default Redmine Project creation (new form fields) with validation
- Two ways of gitlab authorization
  - Setting gitlab private token in user`s account
  - Validation of gitlab private token
  - Login/pass form (appears only if private token is empty)
- Gitlab page with list of all connected repositories
- Ability to remove and add new repositories in 'Gitlab' tab in project
	- By using their address (just add link)
	- With repository creation (such as in redmine project creation)
	- Autoremove gitlab repository (could be disabled in settings)
- Project members synchronization
	- By LDAP(identical usernames) or by gitlab token
	- Add(remove) members and they will be added(removed) in all repositories connected with this project 
	- Role also is synchronized. But redmine has multirole system when in gitlab member has only one role, so add process uses first role and edit uses last role

## Installation
1. Clone this repository or download and unpack it to your_redmine_path/plugins
2. Install required gems: 
  1. Cd to plugin folder
  2. ` bundle install `
3. Plugin requires some migrations, so make ` rake redmine:plugins:migrate `
4. Restart Redmine

## Uninstall
1. Rollback all db changes ` rake redmine:plugins:migrate NAME=redmine_gitlab_integration VERSION=0 RAILS_ENV=production `
2. Remove plugin folder ` sudo rm -r plugins/redmine_gitlab_integration `
3. Restart Redmine

## Usage
Set url of gitlab repository in plugin setting (without ending slash).

In Gitlab account settings you can find your private token and copy it to Redmine account. 

Setting gitlab private token give you abilities to:
- Add/remove repositories in 'Gitlab' tab
- Project members synchronization
- Not authenticate in project creation

If you want Gitlab page in your project you should check Gitlab in Modules list. You can create gitlab repository without it, but you will not be able to see it in Redmine.
