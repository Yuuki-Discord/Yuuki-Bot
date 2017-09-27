# Copyright Erisa Komuro (Seriel) 2016-2017
module YuukiBot
  module Owner

    $cbot.add_command(:set,
      code: proc { |event, args|
        case args[0].downcase
          when 'avatar' || 'avy' then
            url = args.join(' ')
            begin
              event.bot.profile.avatar = File.open(Helper.download_file(url, 'tmp'))
            rescue Exception => e
            end

              event.respond("#{YuukiBot.config['emoji_tickbox']} Avatar should be updated!")
          when 'dnd' then event.bot.dnd
          when 'online' then event.bot.online
          when 'invisible' || 'offline' then event.bot.invisible
          else
            event.respond('Enter a valid argument!')
            next
        end
      },
      owners_only: true
    )

    $cbot.add_command(:setgame,
      code: proc { |event, args|
        event.bot.game = args.join(' ')
        event.respond("#{YuukiBot.config['emoji_tickbox']} Game set to `#{args.join(' ')}`!")
      },
      triggers: %w(game setgame),
      owners_only: true
    )

    $cbot.add_command(:username,
      code: proc { |event, args|
        username = args.join(' ')
        event.bot.profile.name = begin
          username
        rescue
          event.respond('An error has occured!')
        end
        event.respond("#{YuukiBot.config['emoji_tickbox']} Username should be updated!")
      },
      triggers: %w(username setusername setname),
      owners_only: true
    )

  end
end
