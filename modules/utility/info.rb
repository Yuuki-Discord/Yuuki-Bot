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
        
        if user.nil?
          event.channel.send_message('', false,
            Helper.error_embed(
             error: "Error unknown. Details:\n`User is nil or not found.`",
             footer: "Command: `#{event.message.content}`",
             colour: 0xFA0E30,
             code_error: false
            )
          )
          next
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
        if args.length == 0 or args[0].nil? or args[0] == ''
          user = event.user
        else
          begin
            if args[0] == "byid"
              user = event.bot.user(args[1])
            else
              user = event.bot.parse_mention(args.join(' '))
            end
          rescue
            user = event.user
          end
        end
        
        if user.nil?
          event.channel.send_message('', false,
            Helper.error_embed(
             error: "Error unknown. Details:\n`User is nil or not found.`",
             footer: "Command: `#{event.message.content}`",
             colour: 0xFA0E30,
             code_error: false
            )
          )
          next
        end

# Discordrb sucks
=begin
        if event.channel.private? || !event.server.members.include?(user)
          ignoreserver = true
        else
          member = user.on(event.server)
        end
=end  

        # Beter than the alternative :)
        begin 
          member = user.on(event.server)
        rescue
          ignoreserver = true
        end

        donator = JSON.parse(REDIS.get('donators')).include?(user.id)
        event.channel.send_embed("__Information about **#{user.distinct}**__") do |embed|
          embed.colour = event.channel.private? ? 0xe06b2 : Helper.colour_from_user(member)
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: Helper.avatar_url(user))
          embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "#{donator ? ' 👑' : ' 👥' } #{ignoreserver ? user.name : member.display_name}", url: Helper.avatar_url(user))
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
      triggers: %w(ping pong peng pung pyng pang 🅱ing)
    )


def self.ms_to_time(ms)
  time = ms / 1000
  seconds = time % 60
  time = time / 60
  minutes = time % 60
  time = time / 60
  hours = time % 60
  time = time / 60
  days = time

  seconds = seconds.floor
  minutes = minutes.floor
  hours = hours.floor
  days = days.floor

  seconds = (seconds.to_s.length == 1) ?  "0" + seconds.to_s : seconds.to_s
  minutes = (minutes.to_s.length == 1) ?  "0" + minutes.to_s : minutes.to_s
  hours = (hours.to_s.length == 1) ?  "0" + hours.to_s : hours.to_s

  "#{days} days, #{hours}:#{minutes}:#{seconds}"
end

    $cbot.add_command(:uptime,
    code: proc do |event, _|
      uptimems = (Time.now - $launch_time) * 1000

      event.respond("I was first launched on `#{$launch_time.asctime} UTC`\nThis means I have been online for `#{self.ms_to_time(uptimems)}` (`#{uptimems.floor}ms`)")
    end
    )


  end
end
