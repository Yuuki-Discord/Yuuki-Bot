# frozen_string_literal: true

module YuukiBot
  module Custom
    if File.exist?('config/custom/custom.rb')
      require './config/custom/custom.rb'
      unless CUSTOM_TEXT.nil? || CUSTOM_TEXT == {}
        CUSTOM_TEXT.each do |name, response|
          YuukiBot.crb.add_command(
            name.to_sym,
            code: proc { |event|
              event.respond(response)
            }
          )
          puts "Added custom command: #{name}"
        end
      end

      unless CUSTOM_IMAGE.nil? || CUSTOM_IMAGE == {}
        CUSTOM_IMAGE.each do |name, image|
          YuukiBot.crb.add_command(name.to_sym,
                                   code: proc { |event|
                                     event.channel.send_file(File.new("./config/custom/#{image}"))
                                   })
          puts "Added custom command: #{name}"
        end
      end
    end

    if File.exist?('config/custom/custom.yml')
      yml_commands = YAML.load_file('./config/custom/custom.yml')
    end
    unless yml_commands.nil? || yml_commands[:text].nil? || yml_commands[:text] == {}
      yml_commands[:text].each do |name, response|
        YuukiBot.crb.add_command(name.to_sym,
                                 code: proc { |event|
                                   event.respond(response)
                                 })
        puts "Added custom command: #{name}"
      end
    end

    unless yml_commands.nil? || yml_commands[:image].nil? || yml_commands[:image] == {}
      yml_commands[:image].each do |name, image|
        YuukiBot.crb.add_command(name.to_sym,
                                 code: proc { |event|
                                   event.channel.send_file(File.new("./config/custom/#{image}"))
                                 })
        puts "Added custom command: #{name}"
      end
    end
    require './config/custom/code.rb' if File.exist? 'config/custom/code.rb'
  end
end
