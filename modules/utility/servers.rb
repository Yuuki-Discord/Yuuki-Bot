# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2019-2020
module YuukiBot
  module Utility
    $cbot.add_command(
      :servers,
      code: proc { |event, _args|
        event.respond "🏠 | I am in **#{event.bot.servers.count}** servers!"
      }
    )
  end
end
