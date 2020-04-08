# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020
module YuukiBot
  module Owner
    YuukiBot.crb.add_command(
      :owners,
      code: proc { |event, _|
        event << 'This bot instance is managed/owned by the following users. ' \
          'Please contact them for any issues.'
        unless YuukiBot.config['master_owner'].nil?
          event << "- **#{event.bot.user(YuukiBot.config['master_owner']).distinct}** [**MAIN**]"
        end
        Helper.owners.each do |x|
          event << if event.bot.user(x).nil?
                     "- Unknown User (ID: `#{x}`)"
                   else
                     "- **#{event.bot.user(x).distinct}**"
                   end
        end
      },
      triggers: ['owners']
    )

    YuukiBot.crb.add_command(
      :botowners,
      code: proc { |event, args|
        error = YuukiBot.config['emoji_error']
        tickbox = YuukiBot.config['emoji_tickbox']

        user = Helper.userparse(args[1])
        if user.nil?
          event.respond("#{error} Not a valid user!")
          next
        end
        case args[0]
        when 'add'
          if YuukiBot.crb.owner?(user.id)
            event.respond("#{error} User is already an owner!")
          else
            REDIS.set('owners', Helper.owners.push(user.id).to_json)
            event.respond("#{tickbox} added `#{Helper.userid_to_string(user.id)}` to bot owners!")
          end
        when 'remove'
          if YuukiBot.config['master_owner'] == user.id
            event.respond("#{error} You can't remove the main owner!")
          elsif Helper.owners.include?(user.id)
            REDIS.set('owners', (Helper.owners - [user.id]).to_json)
            userid = Helper.userid_to_string(user.id)
            event.respond("#{tickbox} removed `#{userid}` from bot owners!")
          else
            event.respond("#{error} User is not an owner!")
          end
        end
      },
      owners_only: true
    )
  end
end
