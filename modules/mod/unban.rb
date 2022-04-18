# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020

module YuukiBot
  module Mod
    YuukiBot.crb.add_command(
      :unban,
      max_args: 1,
      server_only: true,
      required_permissions: [:ban_members]
    ) do |event, args|
      error = YuukiBot.config['emoji_error']

      target_id = args[0]
      # Only one ID should match.
      target_group = event.server.bans.select do |x|
        x.user.id.to_s == target_id
      end
      if (target_group == []) || target_group.nil?
        event.respond("#{error} Failed to find ban for user with ID `#{target_id}!`")
        next
      end

      target_user = target_group[0].user

      begin
        event.server.unban(target_user)
      rescue Discordrb::Errors::NoPermission
        event.respond("#{error} I don't have permission to unban #{target_user.name}!")
        next
      end

      event.respond("#{YuukiBot.config['emoji_success']} Unbanned #{target_user.name}!")
    end
  end
end
