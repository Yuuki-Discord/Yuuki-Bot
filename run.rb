module YuukiBot
  require 'discordrb'
  require 'open-uri'
  require 'haste'
  require 'easy_translate'
  
  if ENV['COMMANDRB_PATH'].nil?
    require 'commandrb'
  else
    puts '[INFO] Loading commandrb from Environment location.'
    require_relative "#{ENV['COMMANDRB_PATH']}/lib/commandrb"
  end
  require_relative 'modules/config'
  require_relative 'modules/version'

  class CommandrbBot < CommandrbBot
    def is_owner?(id)
      if YuukiBot.config['master_owner'] == id
        true
      else
        !DB.execute("SELECT * FROM `userlist` WHERE `id` = #{id}")[0][1].zero?
      end
    end
  end

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
    puts 'Loading: Extra commands...' if @config['verbose']
    Dir['modules/extra/*.rb'].each { |r| require_relative r; puts "Loaded: #{r}" if @config['verbose'] }
  end

  require 'sqlite3'
  DB = SQLite3::Database.new "data/data.db"
  DB.execute("CREATE TABLE IF NOT EXISTS `userlist` (
    `id`	integer,
    `is_owner`	integer DEFAULT 0,
    `is_donator`	integer DEFAULT 0,
    `ignored`	integer DEFAULT 0,
    PRIMARY KEY(`id`));"
  )

  puts '>> Initial loading succesful!! <<'
  exit(1001) if YuukiBot.config['pretend_run']
  $uploader =  Haste::Uploader.new
  if YuukiBot.config['use_pry']
    $cbot.bot.run(true)
    require 'pry'
    binding.pry
  else
    $cbot.bot.run
  end
end
