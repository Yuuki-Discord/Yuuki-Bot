# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020
module YuukiBot
  module Utility
    YuukiBot.crb.add_command(
      :say,
      triggers: %w[say echo talk repeat],
      min_args: 1,
      owners_only: true
    ) do |event, args|
      message = args.join(' ')
      event.respond(Helper.filter_everyone(message))
    end

    YuukiBot.crb.add_command(
      :speak,
      owners_only: true,
      min_args: 1,
      triggers: %w[speak hide]
    ) do |event, args|
      event.message.delete
      event.respond(args.join(' '))
    end

    # The choose command does not require extra_commands to be enabled.
    YuukiBot.crb.add_command(
      :choose,
      min_args: 1
    ) do |event, args|
      event.respond("I choose #{args.sample}!")
    end
  end
end
