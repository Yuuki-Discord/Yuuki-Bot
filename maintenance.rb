# frozen_string_literal: true

require 'yaml'
require 'discordrb'

# Load Config from YAML
@config = if File.exist?('config/maintenance.yml')
            YAML.load_file('config/maintenance.yml')
          else
            YAML.load_file('config/config.yml')
          end

@config.each do |key, value|
  if value.nil?
    puts "config.yml: #{key} is nil!"
    puts 'Corrupt or incorrect Yaml.'
    exit
  elsif @config['verbose']
    puts("config.yml: Found #{key}: #{value}")
  end
end

bot = Discordrb::Bot.new token: @config['token']
bot.ready do |event|
  event.bot.dnd
  event.bot.game = 'Down for maintenance... :('
end

bot.message do |event|
  if event.message.content.split(' ').length > 1
    @config['prefixes'].each do |x|
      next unless event.message.content.start_with? x

      username = event.bot.profile.name
      owner_distinct = event.bot.user(@config['master_owner']).distinct
      event.respond("Hi! It seems that #{username} is currently undergoing maintenance.\n" \
      "Please try again later, and contact `#{owner_distinct}` if problems persist.\n" \
      'Sorry for any inconvenience caused!')
      break
    end
  end
end

bot.run
