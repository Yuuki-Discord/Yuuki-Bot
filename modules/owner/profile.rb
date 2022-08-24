# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020
module YuukiBot
  module Owner
    YuukiBot.crb.add_command(
      :nick,
      description: 'Change the nickname of the bot.',
      group: :config,
      owners_only: true,
      text_only: true,
      arg_format: {
        nickname: { name: 'nickname', description: 'The nickname the bot should use',
                    type: :string }
      }
    ) do |event, args|
      event.bot.profile.on(event.server).nickname = args.nickname
      event.success "Nickname changed to `#{args.nickname}`"
    rescue Discordrb::Errors::NoPermission
      event.failure "I don't have permission to change my nickname!"
    end

    YuukiBot.crb.add_command(
      :avatar,
      description: 'Change the avatar of the bot.',
      group: :config,
      owners_only: true,
      text_only: true,
      arg_format: {
        url: { name: 'url', description: 'The URL of the avatar to set',
               type: :string }
      }
    ) do |event, args|
      event.bot.profile.avatar = File.open(Helper.download_file(args.url, 'tmp'))
      event.success 'Changed avatar!'
    end

    YuukiBot.crb.add_command(
      :game,
      description: 'Change the game of the bot.',
      group: :config,
      owners_only: true,
      text_only: true,
      arg_format: {
        game: { name: 'game', description: 'The contents of the game to set',
                type: :string }
      }
    ) do |event, args|
      event.bot.game = args.game
      event.success "Game set to `#{args.game}`!"
    end

    YuukiBot.crb.add_command(
      :status,
      group: :config,
      owners_only: true,
      arg_format: {
        status: {
          name: 'status',
          description: 'The status to set',
          type: :string,
          choices: [
            {
              name: 'Online',
              value: 'online'
            },
            {
              name: 'Idle',
              value: 'idle'
            },
            {
              name: 'Do Not Disturb',
              value: 'dnd'
            },
            {
              name: 'Offline',
              value: 'offline'
            }
          ]
        }
      }
    ) do |event, args|
      case args.status
      when 'online' then event.bot.online
      when 'idle' then event.bot.idle
      when 'dnd' then event.bot.dnd
      when 'offline' then event.bot.invisible
      else
        event.failure('Unknown status!')
      end
    end

    YuukiBot.crb.add_command(
      :reset,
      group: :config,
      owners_only: true,
      arg_format: {
        type: {
          name: 'type',
          description: 'The config item to reset',
          type: :string,
          choices: [
            {
              name: 'Nickname',
              value: 'nick'
            },
            {
              name: 'Avatar',
              value: 'avatar'
            },
            {
              name: 'Game',
              value: 'game'
            }
          ]
        }
      }
    ) do |event, args|
      case args.type
      when 'nick'
        begin
          event.bot.profile.on(event.server).nickname = nil
          event.success 'Reset nickname!'
        rescue Discordrb::Errors::NoPermission
          event.failure "I don't have permission to change my nickname!"
        end
      when 'avatar'
        event.bot.avatar = nil
        event.success 'Reset avatar!'
      when 'game'
        event.bot.game = nil
        event.success 'Reset game!'
      else
        event.failure 'Unknown config item!'
      end
    end
  end
end
