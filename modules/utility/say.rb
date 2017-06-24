# Copyright Seriel 2016-2017
module YuukiBot
  module Utility


    $cbot.add_command(:say,
      code: proc { |event, args|
      message = args.join(' ')
      new_msg = event.respond(Helper.filter_everyone(message))
      Helper.map_say(event.channel.id, event.message.id, new_msg.id)
    },
      triggers: %w(say echo talk repeat),
      min_args: 1
    )

    $cbot.add_command(:speak,
      code: proc { |event, args|
        event.message.delete
        event.respond(args.join(' '))
      },
      owners_only: true,
      min_args: 1
    )

    $cbot.add_command(:hide,
      code: proc { |event, args|
        event.respond(args.join(' '))
        event.message.delete
      },
      owners_only: true,
      min_args: 1
    )


#    $cbot.bot.message_delete  { |event|
#      unless Helper.say_map[event.id].nil?
#        event.bot.channel(Helper.say_map[event.id][0]).message(Helper.say_map[event.id][1]).delete
#      end
#    }
  end
end
