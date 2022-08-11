# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe), spotlight_is_ok, Larsenv 2017-2020
module YuukiBot
  module Extra
    if YuukiBot.config['extra_commands']
      # List containing defined foods for command usage.
      json_food_commands = %w[beer biscuit brekkie borgar burger cake cereal cheese chicken
                              chocolate coffee cookie donut doobie drinks halal icecream kebab
                              keto kosher milkshake muffin noodles nugget oreo pancake pasta
                              rice sandwich scone snack soup steak sushi taco tea wine pie
                              pizza potato]
      json_food_commands.each do |x|
        YuukiBot.crb.add_command(
          x.to_sym,
          triggers: [x, "give #{x} to ", "give a #{x} to "],
          description: "Gives #{x} to a user!",
          group: :food,
          text_subcommand: true,
          arg_format: {
            user: { name: 'user', description: "User to give #{x} to", type: :user,
                    optional: true, default: :current_user }
          }
        ) do |event, args|
          json = JSON.parse(File.read("text/Food/#{x}.json"))

          variables = { 'user' => args.user.name }
          textgen = Textgen.generate_string(json['templates'], json['parts'], variables)
          event.respond("\\*#{textgen}*")
        end
        puts "Added food command for #{x}!" if YuukiBot.config['verbose']
      end
      YuukiBot.crb.commands[:brekkie][:triggers].push('breakfast', 'brekky', 'give breakfast to ',
                                                      'give a breakfast to', 'give brekky to ',
                                                      'give a brekky to')

      json_attack_commands = %w[slap compliment strax present]
      json_attack_commands.each do |x|
        YuukiBot.crb.add_command(
          x.to_sym,
          group: :attack,
          description: "Give someone a #{x}!",
          text_subcommand: true,
          arg_format: {
            user: { name: 'user', description: "User to give a #{x} to", type: :user,
                    optional: true, default: :current_user }
          }
        ) do |event, args|
          json = JSON.parse(File.read("text/Attack/JSON/#{x}.json"))

          variables = { 'user' => args.user.name }
          textgen = Textgen.generate_string(json['templates'], json['parts'], variables)
          event.respond("\\*#{textgen}*")
        end
        puts "Added attack command for #{x}!" if YuukiBot.config['verbose']
      end

      YuukiBot.crb.add_command(:randomquestion, description: 'Give a random question!') do |event|
        json = JSON.parse(File.read('text/Other/JSON/randomquestion.json'))

        variables = {}
        response = Textgen.generate_string(json['templates'], json['parts'], variables)

        event.respond(response)
      end
      puts 'Added fun command for random question!' if YuukiBot.config['verbose']

      YuukiBot.crb.add_command(:nextzeldagame,
                               description: "What's the next Zelda game?") do |event|
        json = JSON.parse(File.read('text/Other/JSON/nextzeldagame.json'))

        prng = Random.new
        variables = {}
        variables['random_number'] = prng.rand(1..10)
        response = Textgen.generate_string(json['templates'], json['parts'], variables)

        event.respond(response)
      end
      puts 'Added fun command for nextzeldagame!' if YuukiBot.config['verbose']

      YuukiBot.crb.add_command(:wouldyourather,
                               description: 'Shows a Would you Rather question') do |event|
        json_string = URI.open('https://www.rrrather.com/botapi').read
        array = JSON.parse(json_string, symbolize_names: true)
        event.respond("#{array[:title]}: #{array[:choicea].rstrip} OR #{array[:choiceb].rstrip}")
      end
      puts 'Added fun command for wouldyourather!' if YuukiBot.config['verbose']

      YuukiBot.crb.add_command(:fact, description: 'Gives a trivia question!') do |event|
        types = %w[trivia math date year]
        type = types.sample
        event.respond(URI.open("http://numbersapi.com/random/#{type}").read)
      end
      puts 'Added fun command for fact!' if YuukiBot.config['verbose']

      YuukiBot.crb.add_command(:cats, description: 'Gives a fact about cats.') do |event|
        json_string = URI.open('https://catfact.ninja/fact').read
        array = JSON.parse(json_string, symbolize_names: true)
        event.respond(array[:fact].to_s)
      end

      puts 'Added fun command for cats!' if YuukiBot.config['verbose']
      YuukiBot.crb.add_command(:catgifs, description: 'Cat gifs!!!') do |event|
        gif_url = nil
        URI.open('https://marume.herokuapp.com/random.gif') do |resp|
          gif_url = resp.base_uri.to_s
        end
        event.respond("OMG A CAT GIF: #{gif_url}")
      end
      puts 'Added fun command for catgifs!' if YuukiBot.config['verbose']

      YuukiBot.crb.add_command(
        :fight,
        description: 'Fight a user!',
        arg_format: {
          user: { name: 'user', description: 'User to fight', type: :user,
                  optional: true, default: :current_user }
        }
      ) do |event, args|
        json = JSON.parse(File.read('text/Attack/JSON/fight.json'))

        variables = {}
        variables['user'] = event.user.name
        # The user can fight the user. True ingenuity.
        variables['target'] = args.user.name
        response = Textgen.generate_string(json['templates'],
                                           json['parts'], variables)

        event.respond(response)
      end
      puts 'Added fun command for fight!' if YuukiBot.config['verbose']
    end
  end
end
