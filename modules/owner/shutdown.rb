# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020
module YuukiBot
  module Owner
    YuukiBot.crb.add_command(
      :shutdown,
      triggers: ['shutdown', 'bye', 'die', 'go away'],
      owners_only: true,
      text_only: true,
      description: 'Shuts down the bot. Owner only.',
      catch_errors: false
    ) do |event|
      event.bot.invisible
      event.respond('Goodbye!')
      Helper.quit(0)
    end

    YuukiBot.crb.add_command(
      :reboot,
      triggers: ['reboot', 'restart', 'reload', 'gtfo', 'machine 🅱roke',
                 '🅱achine 🅱roke'],
      owners_only: true,
      text_only: true,
      description: 'Shuts down the bot. Owner only.',
      catch_errors: false
    ) do |event|
      event.respond 'Restarting...!'
      Helper.quit(1)
    end
  end
end
