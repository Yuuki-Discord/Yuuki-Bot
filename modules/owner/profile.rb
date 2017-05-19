# Copyright Seriel 2016-2017
module YuukiBot
  module Owner

    Commandrb.commands[:setavatar] = {
      code: proc { |event, args|
        url = args.join(' ')
        event.bot.profile.avatar = File.open(Helper.download_file(url, 'tmp'))
        event.respond('✅ Avatar should be updated!')
      },
      owners_only: true,
    }

    Commandrb.commands[:setgame] = {
      code: proc { |event, args|
        event.bot.game = args.join(' ')
        event.respond("✅ Game set to `#{event.bot.game}`!")
      },
      triggers: %w(game setgame),
      owners_only: true,
    }

    Commandrb.commands[:username] = {
      code: proc { |event, args|
        username = args.join(' ')
        event.bot.profile.name = begin
          username
        rescue
          event.respond('An error has occured!')
        end
        event.respond('✅ Username should be updated!')
      },
      triggers: %w(username setusername setname),
      owners_only: true,
    }

  end
end
