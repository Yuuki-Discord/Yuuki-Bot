# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020

module YuukiBot
  module Utility
    YuukiBot.crb.add_command(
      :avatar,
      code: proc { |event, args|
        if args.empty?
          user = event.user
        else
          begin
            user = if args[0] == 'byid'
                     event.bot.user(args[1])
                   else
                     Helper.userparse(args.join(' '))
                   end
          rescue StandardError
            event.channel.send_message('', false,
                                       Helper.error_embed(
                                         error: 'Not a valid user!',
                                         footer: "Command: `#{event.message.content}`",
                                         colour: 0xFA0E30,
                                         code_error: false
                                       ))
            raise 'Not a valid user'
          end
        end

        if user.nil?
          event.channel.send_message('', false,
                                     Helper.error_embed(
                                       error: "Error:\n`User is nil or not found.`",
                                       footer: "Command: `#{event.message.content}`",
                                       colour: 0xFA0E30,
                                       code_error: false
                                     ))
          next
        end

        avy_embed = Discordrb::Webhooks::Embed.new(
          image: Discordrb::Webhooks::EmbedImage.new(url: Helper.avatar_url(user)),
          author: Discordrb::Webhooks::EmbedAuthor.new(
            name: "Avatar for #{user.name} (Click to open in browser)",
            url: Helper.avatar_url(user)
          ),
          footer: Discordrb::Webhooks::EmbedFooter.new(
            text: "Called by #{event.user.distinct} (#{event.user.id})",
            icon_url: Helper.avatar_url(event.user)
          ),
          timestamp: Time.now
        )

        color = Helper.colour_from_user(user.on(event.server), -1)
        # We don't want black (0x000000) if the user has no role colors.
        # Let's leave that to Discord.
        avy_embed.color = color unless color == -1
        event.channel.send_message('', false, avy_embed)
      },
      triggers: %w[avatar avy],
      server_only: true
    )

    YuukiBot.crb.add_command(
      :info,
      code: proc { |event, args|
        if args.empty? || args[0].nil? || (args[0] == '')
          user = event.user
        else
          begin
            user = if args[0] == 'byid'
                     event.bot.user(args[1])
                   else
                     event.bot.parse_mention(args.join(' '))
                   end
          rescue StandardError
            user = event.user
          end
        end

        if user.nil?
          error_embed = Helper.error_embed(
            error: "Error unknown. Details:\n`User is nil or not found.`",
            footer: "Command: `#{event.message.content}`",
            colour: 0xFA0E30,
            code_error: false
          )
          event.channel.send_message('', false, error_embed)
          next
        end

        member = user.on(event.server)
        ignoreserver = true if member.nil?

        donator = JSON.parse(REDIS.get('donators')).include?(user.id)
        event.channel.send_embed("__Information about **#{user.distinct}**__") do |embed|
          embed.colour = Helper.colour_from_user(member, default: 0xe06b2)
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(
            url: Helper.avatar_url(user)
          )
          embed.author = Discordrb::Webhooks::EmbedAuthor.new(
            name: "#{donator ? ' 👑' : ' 👥'} #{ignoreserver ? user.name : member.display_name}",
            url: Helper.avatar_url(user)
          )
          embed.footer = Discordrb::Webhooks::EmbedFooter.new(
            text: "All information correct as of: #{Time.now.getutc.asctime}"
          )
          embed.add_field(
            name: 'User ID:',
            value: user.id,
            inline: true
          )
          embed.add_field(
            name: 'Playing:',
            value: user.game.nil? ? '[N/A]' : user.game,
            inline: true
          )
          embed.add_field(
            name: 'Account Created:',
            value: "#{user.creation_time.getutc.asctime} UTC",
            inline: true
          )
          embed.add_field(
            name: 'Joined Server:',
            value: ignoreserver ? '[N/A]' : "#{member.joined_at.getutc.asctime} UTC",
            inline: true
          )
          embed.add_field(
            name: 'Status',
            value: user.status.capitalize
          )
        end
      },
      triggers: %w[info profile]
    )

    YuukiBot.crb.add_command(
      :ping,
      code: proc { |event, _|
              return_message = event.respond('Pinging..!')
              ping = (return_message.id - event.message.id) >> 22
              choose = %w[i o e u y a]
              return_message.edit("P#{choose.sample}ng! (`#{ping}ms`)")
            },
      triggers: %w[ping pong peng pung pyng pang 🅱ing]
    )

    def self.ms_to_time(milliseconds)
      time = milliseconds / 1000
      seconds = time % 60
      time /= 60
      minutes = time % 60
      time /= 60
      hours = time % 24
      time /= 24
      days = time

      seconds = seconds.floor
      minutes = minutes.floor
      hours = hours.floor
      days = days.floor

      seconds = seconds.to_s.length == 1 ?  '0' + seconds.to_s : seconds.to_s
      minutes = minutes.to_s.length == 1 ?  '0' + minutes.to_s : minutes.to_s
      hours = hours.to_s.length == 1 ? '0' + hours.to_s : hours.to_s

      "#{days} day#{'s' unless days == 1}, #{hours}:#{minutes}:#{seconds}"
    end

    YuukiBot.crb.add_command(
      :uptime,
      code: proc do |event, _|
        uptime_ms = (Time.now - YuukiBot.launch_time) * 1000

        event.respond("I was launched on `#{YuukiBot.launch_time.asctime} UTC`\n" \
          "This means I have been online for `#{ms_to_time(uptime_ms)}` (`#{uptime_ms.floor}ms`)")
      end
    )
  end
end
