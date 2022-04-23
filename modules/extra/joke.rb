# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe), spotlight_is_ok, Larsenv 2017-2020
module YuukiBot
  module Extra
    YuukiBot.crb.add_command(
      :dance,
      arg_format: {
        text: { name: 'text', description: 'Text to dance', type: :remaining }
      }
    ) do |event, args|
      letters = YAML.load_file('config/dancingletters.yml')
      event.respond(args.text.downcase.gsub(/[a-zA-Z0-9@?!&$-]/, letters).to_s)
    end

    YuukiBot.crb.add_command(
      :notice,
      min_args: 1
    ) do |event, args|
      target_guess = event.bot.parse_mention(args.join(' '))
      whom = if args.nil? || (args == []) || (args[0] == 'me')
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
    end
  end
end
