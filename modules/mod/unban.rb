# Copyright Seriel 2016-2017

module YuukiBot
  module Mod

    # noinspection RubyResolve
    Commandrb.commands[:unban] = {
      code: proc { |event, args|
        target_id = args[0]
        target = event.server.bans.select { |x| x.id == target_id }
        if target == [] or target.nil?
          event.respond("❌ Failed to find user with ID `#{target_id}!`")
          break
        end
        begin
          event.server.unban(target)
        rescue Discordrb::Errors::NoPermission
          event.respond("❌ I don't have permission to unban #{target.name}!")
        end
      },
      max_args: 1,
      server_only: true,
      required_permissions: [:ban_members]
    }

  end
end
