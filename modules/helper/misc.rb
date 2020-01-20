# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020

module YuukiBot
  module Helper
    def self.isadmin?(member)
      Commandrb.owners.include?(member)
    end

    def self.quit(status = 0)
      puts 'Exiting...'
      begin
        YuukiBot.crb.bot.stop
      rescue StandardError
        YuukiBot.crb.bot.invisible
      end
      exit(status)
    end

    def self.ctrl_c(type)
      puts "[WARN] #{type} detected, safely shutting down...."
      YuukiBot.crb.bot.stop
      exit(0)
    end
    trap('SIGINT') { ctrl_c('SIGINT') }
    trap('SIGTERM') { ctrl_c('SIGTERM') }

    def self.role_from_name(server, rolename)
      server.roles.select { |r| r.name == rolename }.first
    end

    # Get the user's color
    def self.colour_from_user(member, default = 0)
      color = default
      unless member.nil?
        member.roles.sort_by(&:position).reverse.each do |role|
          next if role.color.combined == 0

          begin
            if YuukiBot.config['debug']
              puts 'Using ' + role.name + '\'s color ' + role.color.combined.to_s
            end
          rescue StandardError
            nil
          end
          color = role.color.combined
          break
        end
      end
      color
    end
  end
end
