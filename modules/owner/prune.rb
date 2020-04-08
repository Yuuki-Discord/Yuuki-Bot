# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020
module YuukiBot
  module Owner
    YuukiBot.crb.add_command(
      :prune,
      code: proc { |event, args|
        num = 75
        count = 0
        msgs = []
        msg = event.channel.send("#{YuukiBot.config['emoji_loading']} Deleting, please wait...")
        if event.bot.profile.on(event.server).permission?(:manage_messages, event.channel)
          event.channel.history(num).each do |x|
            if x.author.id == event.bot.profile.id && x.id != msg.id
              msgs.push(x.id)
              count += 1
            end
          end
          unless @count.zero?
            Discordrb::API::Channel.bulk_delete_messages(event.bot.token, event.channel.id, msgs)
          end
        else
          event.channel.history(num).each do |x|
            if x.author.id == event.bot.profile.id && x.id != msg.id
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
        msg.edit(edit_string)

        if args[0] == '-f'
          sleep 2
          msg.delete
        end
      },
      triggers: %w[prune cleanup purge stfu],
      required_permissions: [:manage_messages],
      owner_override: true,
      max_args: 1
    )

    YuukiBot.crb.add_command(
      :pruneuser,
      code: proc { |event, args|
        begin
          user = event.bot.parse_mention(args[0])
          num = args[1]
          num = 75 if num.nil?
          count = 0
          msgs = {}
          event.channel.history(num).each do |x|
            if x.author.id == user.id
              msgs.push(x.id)
              count += 1
            end
          end
          Discordrb::API::Channel.bulk_delete_messages(event.bot.token, event.channel.id, msgs)

          tickbox = YuukiBot.config['emoji_tickbox']
          event.respond("#{tickbox} Pruned #{count} messages by **#{user.distinct}** !")
        rescue Discordrb::Errors::NoPermission
          error = YuukiBot.config['emoji_error']
          event.respond("#{error} I don't have permission to delete messages!")
        end
      },
      triggers: [
        'pruneuser',
        'cleanupuser',
        'purgeuser',
        'cleanup user',
        'purge user'
      ],
      required_permissions: [:manage_messages],
      owner_override: true,
      max_args: 1
    )
  end
end
