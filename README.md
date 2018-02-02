# Yuuki-Bot
Publicly available bot for [Discord](https://discordapp.com).

You can invite the Public Bot with this link -> https://dis.gg/yuuki <br />
The Public Bot might not always be online, if you want the bot all the time for sure, or access to Owner Commands, please host it yourself.

## Important Information
This bot is provided for use in your Discord Server at your discetion. All code that is currently running on the Bot Account is viewable at this repositery.  
The creator(s) of this code accepts no responsibility for anything that may happen as a result of adding this bot, feel free to verify the source code to ensure that nothing bad is running.  
In the rare event that the code running is not the same as the master branch on GitHub, a commit code will be shown in the `about` command which can be checked with GitHub to see what code is running.

# Self-Hosting:

## Requirements
- Ruby 2.3.1+ (Due to a bug in the Ruby interpreter, this bot won't work correctly with lower versions.)
- bundler (`gem install bundler`)

## Install
1. Clone the repo: `git clone https://github.com/Seriell/Yuuki-Bot.git`
2. cd into the repo: `cd Yuuki-Bot`
3. Create a bot account and edit the config files accordingly (See config/README.md)
4. Install bundler if you haven't already: `gem install bundler`
5. Install the bundle: `bundle install`
6. Run the bot. For Linux: `sh run_linux.sh`. For Windows: `run_windows.bat`.

## Updating
1. Pull any changes from the repo: `git pull`
2. Check any config changes. Open `config/config.yml.example` and see if any new information is needed in your `config/config.yml.example`
3. Update the bundle: `bundle update`
4. Run the bot: `sh run_linux.sh` or `run_windows.bat`

Please report any issues to `@Seriel#3760` | `<@228574821590499329>` on Discord, or open an Issue on Github! <br />
You can also join our server for support! https://discord.gg/kZ9dHxJ <br />

Enjoy~
<br />

# Credits

Kudos to the following users for helping me ([Seriel](https://github.com/Seriell)) out:

- [Spotlight](https://github.com/spotlightishere)
- [luigoalma](https://github.com/luigoalma), for ideas and help early in development. :3
- [megumi](https://github.com/megumisonoda)
- Anyone active on the Discordrb channel in the Discord API server.
- [meew0](https://github.com/meew0/) for [Discordrb](https://github.com/meew0/discordrb)
- [edwardslabs](https://github.com/edwardslabs) for [CloudBot](https://github.com/edwardslabs/CloudBot/)
