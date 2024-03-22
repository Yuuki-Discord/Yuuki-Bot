# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe), Spotlight 2016-2020
module YuukiBot
  module Helper
    # Any messages past 2 weeks cannot be deleted.
    # Create a time two weeks and five minutes behind to account for potential
    # inconsistencies from Discord. (None have been observed, and we hope to keep it that way.)
    #
    # @return [Time] The maximum bulk deletion time
    def self.max_bulk_delete_time
      max_bulk_delete_time = Time.now.utc
      # Decrement by 5 minutes (5 times 60 seconds)
      max_bulk_delete_time -= 5 * 60
      # Decrement by 2 weeks (2 groups of 7 days over 24 hours/60 minutes/60 seconds)
      max_bulk_delete_time - (2 * 7 * 24 * 60 * 60)
    end

    # Allows deleting of an amount messages with an optional criteria.
    #
    # @param [Object] event The current event
    # @param [Integer] clear_num The amount of messages to delete.
    # @param [Proc] criteria The proc invoked to determine what messages to handle.
    # If the result of the proc is true, we consider the message to be handled.
    # By default, accepts all messages.
    # @return [Integer] Amount of affected messages.
    def self.delete_messages(event, clear_num, criteria = proc { true })
      raise ArgumentError, 'the number to clear must be positive' if clear_num.negative?

      message_count = 0

      while clear_num.positive?
        bulk_ids = []
        manual_ids = []

        batch_messages = 0

        # We can only potentially bulk-delete messages by 100 at a time.
        # Set our current loop's artificial limit.
        # See https://discordapp.com/developers/docs/resources/channel#bulk-delete-messages
        to_clear = [clear_num, 100].min

        # Sort messages between being available for bulk and manual per-message deletion.
        event.channel.history(to_clear).each do |msg|
          # Ensure the message meets our specified criteria.
          criteria_result = criteria.call(msg)
          next if criteria_result.nil? || criteria_result != true

          # If the message is younger than two weeks, it should be bulk.
          if msg.timestamp > max_bulk_delete_time
            bulk_ids.push(msg.id)
          else
            manual_ids.push(msg.id)
          end

          batch_messages += 1
        end

        # We cannot call the bulk deletion endpoint with one message.
        # Convert the message matching this condition to a manual message.
        if bulk_ids.length == 1
          manual_ids = bulk_ids
          bulk_ids = []
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

      # Return affected messages count.
      message_count
    end
  end
end
