# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe), spotlight_is_ok, Larsenv 2017-2020
module YuukiBot
  module Extra
    # Extra commands that are text-based.
    if YuukiBot.config['extra_commands']
      text_joke_commands = %w[doit pun wisdom lawyerjoke]
      text_joke_commands.each do |x|
        YuukiBot.crb.add_command(
          x.to_sym
        ) do |event|
          result = File.readlines("text/Jokes/#{x}.txt").sample.chomp

          event.respond("\\*#{result}*")
        end
        puts "Added jokes command for #{x}!" if YuukiBot.config['verbose']
      end

      text_other_commands = %w[vote topicchange fortunes factdiscord randomssmash4item]
      text_other_commands.each do |x|
        YuukiBot.crb.add_command(
          x.to_sym
        ) do |event|
          result = File.readlines("text/Other/Text/#{x}.txt").sample.chomp

          event.respond("\\*#{result}*")
        end
        puts "Added jokes command for #{x}!" if YuukiBot.config['verbose']
      end

      YuukiBot.crb.add_command(:confucious) do |event|
        response = File.readlines('text/Jokes/confucious.txt').sample.chomp
        event.respond("Confucious say #{response}")
      end
      puts 'Added jokes command for confucious!' if YuukiBot.config['verbose']

      text_attack_commands = %w[nk]
      text_attack_commands.each do |x|
        YuukiBot.crb.add_command(
          x.to_sym
        ) do |event, _args|
          result = File.readlines("text/Attack/Text/#{x}.txt").sample.chomp

          event.respond("\\*#{result}*")
        end
        puts "Added attack command for #{x}!" if YuukiBot.config['verbose']
      end

      text_attack_commands = %w[lart insult]
      text_attack_commands.each do |x|
        YuukiBot.crb.add_command(
          x.to_sym
        ) do |event, args|
          result = File.readlines("text/Attack/Text/#{x}.txt").sample.chomp
          if /{user}/ =~ result
            result = result.gsub('{user}',
                                 Extra.calculate_mention(event, args))
          end

          event.respond("\\*#{result}*")
        end
        puts "Added attack command for #{x}!" if YuukiBot.config['verbose']
      end

      YuukiBot.crb.add_command(:bookpun) do |event|
        title, author = File.readlines('text/Jokes/bookpun.txt').sample.chomp.split ': ',
                                                                                    2
        event.respond("#{title} by #{author}")
      end
      puts 'Added jokes command for bookpun!' if YuukiBot.config['verbose']

      YuukiBot.crb.add_command(:eightball) do |event|
        result = File.readlines('text/Other/8ball_responses.txt').sample.chomp
        event.respond("shakes the magic 8 ball... **#{result}**")
      end
      puts 'Added fun command for eightball!' if YuukiBot.config['verbose']
    end
  end
end
