# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020
module YuukiBot
  module Owner
    YuukiBot.crb.add_command(
      :owners,
      code: proc { |event, _|
        event << 'This bot instance is managed/owned by the following users. Please contact them for any issues.'
        unless YuukiBot.config['master_owner'].nil?
          event << "- **#{event.bot.user(YuukiBot.config['master_owner']).distinct}** [**MAIN**]"
          end
        Helper.owners.each do |x|
          event.bot.user(x).nil? ? event << "- Unknown User (ID: `#{x}`)" : event << "- **#{event.bot.user(x).distinct}**"
        end
      },
      triggers: ['owners']
    )

    YuukiBot.crb.add_command(
      :botowners,
      code: proc { |event, args|
        user = Helper.userparse(args[1])
        if user.nil?
          event.respond("#{YuukiBot.config['emoji_error']} Not a valid user!")
        else
          case args[0]
          when 'add'
            if YuukiBot.crb.owner?(user.id)
              event.respond("#{YuukiBot.config['emoji_error']} User is already an owner!")
            else
              REDIS.set('owners', Helper.owners.push(user.id).to_json)
              event.respond("#{YuukiBot.config['emoji_tickbox']} added `#{Helper.userid_to_string(user.id)}` to bot owners!")
            end
          when 'remove'
            if YuukiBot.config['master_owner'] == user.id
              event.respond("#{YuukiBot.config['emoji_error']} You can't remove the main owner!")
            elsif Helper.owners.include?(user.id)
              REDIS.set('owners', (Helper.owners - [user.id]).to_json)
              event.respond("#{YuukiBot.config['emoji_tickbox']} removed `#{Helper.userid_to_string(user.id)}` from bot owners!")
            else
              event.respond("#{YuukiBot.config['emoji_error']} User is not an owner!")
            end
          end
        end
      },
      owners_only: true
    )
  end
end
