# Copyright Seriel 2016 - 2017
module YuukiBot
  module Misc

    $cbot.add_command(:donators,
       code: proc { |event, args|
         if args[0] == "add"
           user = event.bot.parse_mention(args[1])
           Data.donators.push(user.id)
           event.respond("#{YuukiBot.config['emoji_tickbox']} added #{user.name} to donators!")
         elsif args[0] == "remove"
           user = event.bot.parse_mention(args[1])
            Data.donators.delete(user.id)
           event.respond("#{YuukiBot.config['emoji_tickbox']} removed #{user.name} to donators!")
         end
       },
       owners_only: true
    )

  end
end