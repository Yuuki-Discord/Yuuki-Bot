# Copyright Erisa Komuro (Seriel) 2017

module YuukiBot
  module Helper

    class << self
      attr_accessor :saymap
    end

    def self.map_say(channel_id, trigger_id, response_id)
      @saymap = {} if @saymap.nil?
      @saymap[channel_id] if @saymap[channel_id].nil?
      @saymap[channel_id][trigger_id] = response_id
    end

    $cbot.bot.message_delete do |event|
      next if @saymap[event.channel.id].nil?
      if @saymap[event.channel.id].include?(event.id)
        event.channel.message(@saymap[event.channel.id])
      end
    end

  end
end
