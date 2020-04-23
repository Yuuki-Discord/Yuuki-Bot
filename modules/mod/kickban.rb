# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020

module YuukiBot
  module Mod
    YuukiBot.crb.add_command(
      :kick,
      code: proc { |event, args|
        error = YuukiBot.config['emoji_error']

        if args.empty?
          event << "#{error} Invalid argument. Please mention a valid user."
          next
        end

        begin
          member = event.bot.parse_mention(args[0])
        rescue StandardError
          event << "#{error} Failed to parse user \"#{args[0]}\"\n" \
            'Did you mention a user?'
          next
        end

        if !Helper.allowed_to_mod(event.bot.profile.on(event.server), member.on(event.server))
          event << "#{error} I don't have permission to kick that user!"
          next
        elsif !Helper.allowed_to_mod(event.user, member.on(event.server))
          event << "#{error} You don't have permission to kick that user!"
          next
        end

        # Attempt to warn the user.
        user_message = "You have been kicked from the server **#{event.server.name}** " \
          "by #{event.message.author.mention} | **#{event.message.author.display_name}**\n" \
          "They gave the following reason: ``#{args.drop(1).join(' ')}``"
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
      },
      required_permissions: [:kick_members],
      owner_override: false,
      server_only: true
    )

    YuukiBot.crb.add_command(
      :ban,
      code: proc { |event, args|
        error = YuukiBot.config['emoji_error']
        if args.empty?
          event << "#{error} Invalid argument. Please mention a valid user."
          next
        end

        member = event.bot.parse_mention(args[0])
        if member.nil?
          event << "#{error} Failed to parse user \"#{args[0]}\"\n" \
           'Did you mention a user?'
          next
        end

        if !Helper.allowed_to_mod(event.bot.profile.on(event.server), member.on(event.server))
          event << "#{error} I don't have permission to ban that user!"
          next
        elsif !Helper.allowed_to_mod(event.user, member.on(event.server))
          event << "#{error} You don't have permission to ban that user!"
          next
        end

        message = "You have been **permanently banned** from the server `#{event.server.name}` " \
          "by #{event.user.mention} | **#{event.user.display_name}**\n" \
          "They gave the following reason: ``#{args.drop(1).join(' ')}``\n\n" \
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
      },
      triggers: %w[ban],
      required_permissions: [:ban_members],
      owner_override: false,
      server_only: true
    )
  end
end
