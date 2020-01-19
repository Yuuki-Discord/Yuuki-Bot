# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe), spotlight_is_ok, Larsenv 2017-2020
module YuukiBot
  module Extra
    if YuukiBot.config['extra_commands']
      json_food_commands = %w[beer biscuit brekkie burger cake cereal cheese chicken chocolate coffee cookie donut doobie drinks halal icecream kebab keto kosher milkshake muffin noodles nugget oreo pancake pasta pie pizza potato rice sandwich scone snack soup steak sushi taco tea wine]

      json_food_commands.each do |x|
        $cbot.add_command(x.to_sym,
                          code: proc { |event, args|
                            target_guess = event.bot.parse_mention(args.join(' '))
                            target = if args.nil? || (args == [])
                                       event.user.name
                                     elsif target_guess.nil?
                                       args.join(' ')
                                     else
                                       target_guess.name
                                     end

                            json = JSON.parse(File.read("text/Food/#{x}.json"))

                            variables = {}
                            variables['user'] = target
                            event.respond("\\*#{Textgen.generate_string(json['templates'], json['parts'], variables)}*")
                          },
                          triggers: [x, "give #{x} to ", "give a #{x} to "])
        puts "Added food command for #{x}!" if YuukiBot.config['verbose']
      end
      $cbot.commands[:brekkie][:triggers].push('breakfast', 'brekky', 'give breakfast to ', 'give a breakfast to', 'give brekky to ', 'give a brekky to')

      json_attack_commands = %w[slap compliment strax present]
      json_attack_commands.each do |x|
        $cbot.add_command(x.to_sym,
                          code: proc { |event, args|
                            target_guess = event.bot.parse_mention(args.join(' '))
                            target = if args.nil? || (args == [])
                                       event.user.name
                                     elsif target_guess.nil?
                                       args.join(' ')
                                     else
                                       target_guess.name
                                     end

                            json = JSON.parse(File.read("text/Attack/JSON/#{x}.json"))

                            variables = {}
                            variables['user'] = target
                            event.respond("\\*#{Textgen.generate_string(json['templates'], json['parts'], variables)}*")
                          })
        puts "Added attack command for #{x}!" if YuukiBot.config['verbose']
      end

      text_attack_commands = %w[lart insult]
      text_attack_commands.each do |x|
        $cbot.add_command(x.to_sym,
                          code: proc { |event, args|
                            target_guess = event.bot.parse_mention(args.join(' '))
                            target = if args.nil? || (args == [])
                                       event.user.name
                                     elsif target_guess.nil?
                                       args.join(' ')
                                     else
                                       target_guess.name
                                     end

                            result = File.readlines("text/Attacks/Text/#{x}.txt").sample.chomp
                            if /{user}/ =~ result
                              result = result.gsub('{user}', target)
                            end

                            event.respond("\\*#{result}*")
                          })
        puts "Added attack command for #{x}!" if YuukiBot.config['verbose']
      end

      text_attack_commands = %w[nk]
      text_attack_commands.each do |x|
        $cbot.add_command(x.to_sym,
                          code: proc { |event|
                            result = File.readlines("text/Attacks/Text/#{x}.txt").sample.chomp

                            event.respond("\\*#{result}*")
                          })
        puts "Added attack command for #{x}!" if YuukiBot.config['verbose']
      end

      text_joke_commands = %w[doit pun wisdom lawyerjoke]
      text_joke_commands.each do |x|
        $cbot.add_command(x.to_sym,
                          code: proc { |event|
                            result = File.readlines("text/Jokes/#{x}.txt").sample.chomp

                            event.respond("\\*#{result}*")
                          })
        puts "Added jokes command for #{x}!" if YuukiBot.config['verbose']
      end

      text_other_commands = %w[vote topicchange fortunes factdiscord randomssmash4item]
      text_other_commands.each do |x|
        $cbot.add_command(x.to_sym,
                          code: proc { |event|
                            result = File.readlines("text/Other/Text/#{x}.txt").sample.chomp

                            event.respond("\\*#{result}*")
                          })
        puts "Added jokes command for #{x}!" if YuukiBot.config['verbose']
      end

      $cbot.add_command(:randomquestion,
                        code: proc { |event|
                          json = JSON.parse(File.read('text/Other/JSON/randomquestion.json'))

                          # prng = Random.new
                          variables = {}
                          response = Textgen.generate_string(json['templates'], json['parts'], variables)

                          event.respond(response)
                        })
      if YuukiBot.config['verbose']
        puts 'Added fun command for random question!'
      end

      $cbot.add_command(:nextzeldagame,
                        code: proc { |event|
                          json = JSON.parse(File.read('text/Other/JSON/nextzeldagame.json'))

                          prng = Random.new
                          variables = {}
                          variables['random_number'] = prng.rand(1..10)
                          response = Textgen.generate_string(json['templates'], json['parts'], variables)

                          event.respond(response)
                        })
      puts 'Added fun command for nextzeldagame!' if YuukiBot.config['verbose']

      $cbot.add_command(:confucious,
                        code: proc { |event, _|
                          event.respond("Confucious say #{File.readlines('text/Jokes/confucious.txt').sample.chomp}")
                        })
      puts 'Added jokes command for confucious!' if YuukiBot.config['verbose']

      $cbot.add_command(:bookpun,
                        code: proc { |event, _|
                          title, author = File.readlines('text/Jokes/bookpun.txt').sample.chomp.split ': ', 2
                          event.respond("#{title} by #{author}")
                        })
      puts 'Added jokes command for bookpun!' if YuukiBot.config['verbose']

      $cbot.add_command(:wouldyourather,
                        code: proc { |event, _|
                          json_string = open('http://rrrather.com/botapi').read
                          array = JSON.parse(json_string, symbolize_names: true)
                          event.respond("#{array[:title]}: #{array[:choicea].rstrip} OR #{array[:choiceb].rstrip}")
                        })
      puts 'Added fun command for wouldyourather!' if YuukiBot.config['verbose']

      $cbot.add_command(:fact,
                        code: proc { |_, _|
                          types = %w[trivia math date year]
                          type = types.sample
                          open("http://numbersapi.com/random/#{type}").read
                        })
      puts 'Added fun command for fact!' if YuukiBot.config['verbose']

      $cbot.add_command(:eightball,
                        code: proc { |event, _|
                          event.respond("shakes the magic 8 ball... **#{File.readlines('text/Other/8ball_responses.txt').sample.chomp}**")
                        })
      puts 'Added fun command for eightball!' if YuukiBot.config['verbose']

      $cbot.add_command(:cats,
                        code: proc { |event, _|
                          json_string = open('https://catfacts-api.appspot.com/api/facts').read
                          array = JSON.parse(json_string, symbolize_names: true)
                          event.respond(array[:facts][0].to_s)
                        })
      puts 'Added fun command for cats!' if YuukiBot.config['verbose']

      $cbot.add_command(:catgifs,
                        code: proc { |event, _|
                          gif_url = nil
                          open('http://marume.herokuapp.com/random.gif') do |resp|
                            gif_url = resp.base_uri.to_s
                          end
                          event.respond("OMG A CAT GIF: #{gif_url}")
                        })
      puts 'Added fun command for catgifs!' if YuukiBot.config['verbose']

      $cbot.add_command(:fight,
                        code: proc { |event, args|
                          target_guess = event.bot.parse_mention(args.join(' '))
                          target = if args.nil? || (args == [])
                                     event.user.name
                                   elsif target_guess.nil?
                                     args.join(' ')
                                   else
                                     target_guess.name
                                   end

                          json = JSON.parse(File.read('text/Attack/JSON/fight.json'))

                          variables = {}
                          variables['user'] = event.user.name
                          variables['target'] = target
                          response = Textgen.generate_string(json['templates'], json['parts'], variables)

                          event.respond(response)
                        })
      puts 'Added fun command for fight!' if YuukiBot.config['verbose']
    end

    $cbot.add_command(:choose,
                      code: proc { |event, args|
                        event.respond("I choose #{args.sample}!")
                      })
  end
end
