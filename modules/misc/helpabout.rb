# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020
module YuukiBot
  module Misc
    YuukiBot.crb.add_command(
      :help,
      code: proc { |event, _|
        event << "Hello! I am #{event.bot.profile.username} `#{YuukiBot.version}`"
        event << if YuukiBot.config['show_help']
                   "Follow this link for basic help: ** 🔗 #{YuukiBot.config['help_url']}**"
                 else
                   'Unfortunately, no command help can be shown. Please contact the bot owner.'
                 end
        if YuukiBot.config['show_support']
          event << "\n You can also join our support server for realtime help: " \
                   "** 🔗 <#{YuukiBot.config['support_server']}>**"
        end
        if YuukiBot.config['show_invite']
          invite_url = if YuukiBot.config['invite_url'] == 'nil'
                         event.bot.invite_url
                       else
                         YuukiBot.config['invite_url']
                       end
          event << "\n Or if you're looking to invite me to your server, you can do it here: " \
          "** 🔗 <#{invite_url}>**"
        end
      },
      triggers: %w[help support commands invite]
    )
  end
end
