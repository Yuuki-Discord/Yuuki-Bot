# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020
module YuukiBot
  module Owner
    YuukiBot.crb.add_command(
      :ignore,
      triggers: %w[ignore],
      owners_only: true
    ) do |event, args|
      if args == []
        event.respond("#{YuukiBot.config['emoji_error']} Mention a valid user!")
        next
      end
      user = Helper.userparse(args[0])

      ignores = begin
        JSON.parse(REDIS.get('ignores'))
      rescue StandardError
        []
      end
      if user.nil?
        event.respond("#{YuukiBot.config['emoji_error']} Not a valid user!")
      elsif YuukiBot.crb.owner?(user)
        event.respond("#{YuukiBot.config['emoji_error']} You can't ignore owners!")
      elsif ignores.include?(user.id)
        event.respond("#{YuukiBot.config['emoji_error']} User is already ignored!")
      else
        REDIS.set('ignores', ignores.push(user.id).to_json)
        event.bot.ignore_user(user)
        tickbox = YuukiBot.config['emoji_tickbox']
        event.respond("#{tickbox} `#{user.distinct}` is now being ignored!")
      end
    end

    YuukiBot.crb.add_command(
      :unignore,
      owners_only: true
    ) do |event, args|
      if args == []
        event.respond("#{YuukiBot.config['emoji_error']} Mention a valid user!")
        next
      end

      user = Helper.userparse(args[0])
      ignores = begin
        JSON.parse(REDIS.get('ignores'))
      rescue StandardError
        []
      end

      if user.nil?
        event.respond("#{YuukiBot.config['emoji_error']} Not a valid user!")
      elsif !ignores.include?(user.id)
        event.respond("#{YuukiBot.config['emoji_error']} User isn't ignored!")
      else
        event.bot.unignore_user(user)
        REDIS.set('ignores', (ignores - [user.id]).to_json)
        tickbox = YuukiBot.config['emoji_tickbox']
        event.respond("#{tickbox} `#{user.distinct}` has been removed from the ignore list!")
      end
    end
  end
end
