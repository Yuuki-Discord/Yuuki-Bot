# Copyright Erisa Komuro (Seriel) 2016-2017
module YuukiBot
  module Owner

    # noinspection RubyResolve
    $cbot.add_command(:ignore,
      code: proc { |event, args|
        event.respond("#{YuukiBot.config['emoji_error']} Mention valid user(s)!") if args == []
        args.each { |x|
          mention = args[0]
          user = begin
            event.bot.parse_mention(x)
          rescue
            event.respond("#{YuukiBot.config['emoji_error']} `#{mention}` is not a valid user!")
            break
          end
          begin
            event.bot.ignore_user(user)
          rescue
            event.respond("#{YuukiBot.config['emoji_error']} `#{mention}` is not a valid user!")
          end
          event.respond("#{YuukiBot.config['emoji_tickbox']} #{user.mention} has been temporarily ignored!")
        }
      },
      triggers: %w(ignore blacklist),
      owners_only: true
    )

    $cbot.add_command(:unignore,
      code: proc { |event, args|
        if args == []
          event.respond("#{YuukiBot.config['emoji_error']} Mention valid user(s)!")
          next
        end
        args.each { |x|
          user = begin
            event.bot.parse_mention(x)
          rescue
            event.respond("#{YuukiBot.config['emoji_error']} `#{mention}` is not a valid user!")
          end
          begin
            event.bot.unignore_user(user)
          rescue
            event.respond("#{YuukiBot.config['emoji_error']} `#{mention}` is not a valid user!")
            break
          end
          event.respond("#{YuukiBot.config['emoji_tickbox']} #{user.mention} has been removed from the ignore list!")
        }
      },
      owners_only: true
    )

  end
end
