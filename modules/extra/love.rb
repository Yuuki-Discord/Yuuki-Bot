# Copyright Erisa Arrowsmith (Seriel), spotlight_is_ok, Larsenv 2017
module YuukiBot
  module Extra
    $cbot.add_command(:love,
        code: proc { |event,args|
          first = ''
          second = ''
          if args.length == 1
            first = event.user.name
            begin
              second = event.bot.parse_mention(args).name
            rescue
              second = args[0]
            end
          else
            first = args[0]
            second = args[1]
          end

          prng = Random.new
          percentage = prng.rand(1..100)

          case
            when percentage < 10
              result = 'Awful 😭'
            when percentage < 20
              result = 'Bad 😢'
            when percentage < 30
              result = 'Pretty Low 😦'
            when percentage < 40
              result = 'Not Too Great 😕'
            when percentage < 50
              result = 'Worse Than Average 😐'
            when percentage < 60
              result = 'Barely 😶'
            when percentage == 69
              result = '( ͡° ͜ʖ ͡°)'
            when percentage < 70
              result = 'Not Bad 🙂'
            when percentage < 80
              result = 'Pretty Good 😃'
            when percentage < 90
              result = 'Great 😄'
            when percentage < 100
              result = 'Amazing 😍'
            else
              result = 'PERFECT! :heart_exclamation:'
          end

          response = "💗 **MATCHMAKING** 💗\n" +
              "First - #{first}\n" +
              "Second - #{second}\n" +
              "**-=-=-=-=-=-=-=-=-=-=-=-**\n" +
              "Result ~ #{percentage}% - #{result}\n"

          event.respond(response)
        },
        triggers: ['love', 'ship '],
        min_args: 1
    )
  end
end