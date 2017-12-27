# Copyright Erisa Komuro (Seriel) 2016-2017
module YuukiBot
  module Owner

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
            userdata = DB.execute("SELECT * FROM `userlist` WHERE `id` = #{user.id}")
            if userdata == []
              DB.execute("INSERT INTO userlist (id, is_owner, is_donator, ignored) VALUES (#{user.id}, 0, 0, 1); ")
            else
              DB.execute("UPDATE userlist SET ignored = 1 WHERE id = #{user.id};")
            end
            event.bot.ignore_user(user)
            event.respond("#{YuukiBot.config['emoji_tickbox']} #{user.mention} is now being ignored!")
          rescue
            event.respond("#{YuukiBot.config['emoji_error']} Error occured, is `#{mention}` a valid use?")
          end
        }
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
        args.each { |x|
          user = begin
            event.bot.parse_mention(x)
          rescue
            event.respond("#{YuukiBot.config['emoji_error']} `#{mention}` is not a valid user!")
          end
          begin
            userdata = DB.execute("SELECT * FROM `userlist` WHERE `id` = #{user.id}")
            if userdata == []
              DB.execute("INSERT INTO userlist (id, is_owner, is_donator, ignored) VALUES (#{user.id}, 0, 0, 0); ")
            else
              DB.execute("UPDATE userlist SET ignored = 0 WHERE id = #{user.id};")
            end
            event.bot.unignore_user(user)
            event.respond("#{YuukiBot.config['emoji_tickbox']} #{user.distinct} has been removed from the ignore list!")
          rescue
            event.respond("#{YuukiBot.config['emoji_error']} `#{mention}` is not a valid user!")
            break
          end
        }
      },
      owners_only: true
    )

  end
end
