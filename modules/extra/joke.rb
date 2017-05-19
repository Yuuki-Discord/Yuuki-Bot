# Copyright Seriel, spotlight_is_ok, Larsenv 2017
module YuukiBot
  module Extra
    text_joke_commands = %w(doit pun wisdom lawyerjoke)
    text_joke_commands.each { |x|
      Commandrb.commands[x.to_sym] = {
          code: proc { |event|
            result = File.readlines("text/Jokes/#{x}.txt").sample.chomp

            event.respond("*#{result}*")
          },
      }
    }

    text_other_commands = %w(vote topicchange fortunes factdiscord randomssmash4item)
    text_other_commands.each { |x|
      Commandrb.commands[x.to_sym] = {
          code: proc { |event|
            result = File.readlines("text/Other/Text/#{x}.txt").sample.chomp

            event.respond("*#{result}*")
          },
      }
    }

    Commandrb.commands[:confucious] = {
        code: proc { |event,args|
          event.respond("Confucious say #{File.readlines('text/Jokes/confucious.txt').sample.chomp}")
        },
    }
  end
end