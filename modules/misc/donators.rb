# Copyright Erisa Komuro (Seriel) 2016 - 2017
module YuukiBot
  module Misc

    $cbot.add_command(:donators,
       code: proc { |event, args|
         if args[0] == 'add'
           user = event.bot.parse_mention(args[1])
           Data.donators.push(user.id)
           event.respond("#{YuukiBot.config['emoji_tickbox']} added #{user.name} to donators!")
         elsif args[0] == 'remove'
           user = event.bot.parse_mention(args[1])
            Data.donators.delete(user.id)
           event.respond("#{YuukiBot.config['emoji_tickbox']} removed #{user.name} to donators!")
         end
       },
       owners_only: true
    )

    $cbot.add_command(:doante,
      code: proc {|event,args|
        if YuukiBot.config['show_donate_urls']
          event << ":moneybag: Hey, making bots and hosting them isn't free. If you want this bot to stay alive, consider giving some :dollar: to the devs: "
          YuukiBot.config['donate_urls'].each {|url| event << "- #{url}" }
          event << '__**Donators :heart:**__ (aka the best people ever)'
          if Data.donators.length > 0
            Data.donators.each {|x|
              event << "- **#{event.bot.user(x).distinct}**"
            }
          else
            event << 'None! You can be the first! :)'
          end
        else
          event << 'Sorry, donation information has been disabled for this bot instance!'
          event << 'Please contact the bot owner for more information.'
        end
      },
      triggers: ['donate', 'donateinfo', 'how do i donate', 'how do i donate?', 'how do I donate', 'how do I donate?']
    )

  end
end
