module Commandrb

  class << self
    attr_accessor :commands
    attr_accessor :prefixes
    attr_accessor :bot
    attr_accessor :prefix_type
    attr_accessor :owners
    attr_accessor :typing_default
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
      $continue = false
      puts "[DEBUG] #{@prefixes}"
      @prefixes.each { |prefix|
        if event.message.content.start_with?(prefix)
          puts "[COMMAND RECIEVED] :: #{event.message.content}"
          # Do shit.
          
          @commands.each { | key, command |
            if command[:triggers].nil?
              triggers = [key.to_s] 
            else
              triggers = command[:triggers]
            end
		            
            triggers.each { |trigger|
            @activator = prefix + trigger
            puts "Possible @activator: #{@activator}"
              if event.message.content.start_with?(@activator)
                puts '@activator picked.'
                $continue = true
                break
              else
                next
              end
            }
            
            next if !$continue
            puts 'Continued'
            
if command[:owners_only]
 if  YuukiBot.config['owners'].include?(event.user.id)
	puts 'yes'
else
puts 'no'
  event.respond(':x: You don\'t have permission for that!')
  break
end	
end


          begin
              if args.length > command[:max_args]
                event.respond("❌ Too many arguments! \nMax arguments: `#{command[:max_args]}`")
                next
              end
            rescue
              # Do nothing.
            end
            puts 'Enough args'
            
            begin
              if !command[:server_only].nil? && command[:server_only] && event.channel.private?
                event.respond('❌ This command will only work in servers!')
                next
              end
            rescue
              # Do nothing.
            end
            puts 'Server check passed'
            
            begin
              if !command[:parse_bots].nil? && (event.user.bot_account? && command[:parse_bots] == false) || (event.user.bot_account? && @parse_bots == false)
                next
              end
            rescue
              # Do nothing.
            end
            
            puts 'bot check passed'
            
            begin
             event.channel.start_typing if command[:typing] || (command[:typing].nil? && YuukiBot.config['typing_default'].typing_default)
            rescue
            # Do nothing.
            end
            puts 'typing done'
            
            args = event.message.content.slice!(@activator.length, event.message.content.size)
            args = args.split(' ')
            puts 'ARGS MADE!!'
            puts "[DEBUG] #{args}"
            command[:code].call(event, args)
            break
          }
          break
        end
      }
    end
  end
end
