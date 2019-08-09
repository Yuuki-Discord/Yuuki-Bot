# Copyright Erisa Arrowsmith 2016 - 2017
module YuukiBot
  module Misc

    $cbot.add_command(:about,
      code: proc { |event, _|
        event << "`#{event.bot.user(event.bot.profile.id).distinct}` running **YuukiBot v#{$version}** "
        event << "**#{YuukiBot.config['source_url']}** " if YuukiBot.config['show_source']
        event << "\n ⚙ Extra commands: **#{YuukiBot.config['extra_commands'] ? 'Enabled' : 'Disabled'}**"
        if YuukiBot.config['show_donate_urls']
          event << "\n:moneybag: Hey, making bots and hosting them isn't free. If you want this bot to stay alive, consider giving some :dollar: to the devs: "
          YuukiBot.config['donate_urls'].each {|url| event << "- #{url}" }
          event << "\n__**Donators :heart:**__ (aka the best people ever)"
          donators = DB.execute("select id from userlist where is_donator=1").map {|v| v[0]}
          if donators.length > 0
            donators.each {|x|
              event.bot.user(x).nil? ? event << "Unknown User (ID: `#{x}`)" : event << "`- **#{event.bot.user(x).distinct}**"
            }
          else
            event << 'None! You can be the first! :)'
          end
        end
      }
    )

    $cbot.add_command(:owner,
      code: proc {|event, args|
        begin
         id = args[0].nil? ? event.server.id : args[0]
         event.respond("👤 Owner of server `#{event.bot.server(id).name}` is **#{event.bot.server(id).owner.distinct}** | ID: `#{event.bot.server(id).owner.id}`")
        rescue
          event.respond(" 😦 I'm not in that server!")
        end
      },
      server_only: true
    )

    $cbot.add_command(:help,
      code: proc {|event, _|
        event << (YuukiBot.config['show_help'] ? "Follow this link for basic help: ** 🔗 #{YuukiBot.config['help_url']}**" : 'Unfortunately, no command help can be shown. Please contact the bot owner.')
        event << "\n You can also join our support server for realtime help: ** 🔗 <#{YuukiBot.config['support_server']}>**" if YuukiBot.config['show_support']
        event << "\n Or if you're looking to invite me to  your server, you can do it here: ** 🔗 #{YuukiBot.config['invite_url'] == "nil" ? event.bot.invite_url : "<" + YuukiBot.config['invite_url'] + ">"}**" if YuukiBot.config['show_invite']
      },
      triggers: %w(help support commands invite)
    )

  end
end
