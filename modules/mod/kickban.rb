# Copyright Seriel 2016-2017

module YuukiBot
  module Mod

    Commandrb.commands[:kick] = {
      code: proc { |event, args|
        if !args.empty?
          begin
            member = event.bot.parse_mention(args[0])
          rescue
            event << "❌ Failed to parse user \"#{args[0]}\"\nDid you mention a user?"
            break
          end
          message = "You have been kicked from the server **#{event.server.name}** by #{event.message.author.mention} | **#{event.message.author.display_name}**\n"
          message << "They gave the following reason: ``#{args.drop(1).join(' ')}``"
          begin
            member.pm(message)
          rescue Discordrb::Errors::NoPermission
            event << '⚠ Failed to DM user about kick reason. Kicking anyway...'
          end
          begin
            event.server.kick(member)
          rescue Discordrb::Errors::NoPermission
            event << "❌ I don't have permission to kick that user!\nCancelling Kick..."
            next
          end
          event << " 👌 #{member.name} has been ejected."
        else
          event << '❌ Invalid argument. Please mention a valid user.'
        end
      },
      required_permissions: [:kick_members],
      owner_override: false,
      server_only: true,
    }

    Commandrb.commands[:ban] = {
      code: proc { |event, args|
        if !args.empty?
          begin
            member = event.bot.parse_mention(args[0])
          rescue
            event << "❌ Failed to parse user \"#{args[0]}\"\nDid you mention a user?"
            break
          end
          message = "You have been **permanently banned** from the server `#{event.server.name}` by #{event.message.author.mention} | **#{event.message.author.display_name}**\n"
          message << "They gave the following reason: ``#{args.drop(1).join(' ')}``\n\n"
          message << "If you wish to appeal for your ban's removal, please contact this person, or the server owner."
          begin
            member.pm(message)
          rescue Discordrb::Errors::NoPermission
            event << '⚠ Failed to DM user about ban reason. Banning anyway...'
          end
          begin
            event.server.ban(member)
          rescue Discordrb::Errors::NoPermission
            event << "❌ I don't have permission to ban that user!\nCancelling Ban..."
            next
          end
          event << " 👌 The banhammer was hit on #{member.name}!"
        else
          event << '❌ Invalid argument. Please mention a valid user.'
        end
      },
      triggers: %w(ban),
      required_permissions: [:ban_members],
      owner_override: false,
      server_only: true,
    }

  end
end
