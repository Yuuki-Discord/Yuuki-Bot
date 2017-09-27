# Copyright 2017 Seriel
module YuukiBot
  module Helper

    def self.save_donators
      folder = 'data'
      settingspath = "#{folder}/donators.yml"
      FileUtils.mkdir(folder) unless File.exist?(folder)
      File.open(settingspath, 'w') { |file| file.write(Data.donators) }
    end


    def self.save_stats
      folder = 'data'
      settingspath = "#{folder}/stats.yml"
      FileUtils.mkdir(folder) unless File.exist?(folder)
      File.open(settingspath, 'w') {|file| file.write("---\n:version: 1\n")} unless File.exist?(settingspath)
      YuukiBot.stats = {}
      YuukiBot.stats = YAML.load(File.read(settingsPath))
    end

    def self.save_saymap
      folder = 'data'
      settingspath = "#{folder}/stats.yml"
      FileUtils.mkdir(folder) unless File.exist?(folder)
      File.open(settingspath, 'w') {|file| file.write("---\n:version: 1\n")} unless File.exist?(settingspath)
      YuukiBot.saymap = {}
      YuukiBot.saymap = YAML.load(File.read(settingsPath))
    end

    def self.save_all
      save_donators
    end
  end

  module Data
    class << self
      attr_accessor :donators
    end
    @donators = []
    @donators = YAML.load_file('data/donators.yml') rescue []
  end
end