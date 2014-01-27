#!/usr/bin/env ruby
# coding: UTF-8

# trello_board_ids.rb
# 
# show board ids and names
# 
# created on : 2014.01.07
# last update: 2014.01.07
# 
# by meinside@gmail.com

require_relative '../lib/trello_helper'

if __FILE__ == $0
  begin
    config = TrelloHelper.config
  rescue
    puts "* config file does not exist: copy config/trello_config.yml.sample and edit it"
    exit 1
  end

  app_key = config["app_key"]
  user_token = config["user_token"]

  trello = TrelloHelper.authenticate(app_key, user_token)

  trello.boards.each{|x|
    puts "#{x.name}: #{x.id}"
  }
end

