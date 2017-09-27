# Copyright Erisa Komuro (Seriel) 2016-2017

module YuukiBot
  module Helper

    # Download a file from a url to a specified folder.
    # If no name is given, it will be taken from the url.
    # Returns the full path of the downloaded file.
    def self.download_file(url, folder, name = nil)
      if name.nil?
        name = File.basename(URI.parse(url).path) if name.nil?
      end

      path = "#{folder}/#{name}".gsub('//', '/')

      FileUtils.mkdir(folder) unless File.exist?(folder)
      FileUtils.rm(path) if File.exist?(path)

      IO.copy_stream(open(url), path)
      return path
    end

    def self.upload_file(channel, filename)
      channel.send_file File.new([filename].sample)
      puts "Uploaded `#{filename} to \##{channel.name}!" if YuukiBot.config['debug']
    end
  end
end
