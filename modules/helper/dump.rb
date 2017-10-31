# Copyright Erisa Komuro (Seriel) 2016-2017

module YuukiBot
  module Helper

  # Dumps all messages in a given channel.
  # Returns the filepath of the file containing the dump.
  def self.dump_channel(channel, output_channel = nil, folder, timestamp)
    server = if channel.private?
               'DMs'
             else
               channel.server.name
             end
    message = "Dumping messages from channel \"#{channel.name.gsub('`', '\\`')}\" in #{server.gsub('`', '\\`')}, please wait...\n"
    output_channel.send_message(message) unless output_channel.nil?
    puts message

    unless channel.private?
      output_filename = "#{folder}/output_" + server + '_' + channel.server.id.to_s + '_' + channel.name + '_' + channel.id.to_s + '_' + timestamp.to_s + '.txt'
    else
      output_filename = "#{folder}/output_" + server + '_' + channel.name + '_' + channel.id.to_s + '_' + timestamp.to_s + '.txt'
    end
    output_filename = output_filename.tr(' ', '_').delete('+').delete('\\').delete('/').delete(':').delete('*').delete('?').delete('"').delete('<').delete('>').delete('|')

    output_file = File.open(output_filename, 'w')

    # Start on first message
    offset_id = channel.history(1, 1, 1)[0].id # get first message id
    message_count = 0

    # Now let's dump!
    loop do
      # We can only go through 100 messages at a time, so grab 100.
      current_history = channel.history(100, nil, offset_id).reverse
      # Break if there are no other messages
      break if current_history == []

      # Have a working string so we don't flog up disk writes
      to_write = ''
      current_history.each do |message|
        next if message.nil?
        author = if message.author.nil?
                   'Unknown User'
                 else
                   message.author.distinct
                 end
        time = message.timestamp
        content = message.content

        attachments = message.attachments

        to_write += "#{time} #{author}: #{content}\n"
        to_write += "\n<Attachments: #{attachments[0].filename}: #{attachments[0].url}}>\n" unless attachments.empty?
        message_count += 1
      end

      output_file.write(to_write)
      output_file.flush

      # Set offset ID to last message in history that we saw
      # (this is the last message sent - 1 since Ruby has array offsets of 0)
      offset_id = current_history[current_history.length - 1].id
    end
    output_file.close
    message = "#{message_count} messages logged."
    output_channel.send_message(message) unless output_channel.nil?
    puts message
    puts "Done. Dump file: #{output_filename}"
    output_filename
  end
  end
end
