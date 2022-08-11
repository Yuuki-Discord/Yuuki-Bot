# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020
module YuukiBot
  module Utility
    YuukiBot.crb.add_command(
      :say,
      description: 'Make Yuuki say something!',
      arg_format: {
        message: { name: 'message', description: 'Message to say', type: :remaining }
      },
      triggers: %w[say echo talk repeat],
      owners_only: true
    ) do |event, args|
      event.respond(Helper.filter_everyone(args.message))
    end

    YuukiBot.crb.add_command(
      :speak,
      description: 'Make Yuuki speak! Owner only.',
      owners_only: true,
      text_only: true,
      arg_format: {
        message: { name: 'message', description: 'Message to say', type: :remaining }
      },
      delete_activator: true,
      triggers: %w[speak hide]
    ) do |event, args|
      event.respond(args.message)
    end

    # The choose command does not require extra_commands to be enabled.
    YuukiBot.crb.add_command(
      :choose,
      description: 'Yuuki will make your choices for you!',
      arg_format: {
        message: { name: 'choices', description: 'Choices to consider', type: :remaining }
      }
    ) do |event, args|
      choices = args.message.split
      event.respond("I choose #{choices.sample}!")
    end
  end
end
