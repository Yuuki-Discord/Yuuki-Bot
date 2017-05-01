# Copyright Seriel 2016 - 2017
module YuukiBot
  module Misc

    Commandrb.commands[:about] = {
      code: proc { |event, _|
        event << "`#{event.bot.user(event.bot.profile.id).distinct}` running **YuukiBot-Git v3-#{`git rev-parse --short HEAD`}** "
        event << "**#{YuukiBot.config['source_url']}** " if YuukiBot.config['show_source']
        event << "\n ⚙ Extra commands: **#{YuukiBot.config['extra_commands'] ? 'Enabled' : 'Disabled'}**"
        if YuukiBot.config['show_donate_urls']
          event << "\n:moneybag: Hey, making bots and hosting them isn't free. If you want this bot to stay alive, consider giving some :dollar: to the devs: "
          YuukiBot.config['donate_urls'].each {|url| event << "- #{url}" }
        end
      }
    }

    Commandrb.commands[:owner] = {
      code: proc {|event, args|
        id = args[0].nil? ? event.server.id : args[0]
        event.respond("👤 Owner of server `#{event.bot.server(id).name}` is **#{event.bot.server(id).owner.distinct}** | ID: `#{event.bot.server(id).owner.id}`")
      },
      server_only: true,
    }

    Commandrb.commands[:help] = {
      code: proc {|event, _|
        event << (YuukiBot.config['show_help'] ? "Follow this link for basic help: ** 🔗 #{YuukiBot.config['help_url']}**" : 'Unfortunately, no command help can be shown. Please contact the bot owner.')
        event << "\n You can also join our support server for realtime help: ** 🔗 <#{YuukiBot.config['support_server']}>**" if YuukiBot.config['show_support']
        event << "\n Or if you're looking to invite me to  your server, you can do it here: ** 🔗 #{YuukiBot.config['invite_url'].nil? ? event.bot.invite_url : YuukiBot.config['invite_url']}**" if YuukiBot.config['show_invite']
      },
      triggers: %w(help support commands invite)
    }

  end
end
