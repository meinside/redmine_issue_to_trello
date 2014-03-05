#!/usr/bin/env ruby
# coding: UTF-8

# lib/trello_helper.rb
#
# created on : 2014.01.07
# last update: 2014.02.18
#
# by meinside@gmail.com

require 'trello'
require 'yaml'

module RedmineTrello

  class TrelloHelper
    # Loads the configuration from either the Rails' configuration directory
    # or the plugin directory.
    #
    # @return [Hash]
    def self.config
      config_file = "trello_config.yml"
      config = File.join(File.dirname(__FILE__), "..", "..", "..", 'config', config_file)

      if !File.exists? config
        config = File.join(File.dirname(__FILE__), "..", "config", config_file)
      end

      TrelloHelper.read_config(config)
    end

    private
    def initialize(app_key, user_token)
      @app_key = app_key
      @user_token = user_token
    end

    public
    # read config file at given path
    #
    # @param filepath [String] filepath
    # @param key [String] yaml key
    # @return [Hash]
    def self.read_config(filepath, key = "trello")
      YAML.load(File.open(filepath))[key]
    end

    # authenticate TrelloHelper
    #
    # - app key can be generated at: https://trello.com/1/appKey/generate
    # - user_token can be generated with following instruction: https://trello.com/docs/gettingstarted/index.html#getting-a-token-from-a-user
    #
    # @param app_key [String] Trello app key
    # @param user_token [String] Trello user token
    # @return [TrelloHelper,nil] authenticated TrelloHelper object, nil when error
    def self.authenticate(app_key, user_token)
      Trello.configure do |config|
        config.developer_public_key = app_key
        config.member_token = user_token
        @@authenticated = TrelloHelper.new(app_key, user_token)
      end
    rescue
      puts "# TrelloHelper.authenticate failed - #{$!}"
      nil
    end

    # list Trello boards
    #
    # @return [Array] boards
    def boards
      Trello::Board.all
    end

    # get Trello board with given board id
    #
    # @param board_id [String] board id
    # @return [Object,nil] nil if not exists
    def board(board_id)
      Trello::Board.find(board_id)
    rescue
      nil
    end

    # list Trello lists for given board id
    #
    # @param board_id [String] board id
    # @return [Array,nil] nil if given board id does not exist
    def lists(board_id)
      board(board_id).lists
    rescue
      nil
    end

    # post a new card on Trello
    #
    # @param list_id [String] Trello list id
    # @param name [String] name of the card
    # @param description [String] description of the card
    # @return [true,false]
    def post(list_id, name, description = "")
      Trello::Card.create(name: name, list_id: list_id, desc: description)
    end
  end

end
