# Copyright Erisa Komuro (Seriel) 2016-2017
module YuukiBot
  module Owner

    # noinspection RubyResolve,RubyResolve,RubyResolve,RubyResolve,RubyResolve
    $cbot.add_command(:status,
      code: proc { |event, args|
        case args[0].downcase
        when 'idle' || 'away' || 'afk' then event.bot.idle
        when 'dnd' then event.bot.dnd
        when 'online' then event.bot.online
        when 'invisible' || 'offline' then event.bot.invisible
        else
          event.respond('Enter a valid argument!')
          next
        end
        event.respond("#{YuukiBot.config['emoji_tickbox']} Status set to **#{args[0].capitalize}**!") },
      triggers: %w(status setstatus go),
      owners_only: true
    )

  end
end
