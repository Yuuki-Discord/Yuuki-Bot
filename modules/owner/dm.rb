# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2019-2020
module YuukiBot
  module Owner
    YuukiBot.crb.bot.message do |event|
      next unless event.channel.private?
      next if event.user.bot_account
      next if YuukiBot.crb.owner?(event.user)

      target_id = if YuukiBot.config['dm_channel'].nil?
                    event.bot.user(YuukiBot.config['master_owner']).pm.id
                  else
                    YuukiBot.config['dm_channel']
                  end

      event.bot.channel(target_id).send_embed do |embed|
        embed.description = event.message.content
        embed.timestamp = Time.now
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(
          name: "DM from: #{event.user.distinct}",
          icon_url: Helper.avatar_url(event.user)
        )
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Reply ID: #{event.channel.id} ")
      end
    end

    YuukiBot.crb.add_command(
      :reply,
      code: proc { |event, args|
        channel = event.bot.channel(args[0])
        reply = args.drop(1).join(' ')

        if channel.nil?
          event.respond("#{YuukiBot.config['emoji_error']} Not a valid channel! " \
                        'Has the user started a conversation?')
          next
        end
        unless channel.private?
          event.respond("#{YuukiBot.config['emoji_error']} Channel is not a DM!")
          next
        end

        channel.send_embed do |embed|
          # embed.colour = 0xd9ea6e
          embed.description = reply
          embed.timestamp = Time.now
          embed.author = Discordrb::Webhooks::EmbedAuthor.new(
            name: "Developer response from: #{event.user.distinct}",
            icon_url: Helper.avatar_url(event.user)
          )
          embed.footer = Discordrb::Webhooks::EmbedFooter.new(
            text: 'Replies to this DM will be sent to developers.'
          )
        end
        event.respond "#{YuukiBot.config['emoji_success']} Your message has been sent!"
      },
      owners_only: true
    )
  end
end
