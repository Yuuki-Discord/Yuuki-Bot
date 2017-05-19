# Copyright Seriel 2016-2017

module YuukiBot
  module Owner

    Commandrb.commands[:eval] = {
      code: proc { |event, args|
        eval args.join(' ')
      },
      triggers: ['eval '],
    }

    Commandrb.commands[:evaltwo] = {
        code: proc { |event, args|
        begin
          result = eval args.join(' ')
          if result.length >= 1984
            puts result
            event << "⚠ Your output exceeded the character limit! (`#{result.length - 1984}`/`1984`)"
            event << 'The result has been logged to the terminal instead :3'
          else
            event << ((result.nil? || result == '' || result == ' ' || result == "\n") ? '✅ Done! (No output)' : "Output: ```\n#{result}```")
          end
          rescue Exception => e
          event.respond(":x: An error has occured!! ```ruby\n#{e}```")
        end
        },
        triggers: ['eval2 '],
        owners_only: true,
        description: 'Evaluate a Ruby command. Owner only.',
    }

    Commandrb.commands[:bash] = {
      code: proc { |event, args|
        # Capture all output, including STDERR.
        result = `#{"#{args.join(' ')} 2>&1"} `
        if result.length >= 1984
          puts result
          event << "⚠ Your output exceeded the character limit! (`#{result.length - 1984}`/`1984`)"
          event << 'The result has been logged to the terminal instead :3'
        else
          event << ((result.nil? || result == '' || result == ' ' || result == "\n") ? '✅ Done! (No output)' : "Output: ```\n#{result}```")
        end
      },
      triggers: ['bash ', 'sh ', 'shell ', 'run '],
      owners_only: true,
      description: 'Evaluate a Bash command. Owner only. Use with care.',
    }

  end
end
