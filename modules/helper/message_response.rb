# frozen_string_literal: true

module Discordrb
  module Events
    class MessageEvent
      # Responds with the configured success emoji and a given message.
      #
      # @param [String] message The message to show alongside success.
      def success(message)
        respond("#{YuukiBot.config['emoji_tickbox']} #{message}")
      end

      # Responds with the configured error emoji and a given message.
      #
      # @param [String] message The message to show alongside the error.
      def failure(message)
        respond("#{YuukiBot.config['emoji_error']} #{message}")
      end
    end

    class ApplicationCommandEvent
      # Responds with the configured success emoji and a given message.
      #
      # @param [String] message The message to show alongside success.
      def success(message)
        respond("#{YuukiBot.config['emoji_tickbox']} #{message}")
      end

      # Responds with the configured error emoji and a given message.
      #
      # @param [String] message The message to show alongside the error.
      def failure(message)
        respond("#{YuukiBot.config['emoji_error']} #{message}")
      end
    end
  end
end
