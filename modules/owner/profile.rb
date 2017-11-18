# Copyright Erisa Komuro (Seriel) 2016-2017
module YuukiBot
  module Owner
    
    $cbot.add_command(:set,
      code: proc {|event,args|
        case args[0].downcase
        when 'avatar' || 'avy'
          url = args.drop(1).join(' ')
          event.bot.profile.avatar = File.open(Helper.download_file(url, 'tmp'))
        when 'game' || 'playing'
          event.bot.game = args.join(' ')
          event.respond("#{YuukiBot.config['emoji_tickbox']} Game set to `#{args.drop(1).join(' ')}`!")
        when 'username' || 'name'
            username = args.drop(1).join(' ')
          event.bot.profile.name = begin
            username
          rescue
            event.respond('An error has occured!')
          end
          event.respond("#{YuukiBot.config['emoji_tickbox']} Username _should_ be updated!")
        when 'status' || 'indicator'
          state = args[1]
          case state.downcase
          when 'idle' || 'away' || 'afk' then event.bot.idle
          when 'dnd'
            state = 'Do Not Disturb'
          when 'online' then event.bot.online
          when 'invisible' || 'offline' then event.bot.invisible
          else
            event.respond('Enter a valid argument!')
            next
          end
          event.respond("#{YuukiBot.config['emoji_tickbox']} Status set to **#{state.capitalize}**!")
        else
          event.respond("#{YuukiBot.config['emoji_error']} Enter a valid subcommand!'\nValid commands: `avatar`, `game`, `username`, `status`.")
          next
        end
      },
      triggers: %w(set config bot),
      owners_only: true
    )

  end
end
