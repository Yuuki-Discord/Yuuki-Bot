# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020
module YuukiBot
  module Owner
    YuukiBot.crb.add_command(
      :upload,
      triggers: %w[upload sendfile],
      owners_only: true
    ) do |event, args|
      filename = args.join(' ')
      event.channel.send_file File.new([filename].sample)
    end

    YuukiBot.crb.add_command(
      :rehost,
      triggers: %w[rehost sendurl],
      owners_only: true
    ) do |event, args|
      event.channel.start_typing
      url = args.join(' ')
      file = Helper.download_file(url, 'tmp')
      Helper.upload_file(event.channel, file)
      event.message.delete
    end
  end
end
