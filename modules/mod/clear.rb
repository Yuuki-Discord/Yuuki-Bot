# Copyright Erisa Arrowsmith (Seriel) 2016-2017

module YuukiBot
  module Mod

    $cbot.add_command(:clear,
      code: proc { |event, args|
        unless /\A\d+\z/ =~ args[0]
            event.respond("`#{args[0]}` is not a valid number!")
            break
        end
        original_num = args[0].to_i
        clearnum = original_num + 1

        if clearnum >= 100
          message = "#{YuukiBot.config['emoji_warning']} You are attempting to clear more than 100 messages.\n"
          message << "To avoid rate limiting, the clearing will be done 99 messages at a time, so it might take a while.\n"
          message << 'This message will vanish in 5 seconds and the clearing will begin, please wait..'
          event.respond(message)
          sleep(5)
        elsif clearnum > 1000
          message = "The maximum number of messages I can clear is 1000!"
          event.respond(message)
          break
        end

        begin
          while clearnum > 0
              if clearnum >= 99
                  ids = Array.new
                  event.channel.history(99).each { |x| ids.push(x.id) }
                  Discordrb::API::Channel.bulk_delete_messages(event.bot.token, event.channel.id, ids)
                  clearnum -= 99
                  sleep(4)
              else
                  ids = Array.new
                  event.channel.history(clearnum).each { |x| ids.push(x.id) }
                  Discordrb::API::Channel.bulk_delete_messages(event.bot.token, event.channel.id, ids)
                  clearnum = 0
              end
          end
          event.respond("#{YuukiBot.config['emoji_clear']} Cleared #{original_num} messages!\nResponsible Moderator: #{event.user.mention}\n(Messages older than 2 weeks will not have been deleted. Please use `forceclear` in those cases.)")
        rescue Discordrb::Errors::NoPermission
          event.respond("#{YuukiBot.config['emoji_success']} Message delete failed!\nCheck the permissions?")
          break
        end
        nil
      },
      triggers: ['clear', 'clean'],
      server_only: true,
      required_permissions: [:manage_messages],
      owner_override: false,
      max_args: 1
    )

    $cbot.add_command(:forceclear,
       code: proc { |event, args|
         unless /\A\d+\z/ =~ args[0]
           event.respond("`#{args[0]}` is not a valid number!")
           break
         end
         original_num = args[0].to_i
         clearnum = original_num + 1

         if clearnum > 20
           message = "#{YuukiBot.config['emoji_warning']} You are attempting a force clear on a large number of messages.\n"
           message << 'Force clears are much slower than ordinary clears, but can delete messages older than 2 weeks.'
           message << 'This message will vanish in 5 seconds and the clearing will begin, please wait..'
           event.respond(message)
           sleep(5)
         elsif clearnum > 1000
           message = "I can only clear a maximum of 1000 messages!"
           event.respond(message)
           break
         end

         begin
           while clearnum > 0
             if clearnum >= 99
               ids = Array.new
               event.channel.history(99).each { |x| x.delete }
               clearnum -= 99
               sleep(4)
             else
               ids = Array.new
               event.channel.history(clearnum).each { |x| x.delete }
               clearnum = 0
             end
           end
           # Emoji below is a trash can icon thingy.
           event.respond("#{YuukiBot.config['emoji_clear']} Cleared #{original_num} messages!")

           # On second thought, that's annoying.

           #~ sleep(3)
           #~ message.delete
         rescue Discordrb::Errors::NoPermission
           event.respond("#{YuukiBot.config['emoji_success']} Message delete failed!\nCheck the permissions?")
           break
         end
         nil
       },
      triggers: ['clear', 'clean'],
      server_only: true,
      required_permissions: [:manage_messages],
      owner_override: false,
      max_args: 1
    )
  end
end
