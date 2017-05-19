# Copyright Seriel 2016-2017

module YuukiBot
  module Utility

    Commandrb.commands[:avatar] = {
      code: proc { |event, args|
        if args.nil?
          user = event.user
        elsif event.message.mentions[0]
          user = event.bot.parse_mention(args[0])
        end
        event.channel.send_file File.new(Helper.download_avatar(user, 'tmp'))
      },
      triggers: %w(avatar avy),
      :server_only => true,
    }

    Commandrb.commands[:info] = {
      code: proc { |event, args|
        begin
          user = event.bot.parse_mention(args[0])
        rescue
          event.respond('Invalid mention!')
        end

        member = user.on(event.server) unless event.channel.private?
        event <<  " 👥 Infomation about **#{(event.channel.private? ? user.name : member.display_name)}**"
        event << "-ID: **#{user.id}**"
        event << "-Username: `#{user.distinct}`"
        event << "-Nickname: **#{member.nickname.nil? ? '[N/A]' : member.nickname}**" unless event.channel.private?
        event << "-Status: **#{user.status}**"
        event << "-Playing: **#{user.game.nil? ? '[N/A]' : user.game}**"
        event << "-Account created: **#{user.creation_time.getutc.asctime}** UTC"
        event << "-Joined server at: **#{member.joined_at.getutc.asctime}** UTC" unless event.channel.private?
      },
      triggers: [
        'info',
        'i'
      ],
      max_args: 1
    }
  end
end
