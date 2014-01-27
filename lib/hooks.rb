require_relative 'trello_helper'

class Hooks < Redmine::Hook::ViewListener
	def controller_issues_new_after_save(context = {})
    begin
      # read config
      config = TrelloHelper.config
      app_key = config["app_key"]
      user_token = config["user_token"]
      list_id = config["list_id"]

      # read context for the issue
      project_name = context[:project].name
      issue_subject = context[:issue].subject
      issue_description = context[:issue].description
      issue_duedate = context[:issue].due_date

      # post a new card
      trello = TrelloHelper.authenticate(app_key, user_token)
      trello.post(list_id, "#{project_name} / #{issue_subject}", 
<<DESCRIPTION
#{project_name} / #{issue_subject}

* due date: #{issue_duedate}

#{issue_description}
DESCRIPTION
      )
    rescue
      Rails.logger.error "While sending Redmine issue to Trello: #{$!}"
    end
	end
end
