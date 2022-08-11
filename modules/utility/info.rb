# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020

module YuukiBot
  module Utility
    YuukiBot.crb.add_command(
      :avatar,
      description: "Show someone's avatar.",
      arg_format: {
        user: { name: 'user', description: 'User to retrieve info for', type: :user,
                optional: true, default: :current_user }
      },
      triggers: %w[avatar avy],
      server_only: true
    ) do |event, args|
      user = args.user
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
    end

    YuukiBot.crb.add_command(
      :info,
      description: 'Show information about someone.',
      arg_format: {
        user: { name: 'user', description: 'User to retrieve info for', type: :user,
                optional: true, default: :current_user }
      },
      triggers: %w[info profile]
    ) do |event, args|
      user = args.user
      member = user.on(event.server)
      ignoreserver = true if member.nil?

      donatorlist = REDIS.get('donators')

      donator = donatorlist.nil? ? false : JSON.parse(donatorlist.include?(user.id))

      event.channel.send_embed("__Information about **#{user.distinct}**__") do |embed|
        embed.colour = Helper.colour_from_user(member, 0xe06b2)
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
          name: 'Account Created:',
          value: "#{user.creation_time.getutc.asctime} UTC",
          inline: true
        )
        embed.add_field(
          name: 'Joined Server:',
          value: ignoreserver ? '[N/A]' : "#{member.joined_at.getutc.asctime} UTC",
          inline: true
        )
      end
    end

    YuukiBot.crb.add_command(
      :ping,
      description: 'Ping! Is Yuuki awake?',
      triggers: %w[ping pong peng pung pyng pang 🅱ing]
    ) do |event|
      return_message = event.respond('Pinging..!')
      ping = (return_message.id - event.message.id) >> 22
      choose = %w[i o e u y a]
      return_message.edit("P#{choose.sample}ng! (`#{ping}ms`)")
    end

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

      seconds = seconds.to_s.length == 1 ?  "0#{seconds}" : seconds.to_s
      minutes = minutes.to_s.length == 1 ?  "0#{minutes}" : minutes.to_s
      hours = hours.to_s.length == 1 ? "0#{hours}" : hours.to_s

      "#{days} day#{'s' unless days == 1}, #{hours}:#{minutes}:#{seconds}"
    end

    YuukiBot.crb.add_command(
      :uptime
    ) do |event|
      uptime_ms = (Time.now - YuukiBot.launch_time) * 1000

      event.respond("I was launched on `#{YuukiBot.launch_time.asctime} UTC`!\n" \
                    "I have been running for `#{ms_to_time(uptime_ms)}` (#{uptime_ms.floor} ms).")
    end
  end
end
