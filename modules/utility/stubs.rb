# Copyright Erisa Arrowsmith 2017

module YuukiBot
  module Utility

    $cbot.add_command(:stubs,
      code: proc { |event, _|
        event.respond('This command has been removed!')
      },
      triggers: %w(zalgo command angry space tell randommovie owner)
    )
  end
end