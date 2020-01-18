# Copyright Erisa A. (erisa.moe) 2016-2020
module YuukiBot
  module Owner
    
    $cbot.add_command(:set,
      code: proc {|event,args|
        if args.length.zero?
          event.respond("#{YuukiBot.config['emoji_error']} Enter a valid subcommand!\nValid commands: `avatar`, `game`, `username`, `status`, `nickname`.")
        else
          case args[0].downcase
          when 'nick', 'nickname'
            begin
              event.bot.profile.on(event.server).nickname = args.drop(1).join(' ')
              event.respond("#{YuukiBot.config['emoji_tickbox']} Nickname changed to `#{args.drop(1).join(' ')}`")
            rescue Discordrb::Errors::NoPermission
              event.respond("#{YuukiBot.config['emoji_error']} I don't have permission to change my nickname!")
            end
          when 'avatar', 'avy'
            url = args.drop(1).join(' ')
            event.bot.profile.avatar = File.open(Helper.download_file(url, 'tmp'))
          when 'game', 'playing'
            event.bot.game = args.drop(1).join(' ')
            event.respond("#{YuukiBot.config['emoji_tickbox']} Game set to `#{args.drop(1).join(' ')}`!")
          when 'username', 'name'
              username = args.drop(1).join(' ')
            event.bot.profile.name = begin
              username
            rescue Error => e
              event.respond("#{YuukiBot.config['emoji_error']} An error has occured!\n```ruby\n#{e}```")
            end
            event.respond("#{YuukiBot.config['emoji_tickbox']} Username _should_ be updated!")
          when 'status', 'indicator', 'state'
            state = args[1]
            case state.downcase
            when 'idle', 'away', 'afk' then event.bot.idle
            when 'dnd'
              state = 'Do Not Disturb'
            when 'online' then event.bot.online
            when 'invisible', 'offline' then event.bot.invisible
            else
              event.respond('Enter a valid argument!')
              next
            end
            event.respond("#{YuukiBot.config['emoji_tickbox']} Status set to **#{state == 'Do Not Disturb' ? state : state.capitalize }**!")
          else
            event.respond("#{YuukiBot.config['emoji_error']} Enter a valid subcommand!\nValid commands: `avatar`, `game`, `username`, `status`, `nickname`.")
            next
          end
        end
      },
      triggers: %w(set config),
      owners_only: true
    )
    
    $cbot.add_command(:reset,
      code: proc {|event,args|
        case args[0].downcase
          when 'nick' || 'nickname'
            begin
              event.bot.profile.on(event.server).nickname = nil
              event.respond("#{YuukiBot.config['emoji_tickbox']} Reset nickname!")
            rescue Discordrb::Errors::NoPermission
              event.respond("#{YuukiBot.config['emoji_error']} I don't have permission to change my nickname!")
            end
          when 'avatar' || 'avy'
            event.bot.avatar = nil
            event.respond "#{YuukiBot.config['emoji_success']} Reset avatar!"
          when 'game' || 'playing'
            event.bot.game = nil
            event.respond("#{YuukiBot.config['emoji_tickbox']} Reset game!")
          else
            event.respond("#{YuukiBot.config['emoji_error']} Enter a valid subcommand!\nValid commands: `avatar`, `game`, `nickname`.")
            next
        end
      },
      triggers: %w(reset),
      owners_only: true
    )
  end
end
