module YuukiBot
  require 'discordrb'


  Dir['modules/commandrb/*.rb'].each do |r|
    require_relative r
  end

  require_relative 'modules/config.rb'

  init_hash = YuukiBot.build_init

  unless Commandrb.initialise(init_hash)
    puts 'Bot startup failed! Check your config.'
    exit(4)
  end

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
    require 'open-uri'
    # require 'flippy'
    Dir['modules/extra/*.rb'].each { |r| require_relative r; puts "Loaded: #{r}" if @config['verbose'] }
  end

  puts '>> Initial loading succesful!! <<'
  # exit(5) if config['pretend_run']
  Commandrb.bot.run
end
