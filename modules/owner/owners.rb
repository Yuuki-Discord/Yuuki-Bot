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
        
    end
end
