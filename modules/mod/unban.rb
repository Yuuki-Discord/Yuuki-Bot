# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020

module YuukiBot
  module Mod
    YuukiBot.crb.add_command(
      :unban,
      code: proc { |event, args|
        target_id = args[0]
        target = event.server.bans.select { |x| x.id == target_id }
        if (target == []) || target.nil?
          event.respond("#{YuukiBot.config['emoji_error']} Failed to find user with ID `#{target_id}!`")
          break
        end
        begin
          event.server.unban(target)
        rescue Discordrb::Errors::NoPermission
          event.respond("#{YuukiBot.config['emoji_error']} I don't have permission to unban #{target.name}!")
        end
      },
      max_args: 1,
      server_only: true,
      required_permissions: [:ban_members]
    )
  end
end
