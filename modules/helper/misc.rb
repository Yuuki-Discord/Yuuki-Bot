# Copyright Erisa Komuro (Seriel) 2016-2017

module YuukiBot
  module Helper

    def self.isadmin?(member)
      Commandrb.owners.include?(member)
    end

    def self.quit(status = 0)
      puts 'Exiting...'
      exit(status)
    end

    def self.role_from_name(server, rolename)
      return server.roles.select { |r| r.name == rolename }.first
    end

    # Get the user's color
    def self.colour_from_user(member, default = 0)
      colour = default
      unless member.nil?
        member.roles.sort_by(&:position).reverse.each do | role |
          next if role.color.combined == 0
          puts 'Using ' + role.name + '\'s color ' + role.color.combined.to_s if YuukiBot.config['verbose']
          colour = role.colour.combined
          break
        end
      end
      return colour
    end

  end
end
