# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe), Spotlight 2016-2020

module YuukiBot
  module Helper
    # Places a null into @everyone and @here to prevent accidental tagging. Returns the parsed text.
    def self.filter_everyone(text)
      text.gsub('@everyone', "@\x00everyone").gsub('@here', "@\x00here")
    end

    # Detects which user you are talking about from a word.
    def self.userparse(word)
      # Trial and error, ho!
      bot = YuukiBot.crb.bot

      # Can't do anything if there's nothing to begin with.
      return nil if word.nil?

      # Catches things such as "0": obviously invalid, attempted nonetheless.
      word = word.to_s

      # If it's an ID.
      id_check = bot.user(word)
      return id_check unless id_check.nil?

      # If it's a mention!
      matches = /<@!?(\d+)>/.match(word)
      return bot.user(matches[1]) unless matches.nil?

      # Might be a username...
      return bot.find_user(word)[0] unless bot.find_user(word).nil?

      nil
    end

    def self.userid_to_string(id)
      bot = YuukiBot.crb.bot
      bot.user(id).nil? ? "Unknown User (ID: #{id})" : bot.user(id).distinct.to_s
    end
  end
end
