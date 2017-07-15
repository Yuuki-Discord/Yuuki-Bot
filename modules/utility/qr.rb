# Copyright Erisa Komuro (Seriel), Spotlight 2016-2017

module YuukiBot
  module Utility

    require 'rqrcode'

    $cbot.add_command(:qr,
      code: proc { |event, args|
        tmp_path = "#{Dir.pwd}/tmp/qr.png"
        content = args.join(' ')
        # "Sanitize" qr code content
        if content.length >= 1000
          event.respond("#{YuukiBot.config['emoji_error']} QR codes have a limit of 1000 characters. You went over by #{content.length - 1000}!")
          break
        end
        qrcode = RQRCode::QRCode.new(content)
        FileUtils.mkdir("#{Dir.pwd}/tmp/") unless File.exist?("#{Dir.pwd}/tmp/")
        FileUtils.rm(tmp_path) if File.exist?(tmp_path)
        png = qrcode.as_png(
            file: tmp_path # path to write
        )
        event.channel.send_file(File.new(tmp_path), caption: "Here's your QR code:")
      },
      min_args: 1
    )

  end
end