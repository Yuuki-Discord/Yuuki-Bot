# Copyright 2017 Seriel
module YuukiBot
  module Helper

    def self.save_settings
      folder = 'data'
      settingspath = "#{folder}/settings.yml"
      FileUtils.mkdir(folder) unless File.exist?(folder)
      unless File.exist?(settingspath)
        File.open(settingspath, 'w') { |file| file.write("---\n:version: 1\n") }
      end
      Data.settings = {}
      Data.settings = YAML.load(File.read(settingsPath))
    end

    def self.save_stats
      folder = 'data'
      settingspath = "#{folder}/stats.yml"
      FileUtils.mkdir(folder) unless File.exist?(folder)
      unless File.exist?(settingspath)
        File.open(settingspath, 'w') { |file| file.write("---\n:version: 1\n") }
      end
      YuukiBot.stats = {}
      YuukiBot.stats = YAML.load(File.read(settingsPath))
    end

    def self.save_saymap
      folder = 'data'
      settingspath = "#{folder}/stats.yml"
      FileUtils.mkdir(folder) unless File.exist?(folder)
      unless File.exist?(settingspath)
        File.open(settingspath, 'w') { |file| file.write("---\n:version: 1\n") }
      end
      YuukiBot.saymap = {}
      YuukiBot.saymap = YAML.load(File.read(settingsPath))
    end

    def self.save_all

    end

    def self.shutdown

    end
  end
end