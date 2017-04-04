```ruby
module Commandrb
  @commands = {}
  #--------------------------------------------------------------------------
  # * Two different examples of making a command.
  #--------------------------------------------------------------------------
  @commands[:eval] = {
      :code => proc { |_, args|
      eval args.join(' ')
    },
      :triggers => %w(eval ebal reval rubyeval), # Array of triggers.
      :prefixes => nil, # Use the default(s) only.
      :owners_only => true,
  }

  @commands[:say] = {}
  @commands[:say][:code] = proc { |event, args|
    # noinspection RubyResolve
    event.respond(args.join(' '))
  }
  @commands[:say][:triggers] = %w(say speak repeat)
  @commands[:say][:prefixes] = %w(s! s!! ! &) # Multiple prefixes!
  @commands[:say][:owners_only] = false

  puts @commands
end

# You can make commands outside of the module too!

# noinspection RubyResolve
Commandrb.commands[:bash] = {
    :code => proc { |event, _|
    event.channel.start_typing
    unless Helper.isadmin?(event.user)
        event.respond("❌ You don't have permission for that!")
        break
    end
    bashcode = code.join(' ')
    # Capture all output, including STDERR.
    toberun = "#{bashcode} 2>&1"
    result = ` #{toberun} `
    event << if result.nil? || result == '' || result == ' ' || result == "\n"
               '✅ Done! (No output)'
             else
                 "Output: ```\n#{result}```"
             end
  },
    :triggers => %w(bash cmd terminal),
    :prefixes => %w(s! s!! ! &), # Multiple prefixes!
    :owners_only => true
}

# The global settings used to create a bot object.
init_hash = {
  :token => '',
  :client_id => 0,
  :parse_self => true,
  :parse_bots => false,
  :prefixes => %w(s! ! &),
  :type => :bot,
  :ready => proc { |event|
    puts 'Bot launched'
  },
  :game => 'Powered by Ruby!',
  :owners => [1234, 5678, 9012],
}
Commandrb.initialise(init_hash)


# noinspection RubyResolve
Commandrb.server_config = {
    12345678901 => {# Server ID.
                    :prefixes => %w(s! & ! //), # Array of strings.
                    :autorole_role => 123456789012, # Role ID.
                    :logs_channel => 123456789012, # Channel ID.
                    :mod_role => 123456789012 # Role ID.
  }

}


content = 'Hello, {user}!'
content.gsub('{user}', event.user.name)

module SerieBot
  # noinspection ALL
  module Tags

    # 's!tag create say {args}'
    # args = ["create", "say", "{args}"]
    # args = args.join(' ') # => "createglobal say {args}"

    # Assume create for now, only handling creation.

    # If tag exists.
    if !Config.server_config[event.server.id][:tags][args[1]].nil?
      event.respond("Tag #{args[1]} already exists!")
      return
    else
      response = args.drop(2).join(' ')
      Config.server_config[event.server.id][:tags][args[1]] = {
        :owner => event.user.id,
        :response => response
      }

    end

    #~~~~~~~~~~~~~~~~~~

    # 's!tag say hello'

    # args = ["say", "hello"]

    if Config.server_config[event.server.id][:tags][args[0]].nil?
      event.respond("No tag `#{args[0]}` exists!")
      return
    else
      args = args.drop(1)
      response = Config.server_config[event.server.id][:tags][args[0]][:response]
      response.gsub!('{args}', args.join(' '))
    end
  end
end


# Run a command from anywhere (Watch out for some things, like args and events!)

Commandrb.commands[:eval][:code].call(event, ' puts \'haxed!\''.split(' '))
```
