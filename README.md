# Redmine Gitlab Integration Plugin
This plugin provides ability to connect gitlab repositories to your redmine project. 
For now plugin works only with Gitlab.
## Features
- Gitlab Repository creating in process of default Redmine Project creating (new form fields) with validation
- Two ways of gitlab authorization
  - Setting gitlab private token in user`s account
  - Login/pass form (appears only if private token is empty)
- Gitlab page with list of all connected repositories
- Ability to remove and add new repositories (by using their address)

## Installation
1. Clone this repository or download and unpack it to your_redmine_path/plugins
2. Install required gems: 
  1. Cd to plugin folder
  2. ` bundle install `
3. Plugin requires some migrations, so make ` rake redmine:plugins:migrate `
4. Restart Redmine

## Usage
Set url of gitlab repository in plugin setting (without ending slash).

In Gitlab account settings you can find your private token and copy it to Redmine account. Otherwise you`ll have to log in before gitlab project creating and you will not be able to add new repositories to project.

If you want Gitlab page in your project you should check Gitlab in Modules list. You can create gitlab repository without it,  but you will not be able to see it in Redmine.
