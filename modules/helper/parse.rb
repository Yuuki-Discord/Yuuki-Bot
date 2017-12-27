# Copyright Erisa Komuro (Seriel), Spotlight 2016-2017

module YuukiBot
  module Helper

    # Accepts a message, and returns the message content, with all mentions + channels replaced with @user#1234 or #channel-name
   def self.parse_mentions(content)
      # Replace user IDs with names
      loop do
          match = /<@\d+>/.match(content)
          break if match.nil?
          # Get user
          id = match[0]
          # We have to sub to just get the numerical ID.
          num_id = /\d+/.match(id)[0]
          content = content.sub(id, get_user_name(num_id))
      end
      loop do
          match = /<@!\d+>/.match(content)
          break if match.nil?
          # Get user
          id = match[0]
          # We have to sub to just get the numerical ID.
          num_id = /\d+/.match(id)[0]
          content = content.sub(id, get_user_name(num_id))
      end
      # Replace channel IDs with names
      loop do
          match = /<#\d+>/.match(content)
          break if match.nil?
          # Get channel
          id = match[0]
          # We have to gsub to just get the numerical ID.
          num_id = /\d+/.match(id)[0]
          content = content.sub(id, get_channel_name(num_id))
      end
      content
    end
  
    # Returns a user-readable username for the specified ID.
    def self.get_user_name(user_id)
        return begin
          '@' + $cbot.bot.user(user_id).distinct
        rescue NoMethodError
          '@invalid-user'
        end
    end

    # Returns a user-readable channel name for the specified ID.
    def self.get_channel_name(channel_id)
      return  begin
                '#' + $cbot.bot.channel(channel_id).name
              rescue NoMethodError
                '#deleted-channel'
              end
    end

    def self.filter_everyone(text)
      # Place a null into @everyone and @here, to prevent accidental tagging. Returns the parsed text.
      return text.gsub('@everyone', "@\x00everyone").gsub('@here', "@\x00here")
    end

   # Detects which user you are talking about from a word.
   def self.userparse(word)
     # Trial and error, ho!

     # If its an ID.
     unless $cbot.bot.user(word).nil?
       return $cbot.bot.user(word)
     end

     # If its a mention!
     begin
      unless /\d+/.match(/<@\d+>/.match(word).to_s)[0].nil?
        return $cbot.bot.user(/\d+/.match(/<@\d+>/.match(word).to_s)[0])
      end
     rescue
      # ignored
     end

     # Might be a username...
     unless $cbot.bot.find_user(word).nil?
       return $cbot.bot.find_user(word)[0]
     end

     return nil
   end
  end
end
