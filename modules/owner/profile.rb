# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020
module YuukiBot
  module Owner
    YuukiBot.crb.add_command(
      :set,
      code: proc { |event, args|
        if args.empty?
          # Let the default case handle as unknown.
          args[0] = ''
        end

        error = YuukiBot.config['emoji_error']
        tickbox = YuukiBot.config['emoji_tickbox']

        case args[0].downcase
        when 'nick', 'nickname'
          begin
            event.bot.profile.on(event.server).nickname = args.drop(1).join(' ')
            event.respond("#{tickbox} Nickname changed to `#{args.drop(1).join(' ')}`")
          rescue Discordrb::Errors::NoPermission
            event.respond("#{error} I don't have permission to change my nickname!")
          end
        when 'avatar', 'avy'
          url = args.drop(1).join(' ')
          event.bot.profile.avatar = File.open(Helper.download_file(url, 'tmp'))
        when 'game', 'playing'
          event.bot.game = args.drop(1).join(' ')
          event.respond("#{tickbox} Game set to `#{args.drop(1).join(' ')}`!")
        when 'username', 'name'
          username = args.drop(1).join(' ')
          begin
            event.bot.profile.name = username
          rescue StandardError => e
            error_embed = Helper.error_embed(
              footer: "Command: `#{event.message.content}`",
              error: e,
              code_error: true
            )
            event.channel.send_message('', false, error_embed)
            next
          end

          event.respond("#{tickbox} Username _should_ be updated!")
        when 'status', 'indicator', 'state'
          state = args[1]
          case state.downcase
          when 'idle', 'away', 'afk' then event.bot.idle
          when 'dnd'
            state = 'Do Not Disturb'
            event.bot.dnd
          when 'online' then event.bot.online
          when 'invisible', 'offline' then event.bot.invisible
          else
            event.respond('Enter a valid argument!')
            next
          end

          display_state = state == 'Do Not Disturb' ? state : state.capitalize
          event.respond("#{tickbox} Status set to **#{display_state}**!")
        else
          event.respond("#{error} Enter a valid subcommand!\n" \
                        'Valid commands: `avatar`, `game`, `username`, `status`, `nickname`.')
          next
        end
      },
      triggers: %w[set config],
      owners_only: true
    )

    YuukiBot.crb.add_command(
      :reset,
      code: proc { |event, args|
        if args.empty?
          # Let the default case handle as unknown.
          args[0] = ''
        end

        case args[0].downcase
        when 'nick', 'nickname'
          begin
            event.bot.profile.on(event.server).nickname = nil
            event.respond("#{YuukiBot.config['emoji_tickbox']} Reset nickname!")
          rescue Discordrb::Errors::NoPermission
            error = YuukiBot.config['emoji_error']
            event.respond("#{error} I don't have permission to change my nickname!")
          end
        when 'avatar', 'avy'
          event.bot.avatar = nil
          event.respond "#{YuukiBot.config['emoji_success']} Reset avatar!"
        when 'game', 'playing'
          event.bot.game = nil
          event.respond("#{YuukiBot.config['emoji_tickbox']} Reset game!")
        else
          event.respond("#{YuukiBot.config['emoji_error']} Enter a valid subcommand!\n" \
                        'Valid commands: `avatar`, `game`, `nickname`.')
        end
      },
      triggers: %w[reset],
      owners_only: true
    )
  end
end
