# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe), spotlight_is_ok, Larsenv 2017-2020
module YuukiBot
  module Extra
    text_joke_commands = %w[doit pun wisdom lawyerjoke]
    text_joke_commands.each do |x|
      YuukiBot.crb.add_command(
        x.to_sym,
        code: proc { |event|
          result = File.readlines("text/Jokes/#{x}.txt").sample.chomp
          event.respond("\\*#{result}*")
        }
      )
    end

    text_other_commands = %w[vote topicchange fortunes factdiscord randomssmash4item]
    text_other_commands.each do |x|
      YuukiBot.crb.add_command(
        x.to_sym,
        code: proc { |event|
          result = File.readlines("text/Other/Text/#{x}.txt").sample.chomp
          event.respond(result.to_s)
        },
        min_args: 1
      )
    end

    YuukiBot.crb.add_command(
      :confucius,
      code: proc { |event, _|
        event.respond("Confucious say #{File.readlines('text/Jokes/confucious.txt').sample.chomp}")
      },
      min_args: 1
    )

    YuukiBot.crb.add_command(
      :dance,
      code: proc { |event, args|
        letters = YAML.load_file('config/dancingletters.yml')
        event.respond(args.join(' ').downcase.gsub(/[a-zA-Z0-9@?!&$-]/, letters).to_s)
      },
      min_args: 1
    )

    YuukiBot.crb.add_command(
      :notice,
      code: proc { |event, args|
        target_guess = event.bot.parse_mention(args.join(' '))
        target = if args.nil? || (args == []) || (args[0] == 'me')
                   event.user.name
                 elsif target_guess.nil?
                   args.join(' ')
                 else
                   target_guess.name
                 end

        if args.length >= 2 && args[1] == 'senpai'
          event.respond("\\*Senpai notices #{whom}*")
        else
          event.respond("\\*notices #{whom}*")
        end
      },
      min_args: 1
    )
  end
end
