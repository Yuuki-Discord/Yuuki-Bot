# Configuring the Bot

Before you can use your instance of the bot, you must first edit the configuration files according to your instance.<br>
For some of these instructions, hints on how to perform this action on a *nix machine (Linux/Mac) will be shown like so: (`codeblocks`).

Here's how to setup your instance:

# Creating a Bot Account
1. Go to https://discordapp.com/developers/applications/me
2. Follow the instructions to create a new bot account. You don't need to change many options, just set a name and optionally an avatar.
3. Create a Bot User using the instructions on-screen.
4. Make a note of the "Client ID" and "Token"

## Basic Config
1. Enter the config folder. (`cd config`)
2. Create a copy of `config.sample.yml` called `config.yml`. You could rename it, but it will cause issues later if you do. (`cp config.sample.yml config.yml`)
3. Open the file in a text editor. In this example we'll use nano. (`nano config.yml`) Note: DO NOT use Windows Notepad.
4. After `token: `, replace the example one with your own token you noted earlier (Or copy/paste it from the app page directly)
5. After `client_id: `, replace the example number with your own from the app page.
6. Under `prefixes: `, feel free to edit/remove lines to suit your own bot's prefixes. This is the character(s) that will go before commands. For example with a prefix of `s!`, a command would be `s!ping`.
7. If needed, change the `status: ` and `game: ` to your own values. The status is whether the bot is online/idle/dnd/whatever, while the game will be shown as "Playing" by the bot. Set the game to nil to show no Playing text.
8. If desired, change any of the other config options to your own liking. Many have descriptions above them.

## Owner Setup
**⚠ WARNING: Any user on this list will have full access to the machine the bot is hosted on via eval and bash commands.
If you do not trust someone with the machine the bot is hosted on, do not add them as an owner. ⚠**

1. Obtain the User ID(s) of people who will be owning your bot instance. Instructions on how to do this are inside owners.sample.yml.
2. Create a copy of `owners.sample.yml` called `owners.yml`. You could rename it, but it will cause issues later if you do. (`cp owners.sample.yml owners.yml`)
3. Underneath `owners: `, create a new line for each user, as instructed in the file's comments.

## Inviting the bot to your server
At this point you will have setup the bot to connect to discord and perform how it should, but it hasn't joined any servers yet!<br>
To make it join a server for you, you will need to have `Manage Server` permissions in the server, be the owner of the server, or get a server admin to do it for you.

For your convience, if a bot is loaded but is connected to no servers, an invite url will be shown in the console output. To add your bot to a server you have permissions on, simply click the link and follow the instructions there. If another is doing it for you, send them the url and ask them to add the bot.<br>
If you wish to see the URL again, simply use the `invite` command in an existing server. This will show the invite url which you can use to add the bot to more servers. (The more the merrier!)

For any other case, you will need to manually create an invite url. An example URL is shown below. Replace `CLIENTID` in this example with your bots Client ID (Not User ID), and the url should work.
```
https://discordapp.com/oauth2/authorize?client_id=CLIENTID&scope=bot
```
