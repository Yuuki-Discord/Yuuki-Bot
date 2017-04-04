# Copyright Seriel, spotlight_is_ok, Larsenv 2016
module YuukiBot
  module Extra
    json_food_commands = %w(potato cake cookie sandwich taco coffee noodles muffin tea keto beer cheese pancake chicken nugget pie icecream pizza chocolate pasta cereal sushi steak burger oreo biscuit)

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
          json = JSON.parse(File.read("text/Food/#{x}.json"))

          variables = {}
          variables['user'] = target
          event.respond("*#{Textgen.generate_string(json['templates'], json['parts'], variables)}*")
        },
      }
      puts "Added attack command for #{x}!" if YuukiBot.config['verbose']
    }
  end
end