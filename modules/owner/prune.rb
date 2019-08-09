# Copyright Erisa Arrowsmith (Seriel) 2016-2017
module YuukiBot
  module Owner

    $cbot.add_command(:prune,
      code: proc { |event, args|
        num = args[0]
        num = 75 if num.nil?
        @count = 0
        msgs = []
        msg = event.channel.send("#{YuukiBot.config['emoji_loading']} Deleting, please wait...")
        if event.bot.profile.on(event.server).permission?(:manage_messages,event.channel)
          event.channel.history(num).each do |x|
            if x.author.id == event.bot.profile.id && x.id != msg.id
              msgs.push(x.id)
              @count += 1
            end
          end
          Discordrb::API::Channel.bulk_delete_messages(event.bot.token, event.channel.id, msgs) unless @count.zero?
        else
          event.channel.history(num).each do |x|
            if x.author.id == event.bot.profile.id && x.id != msg.id
              x.delete
              @count += 1
            end
          end
        end
        if !@count.zero?
          msg.edit("#{YuukiBot.config['emoji_tickbox']} Pruned #{@count} bot messages!")
        else
          msg.edit("#{YuukiBot.config['emoji_warning']} No messages found!")
        end

      },
      triggers: %w(prune cleanup purge stfu ),
      required_permissions: [:manage_messages],
      owner_override: true,
      # owners_only: true,
      max_args: 1
    )

    # noinspection RubyResolve
    $cbot.add_command(:pruneuser,
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
          event.respond("#{YuukiBot.config['emoji_tickbox']} Pruned #{count} messages by **#{user.distinct}** !")
        rescue Discordrb::Errors::NoPermission
          event.respond("#{YuukiBot.config['emoji_error']} I don't have permission to delete messages!")
          puts 'The bot does not have the delete message permission!'
        end
      },
      triggers: [
        'pruneuser',
        'cleanupuser',
        'purgeuser',
        'cleanup user',
        'purge user',
      ],
      required_permissions: [:manage_messages],
      owner_override: true,
      max_args: 1
    )
  end
end
