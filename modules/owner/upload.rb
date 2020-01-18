# Copyright Erisa A. (erisa.moe) 2016-2020
module YuukiBot
  module Owner

    $cbot.add_command(:upload,
      code: proc { |event, args|
        filename = args.join(' ')
        event.channel.send_file File.new([filename].sample)
      },
      triggers: %w(upload sendfile),
      owners_only: true
    )

    $cbot.add_command(:rehost,
      code: proc { |event, args|
        event.channel.start_typing
        url = args.join(' ')
        file = Helper.download_file(url, 'tmp')
        Helper.upload_file(event.channel, file)
        event.message.delete
      },
      triggers: %w(rehost sendurl),
      owners_only: true
    )

  end
end
