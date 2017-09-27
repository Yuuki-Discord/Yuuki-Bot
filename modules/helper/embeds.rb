# Copyright Erisa Komuro (Seriel) 2017

module YuukiBot
  module Helper

    def self.error_embed(error: nil, footer: nil, colour: nil, color: nil, code_error: true)
      if error.nil? or footer.nil?
        raise 'Invalid arguments for Helper.error_embed!'
      else
        if color.nil? and colour.nil?
          colour = 0x22ef1f
        end
        Discordrb::Webhooks::Embed.new(
          title:  '❌ An error has occured!',
          description: code_error ?  "```ruby\n#{error}```" :  error,
          colour: colour || color,
          footer: Discordrb::Webhooks::EmbedFooter.new(text: footer)
        )
      end
    end

    def self.avatar_embed(color: nil, colour: nil, url: nil, username: nil, time: Time.now.getutc.asctime)
      if url.nil?
        raise 'Invalid arguments for Helper.avatar_embed!'
      else
        if color.nil? and colour.nil?
          colour = 0x22ef1f
        end
        username = username.nil? ? 'Unknown User' : username
        Discordrb::Webhooks::Embed.new(
          colour: colour || color,
          image: Discordrb::Webhooks::EmbedImage.new(url: url),
          author: Discordrb::Webhooks::EmbedAuthor.new(name: "Avatar for #{username}", url: url),
          footer: Discordrb::Webhooks::EmbedFooter.new(text: "Avatar correct as of #{time}")
        )
      end
    end

  end
end
