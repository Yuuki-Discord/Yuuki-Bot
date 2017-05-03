# Copyright Seriel, spotlight_is_ok, Larsenv 2017
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
      puts "Added attack command for #{x}!" if YuukiBot.config['verbose']
    }
     
    text_attack_commands = %w(nk)
    text_attack_commands.each do |x|
      Commandrb.commands[x.to_sym] = {
        code: proc { |event|
          result = File.readlines("text/Attacks/Text/#{x}.txt").sample.chomp
          
          event.respond("*#{result}*")
        },
      }
      puts "Added attack command for #{x}!" if YuukiBot.config['verbose']
    }
      
    text_joke_commands = %w(doit pun wisdom lawyerjoke)
    text_joke_commands.each do |x|
      Commandrb.commands[x.to_sym] = {
        code: proc { |event|
          result = File.readlines("text/Jokes/#{x}.txt").sample.chomp
          
          event.respond("*#{result}*")
        },
      }
      puts "Added jokes command for #{x}!" if YuukiBot.config['verbose']
    }
      
    text_other_commands = %w(vote topicchange fortunes factdiscord randomssmash4item)
    text_other_commands.each do |x|
      Commandrb.commands[x.to_sym] = {
        code: proc { |event|
          result = File.readlines("text/Other/Text/#{x}.txt").sample.chomp
          
          event.respond("*#{result}*")
        },
      }
      puts "Added jokes command for #{x}!" if YuukiBot.config['verbose']
    }
      
    Commandrb.commands[:randomquestion] = {
      code: proc { |event|
        json = JSON.parse(File.read("text/Other/JSON/randomquestion.json"))

        prng = Random.new
        variables = {}
        response = Textgen.generate_string(json['templates'], json['parts'], variables)
          
        event.respond(response)
      },
    }
    puts "Added fun command for random question!" if YuukiBot.config['verbose']
    
      
    Commandrb.commands[:nextzeldagame] = {
      code: proc { |event|
        json = JSON.parse(File.read("text/Other/JSON/nextzeldagame.json"))

        prng = Random.new
        variables = {}
        variables["random_number"] = prng.rand(1..10)
        response = Textgen.generate_string(json['templates'], json['parts'], variables)
        
        event.respond(response)
      },
    }
    puts "Added fun command for nextzeldagame!" if YuukiBot.config['verbose']
      
    Commandrb.commands[:confucious] = {
      code: proc {|event|
        event.respond("Confucious say #{File.readlines('text/Jokes/confucious.txt').sample.chomp}")
      },
    }
    puts "Added jokes command for confucious!" if YuukiBot.config['verbose']

    Commandrb.commands[:bookpun] = {
      code: proc {|event|
        title, author = File.readlines('text/Jokes/bookpun.txt').sample.chomp.split ': ', 2
        event.respond("#{title} by #{author}")
      },
    }
    puts "Added jokes command for bookpun!" if YuukiBot.config['verbose']
      
    Commandrb.commands[:wouldyourather] = {
      code: proc {|event|
        json_string = open('http://rrrather.com/botapi').read
        array = JSON.parse(json_string, symbolize_names: true)
        event.respond("#{array[:title]}: #{array[:choicea].rstrip} OR #{array[:choiceb].rstrip}")
      },
    }
    puts "Added fun command for wouldyourather!" if YuukiBot.config['verbose']

    Commandrb.commands[:fact] = {
      code: proc {|event|
        types = %w(trivia math date year)
        type = types.sample
        open("http://numbersapi.com/random/#{type}").read
      },
    }
    puts "Added fun command for fact!" if YuukiBot.config['verbose']
      
    Commandrb.commands[:eightball] = {
      code: proc {|event|
        event.respond("shakes the magic 8 ball... **#{File.readlines('text/Other/8ball_responses.txt').sample.chomp}**")
      },
    }
    puts "Added fun command for eightball!" if YuukiBot.config['verbose']
    en

    Commandrb.commands[:cats] = {
      code: proc {|event|
        json_string = open('https://catfacts-api.appspot.com/api/facts').read
        array = JSON.parse(json_string, symbolize_names: true)
        event.respond(array[:facts][0]).to_s)
      },
    }
    puts "Added fun command for cats!" if YuukiBot.config['verbose']
      
    Commandrb.commands[:catgifs] = {
      code: proc {|event|
        gif_url = nil
        open('http://marume.herokuapp.com/random.gif') do |resp|
        gif_url = resp.base_uri.to_s
        end
        event.respond("OMG A CAT GIF: #{gif_url}")
      },
    }
    puts "Added fun command for catgifs!" if YuukiBot.config['verbose']

    Commandrb.commands[:flip] = {
      code: proc {|event|
        args = args.join(' ')
        begin
        target = event.bot.parse_mention(args).on(event.server).display_name.name
        rescue
        target = args
        end
        flippers = ['( ﾉ⊙︵⊙）ﾉ', '(╯°□°）╯', '( ﾉ♉︵♉ ）ﾉ']
        flipper = flippers.sample
        event.respond("#{flipper}  ︵ #{target.flip}")
      },
    }
    puts "Added fun command for flip!" if YuukiBot.config['verbose']
  end
end
