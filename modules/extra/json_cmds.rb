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
    text_attack_commands.each { |x|
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
    text_attack_commands.each { |x|
      Commandrb.commands[x.to_sym] = {
        code: proc { |event|
          result = File.readlines("text/Attacks/Text/#{x}.txt").sample.chomp
          event.respond("*#{result}*")
        },
      }
      puts "Added attack command for #{x}!" if YuukiBot.config['verbose']
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
    puts 'Added fun command for random question!' if YuukiBot.config['verbose']
    
      
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

    Commandrb.commands[:bookpun] = {
      code: proc { |event,args|
        title, author = File.readlines('text/Jokes/bookpun.txt').sample.chomp.split ': ', 2
        event.respond("#{title} by #{author}")
      },
    }
      
    Commandrb.commands[:wouldyourather] = {
      code: proc { |event,args|
        json_string = open('http://rrrather.com/botapi').read
        array = JSON.parse(json_string, symbolize_names: true)
        event.respond("#{array[:title]}: #{array[:choicea].rstrip} OR #{array[:choiceb].rstrip}")
      },
    }

    Commandrb.commands[:fact] = {
      code: proc { |event,args|
        types = %w(trivia math date year)
        open("http://numbersapi.com/random/#{types.sample}").read
      },
    }

    Commandrb.commands[:eightball] = {
      code: proc { |event,args|
        event.respond("shakes the magic 8 ball... **#{File.readlines('text/Other/8ball_responses.txt').sample.chomp}**")
      },
    }

    Commandrb.commands[:cats] = {
      code: proc { |event,args|
        json_string = open('https://catfacts-api.appspot.com/api/facts').read
        array = JSON.parse(json_string, symbolize_names: true)
        event.respond(array[:facts][0].to_s)
      },
    }

    Commandrb.commands[:catgifs] = {
      code: proc { |event,args|
        gif_url = nil
        open('http://marume.herokuapp.com/random.gif') do |resp|
          gif_url = resp.base_uri.to_s
        end
        event.respond("OMG A CAT GIF: #{gif_url}")
      },
    }

=begin
    Commandrb.commands[:flip] = {
      code: proc { |event,args|
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
=end

    Commandrb.commands[:fight] = {
      code: proc { |event,args|
        args = args.join(' ')
        begin
          target = event.bot.parse_mention(args).name
        rescue
          target = args
        end
        json = JSON.parse(File.read('text/Attacks/JSON/fight.json'))

        variables = {}
        variables['user'] = event.user.name
        variables['target'] = target
        response = Textgen.generate_string(json['templates'], json['parts'], variables)
        
        event.respond(response)
      },
    }

    Commandrb.commands[:randommovie] = {
      code: proc { |event,args|
        movie = open('https://random-movie.herokuapp.com/random').read
        array = JSON.parse(movie, symbolize_names: true)

        response = ":film_frames: **Random Movie** :film_frames:\n" +
        "Title: #{array[:Title]}\n" +
        "Year: #{array[:Year]}\n" +
        "Rating: #{array[:Rated]}\n" +
        "Runtime: #{array[:Runtime]}\n" +
        "Plot: #{array[:Plot]}\n" +
        "IMDB Rating: #{array[:imdbRating]}\n" +
        "IMDB Votes: #{array[:imdbVotes]}\n" +
        "Poster: #{array[:Poster].sub('._V1_SX300', "")}"
        
        event.respond(response)
      
      },
    }
  end
end
