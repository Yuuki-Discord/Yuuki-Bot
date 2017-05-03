# Copyright Seriel 2016-2017
module YuukiBot
  module Owner

    # noinspection RubyResolve,RubyResolve
    Commandrb.commands[:save] = {
      code: proc { |event, _|
        message = event.respond 'Saving...'
        Helper.save_settings
        message.edit('All saved!')
      },
      triggers: ['save'],
      owners_only: true,
    }


    # noinspection RubyResolve,RubyResolve
    Commandrb.commands[:shutdown] = {
      code: proc { |event, args|
        message = event.respond 'Saving and exiting... '
        #Helper.save_settings
        event.bot.invisible
        message.edit('All saved. Goodbye!')
        Helper.quit
      },
      triggers:     ['shutdown', 'bye', 'fuck off', 'die', 'kys'],
      owners_only:  true,
      errors: ['nuu, you can\'t tell me what to do >:O'],
      description:  'Shuts down the bot. Owner only.',
    }

  end
end
