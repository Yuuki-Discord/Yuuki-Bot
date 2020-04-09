# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020

module YuukiBot
  module Mod
    YuukiBot.crb.add_command(
      :clear,
      code: proc { |event, args|
        unless /\A\d+\z/ =~ args[0]
          event.respond("`#{args[0]}` is not a valid number!")
          next
        end

        original_num = args[0].to_i
        # Include the user's invoking message
        clear_num = original_num + 1

        message_count = 0

        if clear_num > 1000
          event.respond('The maximum number of messages I can clear is 1000!')
          next
        elsif clear_num >= 100
          warning = YuukiBot.config['emoji_warning']
          event.respond("#{warning} Starting deletion. Due to rate limits, this may take a while.")
          sleep(3)

          # Our warning message increases the amount of messages we need to clean.
          clear_num += 1
        end

        # Any messages past 2 weeks cannot be deleted.
        # Create a time two weeks and five minutes behind to account for potential
        # inconsistencies from Discord. (None have been observed, and we hope to keep it that way.)
        max_bulk_delete_time = Time.now.utc
        # Decrement by 5 minutes (5 times 60 seconds)
        max_bulk_delete_time -= 5 * 60
        # Decrement by 2 weeks (2 groups of 7 days over 24 hours/60 minutes/60 seconds)
        max_bulk_delete_time -= 2 * 7 * 24 * 60 * 60

        begin
          while clear_num.positive?
            bulk_ids = []
            manual_ids = []
            batch_messages = 0

            to_clear = if clear_num > 100
                         # We can only potentially bulk-delete messages by 100 at a time.
                         # Set our current loop's artificial limit.
                         # See https://discordapp.com/developers/docs/resources/channel#bulk-delete-messages
                         100
                       else
                         clear_num
                       end

            # Sort messages between being available for bulk and manual per-message deletion.
            event.channel.history(to_clear).each do |msg|
              # If the message is younger than two weeks, it should be bulk.
              if msg.timestamp > max_bulk_delete_time
                bulk_ids.push(msg.id)
              else
                manual_ids.push(msg.id)
              end

              batch_messages += 1
            end

            unless bulk_ids.empty?
              channel_id = event.channel.id
              Discordrb::API::Channel.bulk_delete_messages(event.bot.token, channel_id, bulk_ids)
            end

            unless manual_ids.empty?
              manual_ids.each do |id|
                event.channel.message(id).delete
              end
            end

            if to_clear > batch_messages
              # The user may have specified more messages than were available.
              clear_num = 0
            else
              # All messages from this batch are now cleared.
              clear_num -= to_clear
            end

            message_count += batch_messages
          end
        rescue Discordrb::Errors::NoPermission
          event.respond("#{YuukiBot.config['emoji_error']} Message delete failed!\n" \
            'Check the permissions?')
          next
        end

        event.respond("#{YuukiBot.config['emoji_clear']} Cleared #{message_count} messages!\n" \
            "Responsible Moderator: #{event.user.mention}\n")
      },
      triggers: %w[clear clean],
      server_only: true,
      required_permissions: [:manage_messages],
      owner_override: false,
      max_args: 1
    )
  end
end
