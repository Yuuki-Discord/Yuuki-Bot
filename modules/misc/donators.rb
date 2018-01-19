# Copyright Erisa Komuro (Seriel) 2016 - 2017
module YuukiBot
  module Misc

    $cbot.add_command(:donators,
       code: proc { |event, args|
         user = Helper.userparse(args[1])
         id = user.id rescue nil
         if args[0] == 'add'
           if user.nil?
             event.respond("#{YuukiBot.config['emoji_error']} Not a valid user!")
             next
           end
           donators = JSON.parse(REDIS.get('donators')) rescue []
           if donators.include?(id)
             event.respond("#{YuukiBot.config['emoji_error']} User is already a donator!")
             next
           end
           REDIS.set('donators', donators.push(id).to_json)
           event.respond("#{YuukiBot.config['emoji_tickbox']} added `#{event.bot.user(id).nil? ? "Unknown User (ID: #{id})" : "#{event.bot.user(id).distinct}"}` to donators!")
         elsif args[0] == 'remove'
           if user.nil?
             event.respond("#{YuukiBot.config['emoji_error']} Not a valid user!")
             next
           end
           donators = JSON.parse(REDIS.get('donators')) rescue []
           unless donators.include?(id)
             event.respond("#{YuukiBot.config['emoji_error']} User is not a donator!")
             next
           end
           REDIS.set('donators', donators.delete(id).to_json)
           event.respond("#{YuukiBot.config['emoji_tickbox']} removed `#{event.bot.user(id).nil? ? "Unknown User (ID: #{id})" : "#{event.bot.user(id).distinct}"}` from donators!")
         else
           if YuukiBot.config['show_donate_urls']
             event << ":moneybag: Hey, making bots and hosting them isn't free. If you want this bot to stay alive, consider giving some :dollar: to the devs: "
             YuukiBot.config['donate_urls'].each {|url| event << "- #{url}" }
             event << '__**Donators :heart:**__ (aka the best people ever)'
             donators = JSON.parse(REDIS.get('donators')) rescue []
             if donators.length > 0
               donators.each {|x|
                 event.bot.user(x).nil? ? event << "- Unknown User (ID: `#{x}`)" : event << "- **#{event.bot.user(x).distinct}**"
               }
             else
               event << 'None! You can be the first! :)'
             end
           else
             event << 'Sorry, donation information has been disabled for this bot instance!'
             event << 'Please contact the bot owner for more information.'
           end
         end
       },
       owners_only: true,
       failcode: proc { |event, _|
         if YuukiBot.config['show_donate_urls']
           event << ":moneybag: Hey, making bots and hosting them isn't free. If you want this bot to stay alive, consider giving some :dollar: to the devs: "
           YuukiBot.config['donate_urls'].each {|url| event << "- #{url}" }
           event << '__**Donators :heart:**__ (aka the best people ever)'
           donators = JSON.parse(REDIS.get('donators')) rescue []
           if donators.length > 0
             donators.each {|x|
               event.bot.user(x).nil? ? event << "- Unknown User (ID: `#{x}`)" : event << "- **#{event.bot.user(x).distinct}**"
             }
           else
             event << 'None! You can be the first! :)'
           end
         else
           event << 'Sorry, donation information has been disabled for this bot instance!'
           event << 'Please contact the bot owner for more information.'
         end
       }
    )

    $cbot.add_command(:donate,
      code: proc {|event,args|
        if YuukiBot.config['show_donate_urls']
          event << ":moneybag: Hey, making bots and hosting them isn't free. If you want this bot to stay alive, consider giving some :dollar: to the devs: "
          YuukiBot.config['donate_urls'].each {|url| event << "- #{url}" }
          event << '__**Donators :heart:**__ (aka the best people ever)'
          donators = DB.execute("select id from userlist where is_donator=1").map {|v| v[0]}
          if donators.length > 0
            donators.each {|x|
              event.bot.user(x).nil? ? event << "- Unknown User (ID: `#{x}`)" : event << "- **#{event.bot.user(x).distinct}**"
            }
          else
            event << 'None! You can be the first! :)'
          end
        else
          event << 'Sorry, donation information has been disabled for this bot instance!'
          event << 'Please contact the bot owner for more information.'
        end
      },
      triggers: ['donate', 'donateinfo', 'how do i donate', 'how do i donate?', 'how do I donate', 'how do I donate?', 'doante']
    )

    $cbot.add_command(:botowners,
      code: proc { |event, args|
        user = Helper.userparse(args[1])
        id = user.id rescue nil
        if user.nil?
          event.respond("#{YuukiBot.config['emoji_error']} Not a valid user!")
        else
          if args[0] == 'add'
            owners = JSON.parse(REDIS.get('owners'))
            if $cbot.is_owner?(id)
              event.respond("#{YuukiBot.config['emoji_error']} User is already an owner!")
              next
            end
            REDIS.set('owners', owners.push(id).to_json)
            event.respond("#{YuukiBot.config['emoji_tickbox']} added `#{event.bot.user(id).nil? ? "Unknown User (ID: #{id})" : "#{event.bot.user(id).distinct}"}` to bot owners!")
          elsif args[0] == 'remove'
            owners = JSON.parse(REDIS.get('owners'))
            unless owners.include?(id)
              event.respond("#{YuukiBot.config['emoji_error']} User is not an owner!")
              next
            end
            if YuukiBot.config['master_owner'] == id
              event.respond("#{YuukiBot.config['emoji_error']} You can't remove the main owner!")
            end
            REDIS.set('owners', owners.delete(id).to_json)
            event.respond("#{YuukiBot.config['emoji_tickbox']} removed `#{event.bot.user(id).nil? ? "Unknown User (ID: #{id})" : "#{event.bot.user(id).distinct}"}` from bot owners!")
          end
        end
      },
      owners_only: true
    )

  end
end
