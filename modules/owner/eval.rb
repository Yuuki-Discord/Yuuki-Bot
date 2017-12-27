# Copyright Erisa Komuro (Seriel) 2016-2017

module YuukiBot
  module Owner

    $cbot.add_command(:oldeval,
        code: proc { |event, args|
          event.respond(eval args.join(' '))
        },
        triggers: ['raweval ', 'oldeval'],
        owners_only: true
    )


    $cbot.add_command(:owners,
        code: proc { |event, _|
          owners = DB.execute("select id from userlist where is_owner=1").map {|v| v[0]}
          if owners.length.zero?
            event.channel.send_message('', false,
            Helper.error_embed(
             error: "No bot owners have been configured.",
             footer: "Command: `#{event.message.content}`",
             colour: 0xFA0E30,
             code_error: false
            )
          )
          end

          event << 'This bot instance is managed/owned by the following users. Please contact them for any issues.'
          owners.each {|x|
            event.bot.user(x).nil? ? event << "Unknown User (ID: `#{x}`)" : event << "- **#{event.bot.user(x).distinct}**"
          }
        },
        triggers: ['owners']
    )

    $cbot.add_command(:eval,
        code: proc { |event, args|
        begin
          result = eval args.join(' ')
          result = result.to_s
          if result.nil? || result == '' || result == ' ' || result == "\n"
            event << "#{YuukiBot.config['emoji_tickbox']} Done! (No output)"
            next
          end

          if result.length >= 1984
            event << "#{YuukiBot.config['emoji_warning']} Your output exceeded the character limit! (`#{result.length - 1984}`/`1984`)"
            event << "You can view the result here: https://hastebin.com/raw/#{$uploader.upload_raw(result)}"
          else
            event << "Output: ```\n#{result}```"
          end
          rescue Exception => e
          event.respond("#{YuukiBot.config['emoji_error']} An error has occured!! ```ruby\n#{e}```")
        end
        },
        triggers: ['eval2 ', 'eval'],
        owners_only: true,
        description: 'Evaluate a Ruby command. Owner only.',
    )

    $cbot.add_command(:bash,
      code: proc { |event, args|
        # Capture all output, including STDERR.
        result = `#{"#{args.join(' ')} 2>&1"} `
        if result.length >= 1984
          event << "#{YuukiBot.config['emoji_warning']} Your output exceeded the character limit by `#{result.length - 1984}` characters!"
          event << "You can view the result here: https://hastebin.com/raw/#{$uploader.upload_raw(result)}"
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
