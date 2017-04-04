# Init Hash

The "init hash" is a hash object which is passed to `Commandrb.initialise()`, and includes many settings for the bot, most of which can be changed later, by manipulating the Commandrb variables. For example `Commandrb.prefix` and `Commandrb.owners[]` <br />
These settings are passed into Discordrb to create a bot object, which can be later referenced using `Commandrb.bot`

## Example
```ruby
# The global settings used to create a bot object.
init_hash = {
  token: '',
  prefixes: ['!', '!', '&'],
  prefix_type: 'always',
  type: :bot,
  ready: proc {
    puts 'Bot connected'
  },
  game: 'Powered by Ruby!',
  owners: [1234, 5678, 9012],
  typing_default: true,
}
```


## Details
`:token` - The token used to authenticate with Discord.

`:client_id` - The app/client ID of the bot account. Not required if using a user account (See `:type`)

`:parse_self` - Whether or not the bot should parse itself in events. Includes both Commandrb commands and regular Discordrb events (`bot.message`, etc.). This option cannot be overidden later.

`:parse_bots` - Whether or not the bot should parse other bots, including itself. Only applies to Commandrb commands, regular Discordrb events are unaffected. This option can be bypassed for individual commands, using the `:parse_bots` option.

`:selfbot` - If this option is enabled, the bot will only accept commands from itself, and nobody else. Only really works in conjunction with a `:type` of `:user` (Read the notes about it below).<br>
Forces `:parse_self` to be true when used.

`:prefixes` - A list of prefixes to use. See `:prefix_type` for details on how this interacts with command-specific prefixes.

`:prefix_type` - How the default prefixes interact with command specific prefixes.<br>
Accepted values:
- `'always'` - Default prefixes will always be used **as well as** any server or command specific prefixes.
- `'rescue'` - Where no command or server specific prefixes are given, the array in the init hash will be used *instead*. This is the default option.
- `'server_default'` - Any new servers the bot joins will have their prefixes set to the ones in the init hash, and the array will no longer be used and prefixes can be modified per-server afterwards.
- `'intials'` - Always use the prefixes supplied in the init hash and ignore any command specific ones. <br>
- `'commands'` - Ignore the prefixes in the init hash (Or don't supply any) and use command or server specific ones. If a command has no prefixes it cannot be ran. <br>
- `'type'` - The type of account the bot is running on. Can be either `:user` (Where the token is retrieved from a client), or `:bot`, where a token has been given to a bot account).<br>Please note that using User Accounts for a Commandrb bot is not supported, with the exception of an unmodified copy of [Selfbotrb](https://github.com/Seriell/selfbotrb). Any problems encountered while using the `:user` option **will not be fixed** (unless they also occur on unmodified Selfbotrb). Also note that the terminal randomly spouting NoPermission errors is normal and the bot will work normally anyway. That said, you shouldn't encounter any issues because of how Commandrb is designed, but please keep the above in mind when making a selfbot.

`:ready` - This option is a Proc event which will be ran when the bot connects to Discord. Please keep in mind that if the bot disconnects for some reason, the ready event will be ran again.

`:game` - The text supplied here will be set as the bot's "game" when it is connected. This means that if the bot disconnects the game will be reset to this setting. The game can also be changed at any time (`Commandrb.bot.game = 'Game goes here'`), and will return to this setting when the bot is relaunched.

`:owners` - An array of User IDs. The users in this list will be able to run commands that have the `:owners_only` option enabled, or use `:owner_override` commands without the regular permissions. Please give out this permission with care.<br>
The owners can be changed temporarily at any time by editing `Commandrb.owners[]`, however these changes will be lost when the bot is relaunched.

`:typing_default` - If true, the bot will begin "Typing" before every command, this will be automatically stopped by Discord when a message is sent by the bot, or 5 seconds has passed. This setting is the global default for if none is supplied in the command. Command-specific settings will override this one.
