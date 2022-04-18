# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe), spotlight_is_ok, Larsenv 2017-2020
module YuukiBot
  module Extra
    # Formulate a proper name to respond with for extra commands.
    # @param [Object] event Event containing bot
    # @param [Object] args Arguments passed in the message
    # @return [String] Text safe to identify user with in commands
    def self.calculate_mention(event, args)
      user_parse_guess = event.bot.parse_mention(args.join(' '))
      if args.nil? || (args == [])
        event.user.name
      elsif user_parse_guess.nil?
        # Use the name as provided via arguments, nothing calculated.
        args.join(' ')
      else
        user_parse_guess.name
      end
    end

    YuukiBot.crb.add_command(
      :dance,
      min_args: 1
    ) do |event, args|
      letters = YAML.load_file('config/dancingletters.yml')
      event.respond(args.join(' ').downcase.gsub(/[a-zA-Z0-9@?!&$-]/,
                                                 letters).to_s)
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
