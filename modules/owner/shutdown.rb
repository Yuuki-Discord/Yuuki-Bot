# Copyright Erisa Komuro (Seriel) 2016-2017
module YuukiBot
  module Owner

    # noinspection RubyResolve,RubyResolve
    $cbot.add_command(:save,
      code: proc { |event, _|
        message = event.respond 'Saving...'
        Helper.save_all
        message.edit('All saved!')
      },
      triggers: ['save'],
      owners_only: true
    )

    $cbot.add_command(:shutdown,
      code: proc { |event, _|
        message = event.respond 'Saving and exiting... '
        Helper.save_all
        event.bot.invisible
        message.edit('All saved. Goodbye!')
        Helper.quit(1001)
      },
      triggers:     ['shutdown', 'bye', 'fuck off', 'die', 'kys', 'go away'],
      owners_only:  true,
      errors:       ['nuu, you can\'t tell me what to do >:O', 'I don\'t want to shut down.', 'All saved. Good-On second thought, no.', 'I hate taking naps.', 'You shut me down and I\'ll shut down your computer.'],
      description:  'Shuts down the bot. Owner only.',
      catch_errors: false
    )

    $cbot.add_command(:reboot,
      code: proc { |event, _|
        message = event.respond 'Saving and reloading... '
        Helper.save_all
        event.bot.invisible
        message.edit('All saved. Restarting, please wait...')
        Helper.quit(1002)
      },
      triggers:     ['reboot', 'restart', 'reload', 'gtfo'],
      owners_only:  true,
      errors:       ['nuu, you can\'t tell me what to do >:O', 'I don\'t want to shut down.', 'All saved. Good-On second thought, no.', 'I hate taking naps.', 'You shut me down and I\'ll shut down your computer.'],
      description:  'Shuts down the bot. Owner only.',
      catch_errors: false
    )

  end
end
