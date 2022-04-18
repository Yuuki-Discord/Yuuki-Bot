# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2019-2020
module YuukiBot
  module Utility
    YuukiBot.crb.add_command(:servers) do |event|
      event.respond "🏠 | I am in **#{event.bot.servers.count}** servers!"
    end
  end
end
