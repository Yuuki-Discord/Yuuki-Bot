# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020

module YuukiBot
  module Mod
    YuukiBot.crb.add_command(
      :unban,
      description: 'Unban a user from the server, if you have permission.',
      max_args: 1,
      server_only: true,
      required_permissions: [:ban_members],
      arg_format: {
        user: { name: 'user', description: 'User to unban', type: :user }
      }
    ) do |event, args|
      error = YuukiBot.config['emoji_error']

      target_user = args.user
      target_id = target_user.id

      # Ensure the user in question is banned.
      target_group = event.server.bans.select do |x|
        x.user.id.to_s == target_id
      end
      if (target_group == []) || target_group.nil?
        event.respond("#{error} Failed to find ban for user with ID `#{target_id}!`")
        next
      end

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
