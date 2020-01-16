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
              id = user.id rescue nil
              if user.nil?
                event.respond("#{YuukiBot.config['emoji_error']} Not a valid user!")
              else
                if args[0] == 'add'
                  owners = JSON.parse(REDIS.get('owners'))
                  if $cbot.is_owner?(id)
                    event.respond("#{YuukiBot.config['emoji_error']} User is already an owner!")
                    next
                  end
                  REDIS.set('owners', owners.push(id).to_json)
                  event.respond("#{YuukiBot.config['emoji_tickbox']} added `#{event.bot.user(id).nil? ? "Unknown User (ID: #{id})" : "#{event.bot.user(id).distinct}"}` to bot owners!")
                elsif args[0] == 'remove'
                  owners = JSON.parse(REDIS.get('owners'))
                  unless owners.include?(id)
                    event.respond("#{YuukiBot.config['emoji_error']} User is not an owner!")
                    next
                  end
                  if YuukiBot.config['master_owner'] == id
                    event.respond("#{YuukiBot.config['emoji_error']} You can't remove the main owner!")
                  end
                  REDIS.set('owners', owners.delete(id).to_json)
                  event.respond("#{YuukiBot.config['emoji_tickbox']} removed `#{event.bot.user(id).nil? ? "Unknown User (ID: #{id})" : "#{event.bot.user(id).distinct}"}` from bot owners!")
                end
              end
            },
            owners_only: true
          )

    end
end
