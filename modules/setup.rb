# frozen_string_literal: true

module YuukiBot
  class << self
    attr_accessor :config
  end

  require 'yaml'
  # Load Config from YAML

  unless File.exist?('config/config.yml')
    puts 'No valid config file found. Please copy config/config.sample.yml
    to config/config.yml and edit it, or run config.rb.'
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
        puts '[READY] Starting guild statistics...'
        YuukiBot::Statistics.register_statistics_callbacks event.bot
      }
    }
    init_hash
  end
end
