module YuukiBot
  require 'discordrb'
  require 'open-uri'
  require 'commandrb'

  require_relative 'modules/config.rb'

  init_hash = YuukiBot.build_init

  $cbot = CommandrbBot.new(init_hash)

  module_dirs = %w(owner helper logging misc mod utility)
  module_dirs.each {|dir|
    Dir["modules/#{dir}/*.rb"].each { |r|
     require_relative r
     puts "Loaded: #{r}" if @config['verbose']
    }
  }

  # Load Extra Commands if enabled.
  if YuukiBot.config['extra_commands']
    require 'json'
    # require 'flippy'
    puts 'Loading: Extra commands...' if @config['verbose']
    Dir['modules/extra/*.rb'].each { |r| require_relative r; puts "Loaded: #{r}" if @config['verbose'] }
  end

  puts '>> Initial loading succesful!! <<'
  $cbot.add_command('whooo', triggers: ['who are you'], code: proc {|event,_|
      event.respond('http://owarinoseraph.wikia.com/wiki/Tomoe_Saotome')
    }
  )
  $cbot.bot.run
end
