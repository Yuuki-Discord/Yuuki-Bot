# Copyright Erisa Komuro (Seriel) 2016-2017
module YuukiBot
  module Owner

    $cbot.add_command(:save,
      code: proc { |event, _|
        message = event.respond 'Saving...'
        message.edit('All saved!')
      },
      triggers: ['save'],
      owners_only: true
    )

    $cbot.add_command(:shutdown,
      code: proc { |event, _|
        event.bot.invisible
        event.respond('Goodbye!')
        Helper.quit(0)
      },
      triggers:     ['shutdown', 'bye', 'fuck off', 'die', 'kys', 'go away'],
      owners_only:  true,
      description:  'Shuts down the bot. Owner only.',
      catch_errors: false
    )

    $cbot.add_command(:reboot,
      code: proc { |event, _|
        event.respond 'Rebooting...!'
        Helper.quit(1)
      },
      triggers: ['reboot' 'restart' 'reload' 'gtfo', 'machine 🅱roke', '🅱achine 🅱roke'],
      owners_only:  true,
      description:  'Shuts down the bot. Owner only.',
      catch_errors: false
    )

  end
end
