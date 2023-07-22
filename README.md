# Yuuki-Bot
Free and open-source bot for [Discord](https://discordapp.com).

> **Warning**\
> **Yuuki is not actively maintained. Only security and critical bug fixes will be made.**

# Usage
You can invite the [publicly usable version of the bot](https://erisa.link/yuukibot) or [host your own version](#self-hosting) to gain full control and access to owner commands.  
You can find a [list of commands on the wiki](https://github.com/Yuuki-Discord/Yuuki-Bot/wiki).

# Self-Hosting

## Requirements

For Docker (Recommended):
- A Docker installation, including `docker` and `docker-compose` binaries.
  - On Debian-based Linux distros this is usually as simple as `apt install docker.io docker-compose` - for advanced installations check out [the documentation](https://docs.docker.com/engine/install)

For standalone:
- Ruby 2.4.0+
- Bundler (`gem install bundler`)
- Locally running Redis (`apt install redis-server` ?)

Note: We do not currently support running standalone on bare Windows platforms. It should work, but no guarantees or support are made.  
For Windows it's recommended to use [WSL](https://docs.microsoft.com/en-us/windows/wsl/about) (WSL1 and WSl2 are both fine) or [Docker Desktop](https://docs.docker.com/docker-for-windows/install/).  


---
## Install and run
1. Clone the repo: `git clone --recursive https://github.com/yuuki-discord/Yuuki-Bot.git`
2. cd into the repo: `cd Yuuki-Bot`

Then either
### Docker (Recommended)
3. Generate a configuration file. You have a few choices:
    - Run the guided script: `docker-compose run yuuki ./config.rb`
    - Create a `config/config.yml` manually: see `config/README.md` for details.
    - Uncomment and edit the environment variables in `docker-compose.yml`
4. Run the bot: `docker-compose up`  
To fork it to the background, instead use `docker-compose up -d`. You can check the running logs with `docker-compose logs yuuki`.

or 
### Standalone
3. Create a config file, either through the guided script (`ruby config.rb`) or manually (See `config/README.md`)
4. Install bundler if you haven't already: `gem install bundler`
5. Install the bundle: `bundle install`
6. Run the bot. For Linux: `sh run_linux.sh`. For Windows: `run_windows.bat`.
---

## Updating
1. Pull any changes from the repo: `git pull`
2. Check any config changes. In the future more work will be needed on our side to better support this.  
    - If anything errors, make sure to check the new `config.example.yml` and update your `config.yml` accordingly.

### Docker
3. Update the containers: `docker-compose pull`
4. Start or restart the containers: `docker-compose up -d`

### Standalone
3. Install/update the gem dependancies: `bundle install`
4. Run the bot: `sh run_linux.sh` or `run_windows.bat`
---

Please report any issues to Erisa | `<@228574821590499329>` on Discord, or open an [Issue](https://github.com/yuuki-discord/Yuuki-Bot/issues)! <br />
You can also join our server for support! (Or to find me) https://discord.gg/PrTMrv4 <br />

Enjoy~  

# Important Information
Use of this bot is at your own discretion. The bot's current code is viewable at this repository, feel free to review the code to verify its safety.
The creator(s) of this code accept no responsibility for any repercussions that occur as a result of adding this bot.

The `@Yuuki-Chan help` command on the publicly running bot should always show the commit hash of the running code (If a version is shown, omit the first `g` after that version to get the commit hash) For example at time of writing the bot returns `990bcb5`, which corresponds to [this code state](https://github.com/Yuuki-Discord/Yuuki-Bot/tree/990bcb55b4a06049db59bb08f16ad582315979bc).

# Credits

### Developers
- [Erisa](https://github.com/Erisa)
- [Spotlight](https://github.com/spotlightishere)

### Contributors
- [luigoalma](https://github.com/luigoalma)
- [Larsenv](https://github.com/Larsenv)
- [ry00001](https://github.com/ry00001)

### Upstream developers
- [edwardslabs](https://github.com/edwardslabs) for [CloudBot](https://github.com/edwardslabs/CloudBot/)
- [meew0](https://github.com/meew0/) for [Discordrb](https://github.com/meew0/discordrb)
