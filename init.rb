require 'redmine'

require_dependency 'redmine-trello.rb'

Redmine::Plugin.register :redmine_issue_to_trello do
  name 'Redmine Issue To Trello'
  author 'Sungjin Han'
  description 'Post new Trello cards on Redmine issue creations'
  version '0.0.1'
  url 'http://github.com/meinside/redmine_issue_to_trello'
  author_url 'http://meinside.pe.kr'
end

