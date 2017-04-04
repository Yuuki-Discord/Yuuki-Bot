# Copyright Seriel 2016-2017

module YuukiBot
  module Helper

    # Downloads an avatar when given a user object.
    # Returns the path of the downloaded file.
    def self.download_avatar(user, folder)
      return download_file(avatar_url(user), folder)
    end

    def self.avatar_url(user)
      return "https://cdn.discordapp.com/avatars/#{user.id}/#{File.basename(URI.parse(user.avatar_url).path).start_with?('a_') ? filename.gsub('.jpg', '.gif') : filename.gsub('.jpg', '.png')}?size=256"
    end
  end
end
