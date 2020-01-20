# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020

module YuukiBot
  module Owner
    $cbot.add_command(:oldeval,
                      code: proc { |event, args|
                        event.respond(eval(args.join(' ')))
                      },
                      triggers: ['raweval ', 'oldeval '],
                      owners_only: true)

    $cbot.add_command(:eval,
                      code: proc { |event, args|
                        begin
                          msg = event.respond "#{YuukiBot.config['emoji_loading']} Evaluating..."
                          init_time = Time.now
                          result = eval args.join(' ')
                          result_output = handle_result(result, init_time)
                          msg.edit(result_output)
                        rescue Exception => e
                          msg.edit("#{YuukiBot.config['emoji_error']} An error has occurred!"\
                          "```ruby\n#{e}```" \
                          "Command took #{(Time.now - init_time)} seconds to execute!")
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
                        result_output = handle_result(result, init_time)
                        msg.edit(result_output)
                      },
                      triggers: ['bash ', 'sh ', 'shell ', 'run '],
                      owners_only: true,
                      description: 'Evaluate a Bash command. Owner only. Use with care.')

    # Formulates results to an external source or character-specific message.
    # @param [Object] result_output Returned result of an operation.
    # @param [Class<Time>] start_time The starting time of execution.
    # @param [Class<Time>] finish_time The ending time of execution.
    # @return [String (frozen)] Human-readable format of given execution
    def self.handle_result(result_output, start_time, finish_time = Time.now)
      output = ''

      result = result_output.to_s
      if result.nil? || result == '' || result == ' ' || result == "\n"
        output += '' "#{YuukiBot.config['emoji_tickbox']} Done! (No output)"
      elsif result.length >= 1984
        uploader_domain = $uploader.server_url
        uploader_file = $uploader.upload_raw(result)

        output += "#{YuukiBot.config['emoji_warning']}" \
        'Your output exceeded the character limit! ' \
        "(`#{result.length - 1984}`/`1984`)\n" \
        "You can view the result here: #{uploader_domain}/raw/#{uploader_file}"
      else
        output += "Output: ```\n#{result}```"
      end

      output += "Command took #{(finish_time - start_time)} seconds to execute!"
      output
    end
  end
end
