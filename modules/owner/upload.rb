# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020
module YuukiBot
  module Owner
    YuukiBot.crb.add_command(
      :upload,
      triggers: %w[upload sendfile],
      arg_format: {
        filename: { name: 'filename', description: 'Name of file to upload', type: :remaining }
      },
      owners_only: true
    ) do |event, args|
      filename = args.filename
      event.channel.send_file File.new([filename].sample)
    end

    YuukiBot.crb.add_command(
      :rehost,
      triggers: %w[rehost sendurl],
      arg_format: {
        url: { name: 'url', description: 'URL of file to download', type: :remaining }
      },
      typing: true,
      owners_only: true
    ) do |event, args|
      file = Helper.download_file(args.url, 'tmp')
      Helper.upload_file(event.channel, file)
      event.message.delete
    end
  end
end
