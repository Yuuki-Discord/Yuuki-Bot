# Copyright Erisa Arrowsmith 2016-2017
module YuukiBot
  module Utility
    require 'easy_translate'

    $cbot.add_command(:translate,
        code: proc {|event,args|
            lang = args[0]
            args.shift
            text = args.join(' ')
            result = EasyTranslate.translate(text, :to => lang)
            
            event.channel.send_embed("#{YuukiBot.config['emoji_translate']} Your translation has completed!") do |embed|
              embed.colour = 0x4c8bf5
              embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "All information provided by Google Translate API.", icon_url: "https://cdn.discordapp.com/emojis/329193279595741185.png")
              embed.add_field(name: "Original text:", value: text)
              embed.add_field(name: "Translated text (#{lang}):", value: result)
            end
        },
        catch_errors: true
    )
      
  end
end
  