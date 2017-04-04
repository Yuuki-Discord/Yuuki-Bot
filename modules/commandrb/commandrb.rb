module Commandrb

  class << self
    attr_accessor :commands
    attr_accessor :prefixes
    attr_accessor :bot
    attr_accessor :prefix_type
    attr_accessor :owners
  end

  def self.initialise(init_hash)

    @commands = {}
    @prefixes = []

    @prefix_type = init_hash[:prefix_type].nil? ? 'rescue' : init_hash[:prefix_type]
    @typing_default = init_hash[:typing_default] rescue true

    if init_hash[:token].nil? or init_hash[:token] == ''
      puts 'No token supplied in init hash!'
      return false
    else
      init_token = init_hash[:token]
    end

    init_parse_self = init_hash[:parse_self] rescue nil
    init_type = init_hash[:type] rescue :bot

    if init_type == :bot
      if init_hash[:client_id].nil?
        puts 'No client ID or invalid client ID supplied in init hash!'
        return false
      end
    end

    @prefixes = []

    begin
      @owners = init_hash[:owners]
    rescue
      puts 'Invalid owners supplied in init hash!'
      return false
    end

    begin
      @prefixes = init_hash[:prefixes]
    rescue
      puts 'Invalid prefixes supplied in init hash!'
      return false
    end

    @bot = Discordrb::Bot.new(
      token: init_token,
      client_id: init_hash[:client_id],
      parse_self: init_parse_self,
      type: init_type
    )

    unless init_hash[:ready].nil?
      @bot.ready do |event|
        init_hash[:ready].call(event)
      end
    end

    # Command processing
    @bot.message do |event|
      puts "[COMMAND RECIEVED] :: #{event.message.content}"

    end
  end
end
