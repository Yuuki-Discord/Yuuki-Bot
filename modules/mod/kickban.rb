# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020

module YuukiBot
  module Mod
    YuukiBot.crb.add_command(
      :kick,
      description: 'Kick a user from the server, if you have permission.',
      required_permissions: [:kick_members],
      owner_override: false,
      server_only: true,
      arg_format: {
        user: { name: 'user', description: 'User to kick', type: :user },
        reason: { name: 'reason', description: 'Reason', type: :remaining, optional: true }
      }
    ) do |event, args|
      error = YuukiBot.config['emoji_error']

      member = args.user
      reason = args.reason

      if !Helper.allowed_to_mod(event.bot.profile.on(event.server),
                                member.on(event.server))
        event << "#{error} I don't have permission to kick that user!"
        next
      elsif !Helper.allowed_to_mod(event.user, member.on(event.server))
        event << "#{error} You don't have permission to kick that user!"
        next
      end

      # Attempt to warn the user.
      author = event.user
      user_message = "You have been kicked from the server **#{event.server.name}** " \
                     "by #{author.mention} | **#{author.display_name}**\n" \
                     "They gave the following reason: ``#{reason}``"
      begin
        member.pm(user_message)
      rescue Discordrb::Errors::NoPermission
        event << "#{YuukiBot.config['emoji_warning']} Failed to DM user about kick reason. " \
                 'Kicking anyway...'
      end

      begin
        event.server.kick(member)
      rescue Discordrb::Errors::NoPermission
        event << "#{error} I don't have permission to kick that user!\n"
        next
      end
      event << " #{YuukiBot.config['emoji_success']} #{member.name} has been ejected."
    end

    YuukiBot.crb.add_command(
      :ban,
      description: 'Ban a user from the server, if you have permission.',
      triggers: %w[ban],
      required_permissions: [:ban_members],
      owner_override: false,
      server_only: true,
      arg_format: {
        user: { name: 'user', description: 'User to ban', type: :user },
        reason: { name: 'reason', description: 'Reason', type: :remaining, optional: true }
      }
    ) do |event, args|
      error = YuukiBot.config['emoji_error']

      member = args.user
      reason = args.reason

      if !Helper.allowed_to_mod(event.bot.profile.on(event.server),
                                member.on(event.server))
        event << "#{error} I don't have permission to ban that user!"
        next
      elsif !Helper.allowed_to_mod(event.user, member.on(event.server))
        event << "#{error} You don't have permission to ban that user!"
        next
      end

      message = "You have been **permanently banned** from the server `#{event.server.name}` " \
                "by #{event.user.mention} | **#{event.user.display_name}**\n" \
                "They gave the following reason: ``#{reason}``\n\n" \
                'If you wish to appeal your ban, please contact this person, or the server owner.'
      begin
        member.pm(message)
      rescue Discordrb::Errors::NoPermission
        event << "#{YuukiBot.config['emoji_warning']} Failed to DM user about ban reason. " \
                 'Banning anyway...'
      end
      begin
        event.server.ban(member)
      rescue Discordrb::Errors::NoPermission
        event << "#{error} I don't have permission to ban that user!\n" \
                 'Cancelling ban...'
        next
      end
      event << "#{YuukiBot.config['emoji_success']} The banhammer was hit on #{member.name}!"
    end
  end
end
