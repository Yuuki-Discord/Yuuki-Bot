module YuukiBot
  module Custom

    if File.exists?('config/custom/custom.rb')
      require './config/custom/custom.rb'
      unless CUSTOM_TEXT.nil? || CUSTOM_TEXT == {}
        CUSTOM_TEXT.each {|name, response|
          $cbot.add_command(name.to_sym,
           code: proc {|event|
             event.respond(response)
           }
          )
          puts "Added custom command: #{name}"
        }
      end

      unless CUSTOM_IMAGE.nil? || CUSTOM_IMAGE == {}
        CUSTOM_IMAGE.each {|name, image|
          $cbot.add_command(name.to_sym,
           code: proc {|event|
             event.channel.send_file(File.new("./config/custom/#{image}"))
           }
          )
          puts "Added custom command: #{name}"
        }
      end
    end

    yml_commands = YAML.load_file('./config/custom/custom.yml') if File.exists?('config/custom/custom.yml')
    unless yml_commands.nil? || yml_commands[:text].nil? || yml_commands[:text] == {}
      yml_commands[:text].each {|name, response|
        $cbot.add_command(name.to_sym,
         code: proc {|event|
           event.respond(response)
         }
        )
        puts "Added custom command: #{name}"
      }
    end

    unless yml_commands.nil? || yml_commands[:image].nil? || yml_commands[:image] == {}
      yml_commands[:image].each {|name, image|
        $cbot.add_command(name.to_sym,
         code: proc {|event|
           event.channel.send_file(File.new("./config/custom/#{image}"))
         }
        )
        puts "Added custom command: #{name}"
      }
    end
    require './config/custom/code.rb' if File.exists? 'config/custom/code.rb'

  end
end