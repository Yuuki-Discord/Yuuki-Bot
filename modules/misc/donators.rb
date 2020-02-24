# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020
module YuukiBot
  module Misc
    YuukiBot.crb.add_command(
      :donators,
      code: proc { |event, args|
        if args.empty?
          # Treat as normal donate.
          common_donate(event)
          next
        end
        valid_commands = %w[add remove]
        unless valid_commands.include?(args[0]) || args[1].nil?
          event.respond("#{YuukiBot.config['emoji_error']} Not a valid command! Use me with `add @user` or `remove @user`.")
          next
        end

        user = Helper.userparse(args[1])
        id = begin
          user.id
             rescue StandardError
               event.respond("#{YuukiBot.config['emoji_error']} Not a valid user!")
               next
        end

        donators = begin
          JSON.parse(REDIS.get('donators'))
                   rescue StandardError
                     []
        end

        if args[0] == 'add'
          if donators.include?(id)
            event.respond("#{YuukiBot.config['emoji_error']} User is already a donator!")
            next
          end
          REDIS.set('donators', donators.push(id).to_json)
          event.respond("#{YuukiBot.config['emoji_tickbox']} added `#{Helper.userid_to_string(id)}` to donators!")
        elsif args[0] == 'remove'
          unless donators.include?(id)
            event.respond("#{YuukiBot.config['emoji_error']} User is not a donator!")
            next
          end
          REDIS.set('donators', (donators - [id]).to_json)
          event.respond("#{YuukiBot.config['emoji_tickbox']} removed `#{Helper.userid_to_string(user.id)}` from donators!")
        end
      },
      owners_only: true
    )

    YuukiBot.crb.add_command(
      :donate,
      code: proc { |event, _args|
        common_donate(event)
      },
      triggers: ['donate', 'donateinfo', 'how do i donate', 'how do i donate?', 'how do I donate', 'how do I donate?', 'doante', 'donut']
    )

    def self.common_donate(event)
      if YuukiBot.config['show_donate_urls']
        event << "💰 Hey, making bots and hosting them isn't free. If you want this bot to stay alive, consider giving some 💵 to the devs: "
        YuukiBot.config['donate_urls'].each { |url| event << "- #{url}" }
        event << '__**Donators :heart:**__ (aka the best people ever)'
        donators = begin
  JSON.parse(REDIS.get('donators'))
                   rescue StandardError
                     []
end
        if donators.empty?
          event << 'None! You can be the first! :)'
        else
          donators.each do |x|
            event.bot.user(x).nil? ? event << "- Unknown User (ID: `#{x}`)" : event << "- **#{event.bot.user(x).distinct}**"
          end
        end
      else
        event << 'Sorry, donation information has been disabled for this bot instance!'
        event << 'Please contact the bot owner for more information.'
        end
      end
  end
end
