# Copyright Seriel 2016-2017

module YuukiBot
  module Helper
  def self.parse_history(hist, count)
    messages = []
    i = 0
    until i == hist.length
      message = hist[i]
      author = message.author.nil? ? 'Unknown User' : message.author.distinct
      time = message.timestamp
      content = message.content
      attachments = message.attachments
      messages[i] = "--#{time} #{author}: #{content}"
      messages[i] += "\n<Attachments: #{attachments[0].filename}: #{attachments[0].url}}>" unless attachments.empty?
      i += 1

      count += 1
    end
    return_value = [count, messages]
    return_value
  end

  # Dumps all messages in a given channel.
  # Returns the filepath of the file containing the dump.
  def self.dump_channel(channel, output_channel = nil, folder, timestamp)
    server = channel.private? ? 'DMs' : channel.server.name
    message = "Dumping messages from channel \"#{channel.name.gsub('`', '\\`')}\" in #{server.gsub('`', '\\`')}, please wait..."
    output_channel.send_message(message) unless output_channel.nil?
    puts message

    output_filename = !channel.private? ? "#{folder}/output_" + server + '_' + channel.server.id.to_s + '_' + channel.name + '_' + channel.id.to_s + '_' + timestamp.to_s + '.txt' :
      "#{folder}/output_" + server + '_' + channel.name + '_' + channel.id.to_s + '_' + timestamp.to_s + '.txt'
    output_filename = output_filename.tr(' ', '_').delete('+').delete(':').delete('*').delete('?').delete('"').delete('<').delete('>').delete('|')
    hist_count_and_messages = [[], [0, []]]

    output_file = File.open(output_filename, 'w')
    offset_id = channel.history(1, 1, 1)[0].id # get first message id

    # Now let's dump!
    loop do
      hist_count_and_messages[0] = channel.history(100, nil, offset_id) # next 100
      break if hist_count_and_messages[0] == []
      hist_count_and_messages[1] = parse_history(hist_count_and_messages[0], hist_count_and_messages[1][0])
      output_file.write((hist_count_and_messages[1][1].reverse.join("\n") + "\n").encode('UTF-8')) # write to file right away, don't store everything in memory
      output_file.flush # make sure it gets written to the file
      offset_id = hist_count_and_messages[0][0].id
    end
    output_file.close
    message = "#{hist_count_and_messages[1][0]} messages logged."
    output_channel.send_file(File.open(output_filename, 'r'), caption: message) unless output_channel.nil?
    puts message
    puts "Done. Dump file: #{output_filename}"
  end
  end
end
