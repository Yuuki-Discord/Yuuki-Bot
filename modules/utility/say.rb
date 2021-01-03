# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020
module YuukiBot
  module Utility
    YuukiBot.crb.add_command(
      :say,
      code: proc { |event, args|
        message = args.join(' ')
        event.respond(Helper.filter_everyone(message))
      },
      triggers: %w[say echo talk repeat],
      min_args: 1,
      owners_only: true
    )

    YuukiBot.crb.add_command(
      :speak,
      code: proc { |event, args|
        event.message.delete
        event.respond(args.join(' '))
      },
      owners_only: true,
      min_args: 1,
      triggers: %w[speak hide]
    )

    # The choose command does not require extra_commands to be enabled.
    YuukiBot.crb.add_command(
      :choose,
      code: proc { |event, args|
        event.respond("I choose #{args.sample}!")
      },
      min_args: 1
    )
  end
end
