# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020
module YuukiBot
  module Misc
    $cbot.add_command(
      :help,
      code: proc { |event, _|
        event << (YuukiBot.config['show_help'] ? "Follow this link for basic help: ** 🔗 #{YuukiBot.config['help_url']}**" : 'Unfortunately, no command help can be shown. Please contact the bot owner.')
        if YuukiBot.config['show_support']
          event << "\n You can also join our support server for realtime help: ** 🔗 <#{YuukiBot.config['support_server']}>**"
      end
        if YuukiBot.config['show_invite']
          event << "\n Or if you're looking to invite me to  your server, you can do it here: ** 🔗 #{YuukiBot.config['invite_url'] == 'nil' ? event.bot.invite_url : '<' + YuukiBot.config['invite_url'] + '>'}**"
      end
      },
      triggers: %w[help support commands invite]
    )
  end
end
