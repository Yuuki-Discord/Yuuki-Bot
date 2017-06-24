# Copyright Seriel 2016-2017

module YuukiBot
  module Owner

    $cbot.add_command(:eval,
        code: proc { |_, args|
          eval args.join(' ')
        },
        triggers: ['eval '],
        owners_only: true
    )

    $cbot.add_command('eval',
      triggers: ['eval '],
      owners_only: true
    )
    {
        code: proc { |_, args|
          eval args.join(' ')
        },

    }

    $cbot.add_command(:owners,
        code: proc { |event, _|
          event << 'This bot instance is managed/owned by the following users. Please contact them for any issues.'
          YuukiBot.config['owners'].each { |x| event << "`#{event.bot.user(x).distinct}`" }
        },
        triggers: ['owners']
    )

    $cbot.add_command(:evaltwo,
        code: proc { |event, args|
        begin
          result = eval args.join(' ')
          result = result.to_s
          if result.nil? || result == '' || result == ' ' || result == "\n"
            event << "#{YuukiBot.config['emoji_tickbox']} Done! (No output)"
            next
          end

          if result.length >= 1984
            puts result
            event << "#{YuukiBot.config['emoji_warning']} Your output exceeded the character limit! (`#{result.length - 1984}`/`1984`)"
            event << 'The result has been logged to the terminal instead :3'
          else
            event << "Output: ```\n#{result}```"
          end
          rescue Exception => e
          event.respond(":x: An error has occured!! ```ruby\n#{e}```")
        end
        },
        triggers: ['eval2 '],
        owners_only: true,
        description: 'Evaluate a Ruby command. Owner only.',
    )

    $cbot.add_command(:bash,
      code: proc { |event, args|
        # Capture all output, including STDERR.
        result = `#{"#{args.join(' ')} 2>&1"} `
        if result.length >= 1984
          puts result
          event << "#{YuukiBot.config['emoji_warning']} Your output exceeded the character limit! (`#{result.length - 1984}`/`1984`)"
          event << 'The result has been logged to the terminal instead :3'
        else
          event << ((result.nil? || result == '' || result == ' ' || result == "\n") ? "#{YuukiBot.config['emoji_tickbox']} Done! (No output)" : "Output: ```\n#{result}```")
        end
      },
      triggers: ['bash ', 'sh ', 'shell ', 'run '],
      owners_only: true,
      description: 'Evaluate a Bash command. Owner only. Use with care.'
    )

  end
end
