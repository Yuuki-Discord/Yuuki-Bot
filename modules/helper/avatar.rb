# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020

module YuukiBot
  module Helper
    # Downloads an avatar when given a user object.
    # Returns the path of the downloaded file.
    def self.download_avatar(user, folder)
      download_file(avatar_url(user), folder)
    end

    def self.avatar_url(user)
      url = user.avatar_url
      uri = URI.parse(url)
      filename = File.basename(uri.path)
      changed_filename = if filename.start_with?('a_')
                           filename.gsub('.jpg', '.gif')
                         else
                           filename.gsub('.jpg', '.png')
                         end
      "https://cdn.discordapp.com/avatars/#{user.id}/#{changed_filename}?size=4096"
    end
  end
end
