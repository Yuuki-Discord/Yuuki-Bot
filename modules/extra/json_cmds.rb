# Copyright Seriel, spotlight_is_ok, Larsenv 2016
module YuukiBot
  module Extra
    json_food_commands = %w(potato cake cookie sandwich taco coffee noodles muffin tea keto beer cheese pancake chicken nugget pie icecream pizza chocolate pasta cereal sushi steak burger oreo biscuit snack)

    json_food_commands.each { |x|
      Commandrb.commands[x.to_sym] = {
        code: proc { |event,args|
          target = begin
            event.bot.parse_mention(args.join(' ')).name
          rescue
            args.join(' ')
          end
          json = JSON.parse(File.read("text/Food/#{x}.json"))

          variables = {}
          variables['user'] = target
          event.respond("*#{Textgen.generate_string(json['templates'], json['parts'], variables)}*")
        },
        triggers: [x, "give #{x} to ",  "give a #{x} to "],
      }
      puts "Added food command for #{x}!" if YuukiBot.config['verbose']
    }

    json_attack_commands = %w(slap compliment strax present)
    json_attack_commands.each { |x|
      Commandrb.commands[x.to_sym] = {
        code: proc { |event,args|
          target = begin
            event.bot.parse_mention(args.join(' ')).name
          rescue
            args.join(' ')
          end
          json = JSON.parse(File.read("text/Attack/JSON/#{x}.json"))

          variables = {}
          variables['user'] = target
          event.respond("*#{Textgen.generate_string(json['templates'], json['parts'], variables)}*")
        },
      }
      puts "Added attack command for #{x}!" if YuukiBot.config['verbose']
    }
     
    text_attack_commands = %w(lart insult)
    text_attack_commands.each do |x|
      Commandrb.commands[x.to_sym] = {
        code: proc { |event,args|
          target = begin
            event.bot.parse_mention(args.join(' ')).name
          rescue
            args.join(' ')
          end
          result = File.readlines("text/Attacks/Text/#{x}.txt").sample.chomp
          result = result.gsub('{user}', target) if /{user}/ =~ result
          
          event.respond("*#{result}*")
        },
      }
      puts "Added attack command for #{x}!"
    }
     
    text_attack_commands = %w(nk)
    text_attack_commands.each do |x|
      Commandrb.commands[x.to_sym] = {
        code: proc { |event|
          result = File.readlines("text/Attacks/Text/#{x}.txt").sample.chomp
          
          event.respond("*#{result}*")
        },
      }
      puts "Added attack command for #{x}!"
    }
      
    text_joke_commands = %w(doit pun wisdom lawyerjoke)
    text_joke_commands.each do |x|
      Commandrb.commands[x.to_sym] = {
        code: proc { |event|
          result = File.readlines("text/Jokes/#{x}.txt").sample.chomp
          
          event.respond("*#{result}*")
        },
      }
      puts "Added jokes command for #{x}!"
   }
      
      
  end
end
