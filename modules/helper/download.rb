# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020

module YuukiBot
  module Helper
    # Download a file from a url to a specified folder.
    # If no name is given, it will be taken from the url.
    # Returns the full path of the downloaded file.
    def self.download_file(url, folder, name = nil)
      name = File.basename(URI.parse(url).path) if name.nil?

      path = "#{folder}/#{name}".gsub('//', '/')

      FileUtils.mkdir_p(folder)
      FileUtils.rm_f(path)

      IO.copy_stream(URI.open(url), path)
      path
    end

    def self.upload_file(channel, filename)
      channel.send_file File.new([filename].sample)
      puts "Uploaded `#{filename} to ##{channel.name}!" if YuukiBot.config['debug']
    end
  end
end
