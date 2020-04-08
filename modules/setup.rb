# frozen_string_literal: true

module YuukiBot
  class << self
    attr_accessor :config
  end

  require 'yaml'
  # Load Config from YAML

  unless File.exist?('config/config.yml')
    puts 'You don\'t have a valid config file!'
    puts 'If you want to create a config file manually, please stop this program with Ctrl+C ' \
      'and follow the instructions in config/README.md.'
    puts 'Waiting 3 seconds...'
    sleep 3
    # Initialise a fresh set of configuration options.
    newconfig = YAML.load_file('config/config.sample.yml')
    puts '-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
    puts 'Okay! First of all you\'ll need to create a bot account!'
    puts 'To do that, go here -> https://discordapp.com/developers/applications/me <-'
    puts 'And login to your Discord account! Then follow the instructions to make a new app'
    puts 'After you have your app, scroll down to the Bot section and click the blue button ' \
      'labelled "Create a bot user"'
    puts 'Then click "click to reveal" next to \'Token:\' and copy the long string inside!'
    print 'Please paste that string here: '
    token = gets.chomp

    puts '-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
    puts 'Awesome! Now you\'ll need to head to the top of the page and fetch the Client ID, ' \
      'which should be a long number.'
    print 'And paste that here: '
    appid = gets.chomp

    puts '-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
    puts 'Wew, that\'s the hard part out of the way. ' \
      'Now you get to decide some needed options for your bot!'
    puts 'Your bot will need at least one prefix to be used. For example: ' \
      'if you use the prefix s!, your help command will be \'s!help\'.'
    puts 'If your prefix is a word, please add a space after it! ' \
      '(For example enter \'tomoe\' for \'tomoe ping\' instead of \'tomoeping\''
    print 'Enter your first prefix here: '
    prefix = gets.chomp

    puts "Nice prefix! Your bots help command will be: '#{prefix}help'"

    puts '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
    puts 'That\'s enough information to get the bot launching, but there\'s one more thing we need.'
    puts 'If you haven\'t already, go to User Settings -> Appearance, and enable Developer Mode.'
    puts 'Then, right click your own name and select Copy ID.'
    print 'Paste that ID here: '
    id = gets.chomp
    puts 'Nice! This will make you the owner of the bot and allow you to control things ' \
      'and add more owners through commands.'

    puts "\nPLEASE NOTE THAT NOT ALL INFORMATION IS COVERED WITH THIS GUIDE"
    puts 'Please check config/config.sample.yml and config.yml to fine-tune the options.'

    puts "\n We're now collating the information and generating a configuration file..."
    newconfig['token'] = token
    newconfig['client_id'] = appid
    newconfig['prefixes'][0] = prefix
    newconfig['master_owner'] = id

    File.write('config/config.yml', newconfig.to_yaml)

    puts 'All done! The bot will launch in 1 second..'
    # Delay so the user knows what's happening.
    sleep(1)

    # Let's go!
  end

  @config = YAML.load_file('config/config.yml')
  @config.each do |key, value|
    if value.nil?
      puts "config.yml: #{key} is nil!"
      puts 'Corrupt or incorrect Yaml.'
      exit
    elsif key == 'token'
      puts 'config.yml: Found: token: [REDACTED]'
    elsif @config['verbose']
      puts("config.yml: Found #{key}: #{value}")
    end
  end

  default_haste_instance = 'https://paste.erisa.moe'
  if @config['hastebin_instance_url'].nil?
    puts "No Hastebin instance configured. Using #{default_haste_instance}."
    @config['hastebin_instance_url'] = default_haste_instance
  end

  @config['debug'] = false if @config['debug'].nil?

  if @config['status'].nil?
    puts 'Enter a valid status in config.yml!'
    puts 'Valid options are \'online\', \'idle\', \'dnd\' and \'invisible\'.'
    raise 'Invalid status'
  end

  raise 'No valid token entered!' if @config['token'].nil?

  @config['owners'] = if @config['master_owner'].nil?
                        [@config['owners'][0]]
                      else
                        [@config['master_owner']]
                      end

  def self.build_init
    # Transfer it into an init hash.
    init_hash = {
      token: @config['token'],
      prefixes: @config['prefixes'],
      client_id: @config['client_id'],
      parse_self: @config['parse_self'],
      parse_bots: @config['parse_bots'],
      catch_errors: @config['catch_errors'],
      selfbot: false,
      type: @config['type'],
      game: @config['game'],
      owners: @config['owners'],

      typing_default: @config['typing_default'],
      ready: proc { |event|
        case @config['status']
        when 'idle' || 'away' || 'afk' then event.bot.idle
        when 'dnd' then event.bot.dnd
        when 'online' then event.bot.online
        when 'invisible' || 'offline' then event.bot.invisible
        when 'stream' || 'streaming' then event.bot.stream(@config['game'], @config['twitch_url'])
        else
          raise 'No valid status found.'
        end
        ignored = begin
                    JSON.parse(REDIS.get('ignores'))
                  rescue StandardError
                    []
                  end
        ignored.each do |id|
          begin
            @crb.bot.ignore_user(@crb.bot.user(id))
          rescue StandardError => e
            p e
          end
        end

        event.bot.game = begin
                           YuukiBot.config['game']
                         rescue StandardError
                           nil
                         end
        puts "[READY] Logged in as #{event.bot.profile.distinct} (#{event.bot.profile.id})!"
        puts "[READY] Connected to #{event.bot.servers.count} servers!"
        puts "[READY] Raw Invite URL: #{event.bot.invite_url}"
        puts "[READY] Redis ping: #{REDIS.ping}"
        puts "[READY] Vanity Invite URL: #{begin
                                             @config['invite_url']
                                           rescue StandardError
                                             event.bot.invite_url
                                           end}"
      }
    }
    init_hash
  end
end
