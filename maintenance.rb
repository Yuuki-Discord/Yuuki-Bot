require 'yaml'
require 'discordrb'
# Load Config from YAML
if File.exists?('config/maintenance.yml')
    @config = YAML.load_file('config/maintenance.yml')
else
    @config = YAML.load_file('config/config.yml')
end

@config.each do |key, value|
    if value.nil?
      puts "config.yml: #{key} is nil!"
      puts 'Corrupt or incorrect Yaml.'
      exit
    else
      puts("config.yml: Found #{key}: #{value}") if @config['verbose']
    end
end

# owners.yml always overrides config.yml, but if it doesn't exist, config.yml will be honoured.
# This ensures compatibility with old config files, meaning no owners file needs to be setup.
if File.exists?('config/owners.yml')
    @config['owners'] = YAML.load_file('config/owners.yml')['owners']
end
  
bot = Discordrb::Bot.new token: @config['token']
bot.ready do |event|
    event.bot.dnd
    event.bot.game = "Down for maintenance... :("
end

bot.message do |event|
    if event.message.content.split(' ').length > 1 
        @config['prefixes'].each { |x|
            if event.message.content.start_with? x
                event.respond("Hi, if you're seeing this message, it means that Yuuki-Bot is currently unavailable (Deliberately, unlike downtime) or is in maintenance due to a major bug that needs to be dealt with.\nPlease try again later, and contact `#{event.bot.user(@config['owners'][0]).distinct}` if problems persist.\nSorry for any inconvenience caused!")
                break
            end
        }
    end
end

bot.run