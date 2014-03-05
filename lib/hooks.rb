#!/usr/bin/env ruby
# coding: UTF-8

# lib/hooks.rb
#
# hooks
#
# created on : 2014.01.07
# last update: 2014.02.17
#
# by meinside@gmail.com
#
module RedmineTrello

  class Hooks < Redmine::Hook::ViewListener
    def controller_issues_new_after_save(context = {})
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

      card_formatter = CardFormatter.new(context[:project], context[:issue])

      # post a new card
      trello = TrelloHelper.authenticate(app_key, user_token)
      trello.post(list_id, card_formatter.title, card_formatter.description)
    end
  end

end
