# Copyright Seriel 2016-2017
module YuukiBot
  module Owner

    $cbot.add_command(:setavatar,
      code: proc { |event, args|
        url = args.join(' ')
        event.bot.profile.avatar = File.open(Helper.download_file(url, 'tmp'))
        event.respond("#{YuukiBot.config['emoji_tickbox']} Avatar should be updated!")
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
