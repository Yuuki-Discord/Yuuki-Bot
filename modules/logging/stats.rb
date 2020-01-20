# frozen_string_literal: true

# Copyright Erisa Komuro (Seriel) 2016-2017
module YuukiBot
  module Logging
    # class << self
    #   attr_accessor :stats
    # end
    # @stats = {
    #   totalmessages: 0,
    #   totalmessageedits: 0,
    #   totalmessagedeletes: 0,
    #   totaljoinevents: 0,
    #   totalleaveevents: 0,
    #   server: {
    #     DM: {}
    #   }
    # }
    # @stats[:server] = {}
    # @stats[:server][:DM] = {}
    # # Helper.load_stats(true)
    # extend Discordrb::EventContainer
    #
    # @stats = {
    #   totalmessages: 0,
    #   totalmessageedits: 0,
    #   totalmessagedeletes: 0,
    #   totaljoinevents: 0,
    #   totalleaveevents: 0,
    #   server: {
    #     DM: {
    #       messages: 0,
    #     },
    #       1234567890123456 => {
    #         messages: 0,
    #         message_edits: 0,
    #         message_deletes: 0,
    #         joinevents: 0,
    #         leaveevents: 0
    #       }
    #     }
    # }
    #
    # def init_stats(server_id)
    #   @stats[:server][server_id] = {
    #     messages: 0,
    #     message_edits: 0,
    #     message_deletes: 0,
    #     joinevents: 0,
    #     leaveevents: 0
    #   }
    # end
    #
    # message do |event|
    #   if event.channel.private?
    #     @stats[:server][:dm][:messages] += 1
    #   else
    #     init_stats(event.server.id) if @stats[:server][server_id].nil?
    #     @stats[:server][event.server.id][:messages] += 1
    #   end
    #   @stats[:totalmessages] += 1
    #   Helper.save_stats
    # end
    #
    # message_edit do |event|
    #   if event.channel.private?
    #     @stats[:server][:dm][:message_edits] += 1
    #   else
    #     init_stats(event.server.id) if @stats[:server][server_id].nil?
    #     @stats[:server][event.server.id][:message_edits] += 1
    #   end
    #   @stats[:totalmessageedits] += 1
    # end
    #
    # message_delete do |event|
    #   if event.channel.private?
    #     @stats[:server][:dm][:message_edits] += 1
    #   else
    #     init_stats(event.server.id) if @stats[:server][server_id].nil?
    #     @stats[:server][event.server.id][:message_deletes] += 1
    #   end
    #   @stats[:totalmessagedeletes] += 1
    # end
    #
    # $cbot.add_command(
    #   :stats,
    #   code: proc {
    #     raise NotImplementedError
    #   },
    #     triggers: %w(stats statistics stat),
    #     cath_errors: true
    # )
  end
end
