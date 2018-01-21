# Copyright Erisa Komuro (Seriel) 2016-2017
module YuukiBot
  module Owner

    $cbot.add_command(:ignore,
      code: proc { |event, args|
        event.respond("#{YuukiBot.config['emoji_error']} Mention valid user(s)!") if args == []
        mention = args[0]
        user = Helper.userparse(args[0])
        if user.nil?
          event.respond("#{YuukiBot.config['emoji_error']} Not a valid user!")
          next
        end
        id = user.id
        ignores = JSON.parse(REDIS.get('ignores')) rescue []
        if ignores.include?(id)
          event.respond("#{YuukiBot.config['emoji_error']} User is already ignored!")
          next
        end
        REDIS.set('ignores', ignores.push(id).to_json)
        event.bot.ignore_user(user)
        event.respond("#{YuukiBot.config['emoji_tickbox']} #{user.mention} is now being ignored!")
      },
      triggers: %w(ignore),
      owners_only: true
    )

    $cbot.add_command(:unignore,
      code: proc { |event, args|
        if args == []
          event.respond("#{YuukiBot.config['emoji_error']} Mention valid user(s)!")
          next
        end
        user = Helper.userparse(args[0])
        if user.nil?
          event.respond("#{YuukiBot.config['emoji_error']} Not a valid user!")
          next
        end
        id = user.id
        if $cbot.is_owner?(user)
          event.respond("#{YuukiBot.config['emoji_error']} You can't ignore owners!")
          next
        end
        begin
          ignores = JSON.parse(REDIS.get('ignores')) rescue []
          unless ignores.include?(id)
            event.respond("#{YuukiBot.config['emoji_error']} User isn't ignored!")
            next
          end
          event.bot.unignore_user(user)
          event.respond("#{YuukiBot.config['emoji_tickbox']} #{user.distinct} has been removed from the ignore list!")
        rescue
          event.respond("#{YuukiBot.config['emoji_error']} `#{mention}` is not a valid user!")
          break
        end
      },
      owners_only: true
    )

  end
end
