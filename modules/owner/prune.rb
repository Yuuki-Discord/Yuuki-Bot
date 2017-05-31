# Copyright Seriel 2016-2017
module YuukiBot
  module Owner

    # noinspection RubyResolve
    Commandrb.commands[:prune] = {
      code: proc { |event, args|
        num = args[0]
        num = 75 if num.nil?
        count = 0
        msgs = []
        event.channel.history(num).each do |x|
          if x.author.id == event.bot.profile.id
            msgs.push(x.id)
            count += 1
          end
        end
        Discordrb::API::Channel.bulk_delete_messages(event.bot.token, event.channel.id, msgs)
        event.respond("#{YuukiBot.config['emoji_tickbox']} Pruned #{count} bot messages!")
      },
      triggers: %w(prune cleanup purge stfu ),
      required_permissions: [:manage_messages],
      owner_override: true,
      owners_only: true,
      max_args: 1,
    }

    # noinspection RubyResolve
    Commandrb.commands[:pruneuser] = {
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
          event.respond("❌ I don't have permission to delete messages!")
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
      owner_override: false,
      max_args: 1,
    }
  end
end
