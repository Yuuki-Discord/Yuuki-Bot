# Copyright Erisa Komuro (Seriel) 2016-2017

module YuukiBot
  module Helper

    # Downloads an avatar when given a user object.
    # Returns the path of the downloaded file.
    def self.download_avatar(user, folder)
      return download_file(avatar_url(user), folder)
    end
      uri = URI.parse(url)
      # extension = File.extname(uri.path)
      filename = File.basename(uri.path)
      filename = if filename.start_with?('a_')
                   filename.gsub('.jpg', '.gif')
                 else
                   filename.gsub('.jpg', '.png')
                 end
      url << '?size=1024'
      url = "https://cdn.discordapp.com/avatars/#{user.id}/#{filename}?size=1024"
      url
    end
  end
end


def self.avatar_url(user)
        url = user.av