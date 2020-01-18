# Copyright Erisa A (erisa.moe) 2016-2019
module YuukiBot
    module Owner

        $cbot.add_command(:owners,
            code: proc { |event, _|
                owners = JSON.parse(REDIS.get('owners')) rescue []
                event << 'This bot instance is managed/owned by the following users. Please contact them for any issues.'
                event << "- **#{event.bot.user(YuukiBot.config['master_owner']).distinct}** [**MAIN**]" unless YuukiBot.config['master_owner'].nil?
                owners.each {|x|
                event.bot.user(x).nil? ? event << "- Unknown User (ID: `#{x}`)" : event << "- **#{event.bot.user(x).distinct}**"
                }
            },
            triggers: ['owners']
        )

        $cbot.add_command(:botowners,
            code: proc { |event, args|
              user = Helper.userparse(args[1])
              owners = JSON.parse(REDIS.get('owners')) rescue []
              if user.nil?
                event.respond("#{YuukiBot.config['emoji_error']} Not a valid user!")
              else
                case args[0]
                when 'add'
                  if $cbot.is_owner?(user.id)
                    event.respond("#{YuukiBot.config['emoji_error']} User is already an owner!")
                  else
                    REDIS.set('owners', owners.push(user.id).to_json)
                    event.respond("#{YuukiBot.config['emoji_tickbox']} added `#{Helper.userid_to_string(user.id)}` to bot owners!")
                  end
                when 'remove'
                  if YuukiBot.config['master_owner'] == user.id
                    event.respond("#{YuukiBot.config['emoji_error']} You can't remove the main owner!")
                  elsif owners.include?(user.id)
                    REDIS.set('owners', owners.delete(user.id).to_json)
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
