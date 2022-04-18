# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020
module YuukiBot
  module Owner
    YuukiBot.crb.add_command(
      :prune,
      triggers: %w[prune cleanup purge stfu],
      required_permissions: [:manage_messages],
      owner_override: true,
      max_args: 1
    ) do |event, args|
      delete_num = 75
      count = 0

      loading = YuukiBot.config['emoji_loading']
      info_msg = event.channel.send("#{loading} Deleting, please wait...")

      if event.bot.profile.on(event.server).permission?(:manage_messages,
                                                        event.channel)
        count = Helper.delete_messages(event, delete_num, proc { |x|
          # Ensure we only select messages from ourself.
          next if x.author.id != event.bot.profile.id
          # Do not delete our information message.
          next if x.id == info_msg.id

          true
        })
      else
        event.channel.history(delete_num).each do |x|
          if x.author.id == event.bot.profile.id && x.id != info_msg.id
            x.delete
            count += 1
          end
        end
      end

      edit_string = if count.zero?
                      "#{YuukiBot.config['emoji_warning']} No messages found!"
                    else
                      "#{YuukiBot.config['emoji_tickbox']} Pruned #{count} bot messages!"
                    end
      info_msg.edit(edit_string)

      if args[0] == '-f'
        sleep 2
        info_msg.delete
      end
    end
  end
end
