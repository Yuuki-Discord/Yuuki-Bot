# Copyright Erisa Arrowsmith 2016 - 2017
module YuukiBot
  module Misc
    
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
