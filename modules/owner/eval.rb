# Copyright Seriel 2016-2017

module YuukiBot
  module Owner

    Commandrb.commands[:eval] = {
      code: proc { |event, args|
        eval args.join(' ')
      },
      triggers: ['eval'],
      owners_only: true,
      description: 'Evaluate a Ruby command. Owner only.',
    }
    
    Commandrb.commands[:evaltwo] = {
      code: proc { |event, args|
        begin
          result = eval args.join(' ')
          event << ((result.nil? || result == '' || result == ' ' || result == "\n") ? '✅ Done! (No output)' : "Output: ```\n#{result}```")
        rescue Exception => e
          event.respond(":x: An error has occured!! ```ruby\n#{e}```")
        end
      },
      triggers: ['2eval'],
      owners_only: true,
      description: 'Evaluate a Ruby command. Owner only.',
    }

    # noinspection RubyResolve
    Commandrb.commands[:message] = {
      code: proc { |event, args|
        result = eval args.join(' ')
        event.user.pm(result)
        event.respond('DMed you the command result ;)')
      },
      triggers: ['message'],
      owners_only: true,
      description: 'Send the result of an eval in PM. Owner only.',
    }

    Commandrb.commands[:bash] = {
      code: proc { |event, args|
        # Capture all output, including STDERR.
        result = `#{"#{args.join(' ')} 2>&1"} `
        event << ((result.nil? || result == '' || result == ' ' || result == "\n") ? '✅ Done! (No output)' : "Output: ```\n#{result}```")
      },
      triggers: ['bash', 'sh', 'run'],
      owners_only: true,
      description: 'Evaluate a Bash command. Owner only. Use with care.',
    }

  end
end
