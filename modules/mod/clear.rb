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

        clear_num = args[0].to_i

        # We have a limit of 1000.
        if clear_num > 1000
          event.respond('The maximum number of messages I can clear is 1000!')
          next
        end

        # We ignore the response and invocation message. Ignore these messages.
        clear_num += 2

        warning = YuukiBot.config['emoji_warning']
        info_msg = event.respond("#{warning} Due to rate limits, deletion may take a while.")

        begin
          # Our criteria must be that we do not delete our info message or the invoking message.
          message_count = Helper.delete_messages(event, clear_num, proc { |m|
            next if m.id == event.message.id
            next if m.id == info_msg.id

            true
          })
        rescue Discordrb::Errors::NoPermission
          info_msg.edit("#{YuukiBot.config['emoji_error']} Message delete failed!\n" \
                        'Check the permissions?')
          next
        end

        info_msg.edit("#{YuukiBot.config['emoji_clear']} Cleared #{message_count} messages!\n" \
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
