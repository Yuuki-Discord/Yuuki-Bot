# Copyright Seriel 2016-2017

module YuukiBot
  module Helper

    def self.isadmin?(member)
      Commandrb.owners.include?(member)
    end

    def self.quit
      puts 'Exiting...'
      exit
    end

    def self.role_from_name(server, rolename)
      return server.roles.select { |r| r.name == rolename }.first
    end
  end
end

module Discordrb
  module Cache
    def find_user(username)
      @users.values.find_all { |e| e.username.includes? username }
    end
  end
end
