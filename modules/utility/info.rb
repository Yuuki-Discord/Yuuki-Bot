# Copyright Erisa Komuro (Seriel) 2016-2017

module YuukiBot
  module Utility

    $cbot.add_command(:avatar,
      code: proc { |event, args|
        if args.length == 0
          user = event.user
        else
          begin
            if args[0] == "byid"
              user = event.bot.user(args[1])
            else
              user = event.bot.parse_mention(args.join(' '))
              puts user
            end
          rescue
            event.channel.send_message('', false,
              Helper.error_embed(
               error: "Not a valid user!",
               footer: "Command: `#{event.message.content}`",
               colour: 0xFA0E30,
               code_error: false
              )
            )
            raise 'Not a valid user'
          end
        end

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
            if args[0] == "byid"
              user = event.bot.user(args[1])
            else
              user = event.bot.parse_mention(args.join(' '))
              puts user
            end
        rescue
          user = event.user
        end
        
        if user.nil?
          event.channel.send_message('', false,
            Helper.error_embed(
             error: "Error unknown. Details:\n`User is nil.`",
             footer: "Command: `#{event.message.content}`",
             colour: 0xFA0E30,
             code_error: false
            )
          )
          next
        end
          
          

        unless event.channel.private? || event.server.members.include?(user)
         member = user.on(event.server) unless 
         ignoreserver = true
        end
       
        
        nickname = member.nickname.nil? ? member.display_name : member.nickname unless ignoreserver
        event.channel.send_embed("__Information about **#{user.distinct}**__") do |embed|
          embed.colour = event.channel.private? ? 0xe06b2 : Helper.colour_from_user(member)
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: Helper.avatar_url(user))
          embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "#{Data.donators.include?(user.id) ? ' 👑' : ' 👥' } #{ignoreserver ? user.name : member.display_name}", url: Helper.avatar_url(user))
          embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "All information correct as of: #{Time.now.getutc.asctime}")
          embed.add_field(name: 'User ID:', value: user.id, inline: true)
          embed.add_field(name: 'Playing:', value: user.game.nil? ? '[N/A]' : user.game, inline: true)
          embed.add_field(name: 'Account Created:', value: "#{user.creation_time.getutc.asctime} UTC", inline: true)
          embed.add_field(name: 'Joined Server:', value: ignoreserver ? '[N/A]' : "#{member.joined_at.getutc.asctime} UTC", inline: true)
          embed.add_field(name: 'Status', value: user.status.capitalize)
        end
      },
      triggers: %w(info profile),
    )

    $cbot.add_command(:ping,
      code: proc {|event, _|
        return_message = event.respond('Pinging..!')
        ping = (return_message.id - event.message.id) >> 22
	      choose = %w(i o e u y a)
        return_message.edit("P#{choose.sample}ng! (`#{ping}ms`)")
       },
      triggers: %w(ping pong peng pung pyng pang)
    )
  end
end
