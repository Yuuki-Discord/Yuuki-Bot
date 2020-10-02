#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

# Mainly for docker, makes the log output a lot more sane.
STDOUT.sync = true

module YuukiBot
  class << self
    attr_reader :uploader
    attr_reader :launch_time
    attr_accessor :crb
  end
  @launch_time = Time.now

  if ENV['COMMANDRB_PATH'].nil?
    require 'commandrb'
  else
    puts '[INFO] Loading commandrb from Environment location.'
    require_relative "#{ENV['COMMANDRB_PATH']}/lib/commandrb"
  end

  if ENV['DISCORDRB_PATH'].nil?
    require 'discordrb'
  else
    puts '[INFO] Loading discordrb from Environment location.'
    require_relative "#{ENV['DISCORDRB_PATH']}/lib/discordrb"
  end

  require_relative 'modules/setup'
  require_relative 'modules/version'

  class CommandrbBot < CommandrbBot
    def owner?(id)
      if YuukiBot.config['master_owner'].to_i == id
        true
      else
        Helper.owners.include?(id)
      end
    end
  end

  init_hash = YuukiBot.build_init

  @crb = CommandrbBot.new(init_hash)

  module_dirs = %w[owner helper logging misc mod statistics utility]
  module_dirs.each do |dir|
    Dir["modules/#{dir}/*.rb"].each do |r|
      require_relative r
      puts "Loaded: #{r}" if @config['verbose']
    end
  end

  require_relative 'modules/custom'
  puts 'Loaded custom commands!'

  # Load Extra Commands if enabled.
  if YuukiBot.config['extra_commands']
    puts 'Loading: Extra commands...' if @config['verbose']
    Dir['modules/extra/*.rb'].each do |r|
      require_relative r
      puts "Loaded: #{r}" if @config['verbose']
    end
  end

  # Check if the key redis_password exists or is string literal 'nil'
  # If so, set it!
  redis_password = YuukiBot.config['redis_password']
  orig_redis = if redis_password.nil? || (redis_password == 'nil')
                 Redis.new(
                   host: YuukiBot.config['redis_host'],
                   port: YuukiBot.config['redis_port']
                 )
               else
                 Redis.new(
                   host: YuukiBot.config['redis_host'],
                   port: YuukiBot.config['redis_port'],
                   password: redis_password
                 )
               end

  REDIS = Redis::Namespace.new(
    YuukiBot.config['redis_namespace'],
    redis: orig_redis
  )

  puts '>> Initial loading succesful!! <<'
  @uploader = Haste::Uploader.new(@config['hastebin_instance_url'])
  if YuukiBot.config['use_pry']
    @crb.bot.run(true)
    require 'pry'
    binding.pry
  else
    puts 'Connecting to Discord....'
    @crb.bot.run
  end
end
