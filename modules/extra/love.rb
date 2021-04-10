# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe), spotlight_is_ok, Larsenv 2017-2020
module YuukiBot
  module Extra
    YuukiBot.crb.add_command(
      :love,
      code: proc { |event, args|
        if args.length == 1
          first = event.user.name
          begin
            second = event.bot.parse_mention(args).name
          rescue StandardError
            second = args[0]
          end
        elsif args.length == 3 && args[1].empty?
          # Occasionally, Discord clients may insert a space
          # between two mentions.
          first = args[0]
          second = args[2]
        else
          first = args[0]
          second = args[1]
        end

        prng = Random.new
        percentage = prng.rand(1..100)

        result = if percentage < 10
                   'Awful 😭'
                 elsif percentage < 20
                   'Bad 😢'
                 elsif percentage < 30
                   'Pretty Low 😦'
                 elsif percentage < 40
                   'Not Too Great 😕'
                 elsif percentage < 50
                   'Worse Than Average 😐'
                 elsif percentage < 60
                   'Barely 😶'
                 elsif percentage == 69
                   '( ͡° ͜ʖ ͡°)'
                 elsif percentage < 70
                   'Not Bad 🙂'
                 elsif percentage < 80
                   'Pretty Good 😃'
                 elsif percentage < 90
                   'Great 😄'
                 elsif percentage < 100
                   'Amazing 😍'
                 else
                   'PERFECT! ❣️'
                 end

        response = "💗 **MATCHMAKING** 💗\n" \
            "First - #{first}\n" \
            "Second - #{second}\n" \
            "**-=-=-=-=-=-=-=-=-=-=-=-**\n" \
            "Result ~ #{percentage}% - #{result}\n"

        event.respond(response)
      },
      triggers: ['love', 'ship '],
      min_args: 1
    )
  end
end
