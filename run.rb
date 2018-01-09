module YuukiBot
  require 'easy_translate'
  require 'haste'
  require 'open-uri'
  require 'sqlite3'
  
  if ENV['COMMANDRB_PATH'].nil?
    require 'commandrb'
  else
    puts '[INFO] Loading commandrb from Environment location.'
    require_relative "#{ENV['COMMANDRB_PATH']}/lib/commandrb"
  end

  if ENV['DISCORDRB_PATH'].nil?
    require 'discordrb'
  else
    puts '[INFO] Loading discordrb from Environment location.'
    require_relative "#{ENV['DISCORDRB_PATH']}/lib/discordrb"
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

  unless File.exists?('data/data.db')
    DB = SQLite3::Database.new "data/data.db"
    DB.execute("CREATE TABLE `userlist` (
        `id`	integer NOT NULL,
        `is_owner`	integer NOT NULL DEFAULT 0,
        `is_donator`	integer NOT NULL DEFAULT 0,
        `ignored`	integer NOT NULL DEFAULT 0,
        `exp`	INTEGER NOT NULL DEFAULT 0,
        `level`	INTEGER NOT NULL DEFAULT 1,
        PRIMARY KEY(`id`)
      );"
    )
  end


  $cbot.bot.message do |event|
    Helper.calc_exp(event.user.id)
  end

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
