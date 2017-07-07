# Copyright Seriel 2016-2017

module YuukiBot
  module Utility

    $cbot.add_command(:avatar,
      code: proc { |event, args|
        begin
          user = event.bot.parse_mention(args[0])
        rescue
          user = event.user
        end
        # event.channel.send_file File.new(Helper.download_avatar(user, 'tmp'))
		event.channel.send_embed do |embed|
		  embed.colour = 0x22ef1f

		  embed.image = Discordrb::Webhooks::EmbedImage.new(url: Helper.avatar_url(user))
		  embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "Avatar for #{user.name}", url: Helper.avatar_url(user))
		  embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Avatar correct as of #{Time.now.getutc.asctime}")
		end
      },
      triggers: %w(avatar avy),
      :server_only => true,
    )

    $cbot.add_command(:info,
      code: proc { |event, args|
        begin
          user = event.bot.parse_mention(args[0])
        rescue
          user = event.user
        end

        member = user.on(event.server) unless event.channel.private?
        # event <<  "#{Data.donators.include?(user.id) ? ' 👑' : ' 👥' } Infomation about **#{(event.channel.private? ? user.name : member.display_name)}**"
        # event << "-ID: **#{user.id}**"
        # event << "-Username: `#{user.distinct}`"
        # event << "-Nickname: **#{member.nickname.nil? ? '[N/A]' : member.nickname}**" unless event.channel.private?
        # event << "-Status: **#{user.status}**"
        # event << "-Playing: **#{user.game.nil? ? '[N/A]' : user.game}**"
        # event << "-Account created: **#{user.creation_time.getutc.asctime}** UTC"
        # event << "-Joined server at: **#{member.joined_at.getutc.asctime}** UTC" unless event.channel.private?
        nickname = member.nickname.nil? ? '[N/A]' : member.nickname unless event.channel.private?
        event.channel.send_embed("__Information about **#{user.distinct}**__") do |embed|
          embed.colour = event.channel.private? ? 0xe06b2 : Helper.colour_from_user(member)
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: Helper.avatar_url(user))
          embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "#{Data.donators.include?(user.id) ? ' 👑' : ' 👥' } #{nickname.nil? ? user.name : nickname}", url: Helper.avatar_url(user))
          embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "All information correct as of: #{Time.now.getutc.asctime}")
          embed.add_field(name: 'User ID:', value: user.id, inline: true)
          embed.add_field(name: 'Playing:', value: user.game.nil? ? '[N/A]' : user.game, inline: true)
          embed.add_field(name: 'Account Created:', value: "#{user.creation_time.getutc.asctime} UTC", inline: true)
          embed.add_field(name: 'Joined Server:', value: event.channel.private? ? '[N/A]' : "#{member.joined_at.getutc.asctime} UTC", inline: true)
          embed.add_field(name: 'Status', value: user.status.capitalize)
        end
      },
      triggers: %w(info profile),
      max_args: 1
    )

    $cbot.add_command(:ping,
      code: Proc.new {|event, _|
        return_message = event.respond('Pinging..!')
        ping = (return_message.id - event.message.id) >> 22
	    choose = %w(i o e u y a)
        return_message.edit("P#{choose.sample}ng! (`#{ping}ms`)")
       },
      triggers: %w(ping pong peng pung pyng pang)
    )
  end
end
