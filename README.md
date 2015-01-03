[![Code Climate](https://codeclimate.com/github/sazor/redmine_gitlab_integration/badges/gpa.svg)](https://codeclimate.com/github/sazor/redmine_gitlab_integration)
# Redmine Gitlab Integration Plugin
This plugin provides ability to connect gitlab repositories to your redmine project. 
For now plugin works only with Gitlab.
## Features
- Gitlab Repository creation in process of default Redmine Project creation (new form fields) with validation
- Setting gitlab private token in account settings
- Validation of gitlab private token
- Gitlab page with list of all connected repositories
- Ability to remove and add new repositories in 'Gitlab' tab in project
	- By using their address (just add link)
	- With repository creation (such as in redmine project creation)
	- Autoremove gitlab repository (could be disabled in settings)
- Gitlab group connected with all repositories of redmine project
- Project members synchronization
	- Add(remove) members and they will be added(removed) in gitlab group connected with this project 
	- Role also is synchronized and you can set up connections between roles in both systems
- Events for project activity
- Attention message for users which haven't set gitlab token 

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
You should set url of gitlab repository in plugin setting (without ending slash) and gitlab token of bot (with admin rights).

In Gitlab account settings you can find your private token and copy it to Redmine account. 

If you want Gitlab page in your project you should check Gitlab in Modules list. You can create gitlab repository without it, but you will not be able to see it in Redmine.

## License
This plugin is released under the GPL v2 license. See LICENSE for more information.

