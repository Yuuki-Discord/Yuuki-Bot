# frozen_string_literal: true

# Copyright Erisa A. (erisa.moe) 2016-2020

module YuukiBot
  module Helper
    def self.role_hierarchy(member)
      return 999 if member.owner?
      return 0 if member.roles.empty?

      member.roles.max_by(&:position).position
    end

    def self.allowed_to_mod(invoker, target)
      role_hierarchy(invoker) > role_hierarchy(target)
    end
  end
end
