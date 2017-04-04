# Copyright Seriel 2017

module YuukiBot
  module Utility

    Commandrb.commands[:stubs] = {
      code: proc { |event, _|
        event.respond('This command has been removed!')
      },
      triggers: %w(zalgo command angry space tell)
    }
  end
end