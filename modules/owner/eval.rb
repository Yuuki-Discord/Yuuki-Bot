# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020

module YuukiBot
  module Owner
    $cbot.add_command(:oldeval,
                      code: proc { |event, args|
                        event.respond(eval(args.join(' ')))
                      },
                      triggers: ['raweval ', 'oldeval'],
                      owners_only: true)

    $cbot.add_command(:eval,
                      code: proc { |event, args|
                        begin
                          msg = event.respond "#{YuukiBot.config['emoji_loading']} Evaluating..."
                          init_time = Time.now
                          result = eval args.join(' ')
                          result = result.to_s
                          if result.nil? || result == '' || result == ' ' || result == "\n"
                            msg.edit "#{YuukiBot.config['emoji_tickbox']} Done! (No output)\nCommand took #{(Time.now - init_time)} seconds to execute!"
                            next
                          end
                          str = ''
                          if result.length >= 1984
                            str << "#{YuukiBot.config['emoji_warning']} Your output exceeded the character limit! (`#{result.length - 1984}`/`1984`)"
                            str << "You can view the result here: https://paste.erisa.moe/raw/#{$uploader.upload_raw(result)}\nCommand took #{(Time.now - init_time)} seconds to execute!"
                          else
                            str << "Output: ```\n#{result}```Command took #{(Time.now - init_time)} seconds to execute!"
                          end
                          msg.edit(str)
                        rescue Exception => e
                          msg.edit("#{YuukiBot.config['emoji_error']} An error has occured!! ```ruby\n#{e}```\nCommand took #{(Time.now - init_time)} seconds to execute!")
                        end
                      },
                      triggers: ['eval2 ', 'eval'],
                      owners_only: true,
                      description: 'Evaluate a Ruby command. Owner only.')

    $cbot.add_command(:bash,
                      code: proc { |event, args|
                        init_time = Time.now
                        msg = event.respond "#{YuukiBot.config['emoji_loading']} Evaluating..."
                        # Capture all output, including STDERR.
                        result = `#{"#{args.join(' ')} 2>&1"} `
                        result = result.to_s
                        if result.nil? || result == '' || result == ' ' || result == "\n"
                          msg.edit "#{YuukiBot.config['emoji_tickbox']} Done! (No output)\nCommand took #{(Time.now - init_time)} seconds to execute!"
                          next
                        end
                        str = ''
                        if result.length >= 1984
                          str << "#{YuukiBot.config['emoji_warning']} Your output exceeded the character limit! (`#{result.length - 1984}`/`1984`)"
                          str << "You can view the result here: https://paste.erisa.moe/raw/#{$uploader.upload_raw(result)}\nCommand took #{(Time.now - init_time)} seconds to execute!"
                        else
                          str << "Output: ```\n#{result}```Command took #{(Time.now - init_time)} seconds to execute!"
                        end
                        msg.edit(str)
                      },
                      triggers: ['bash ', 'sh ', 'shell ', 'run '],
                      owners_only: true,
                      description: 'Evaluate a Bash command. Owner only. Use with care.')
  end
end
