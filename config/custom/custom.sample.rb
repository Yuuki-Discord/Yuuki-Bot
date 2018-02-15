# Three different ways to add custom commands easy.


#### NOTE ####
# The below examples that use {user} and {userid} do not currently function.
# This feature is planned for later.

CUSTOM = {}

# 1. Make your own hashes!
CUSTOM[:pong] = {
  :type => 'text',
  :response => 'Ping!'
}

CUSTOM[:hi] = {
  :type => 'text',
  :response => 'Hello, {user}!'
}

CUSTOM[:mentionme] = {
  :type => 'text',
  :response => 'Hello, <@{userid}>!'
}

# 2. All in one hash!
CUSTOM_TEXT = {
  :pong => 'Ping!',
  :hi => 'Hello, {user}!',
  :mentionme => 'Hello, <@{userid}>!'
}

# 3. Change one variable(!)
CUSTOM_TEXT[:pong] = 'Ping'
CUSTOM_TEXT[:hi] = 'Hello, {user}!'
CUSTOM_TEXT[:mentionme] = 'Hello, <@{userid}>!'

# Don't forget images!
CUSTOM_IMAGE = {}

CUSTOM_IMAGE[:dab] = 'custom/dab.jpg'


CUSTOM_TEXT = {
    lenny: '( ͡° ͜ʖ ͡°)',
    shrug: '¯\_(ツ)_/¯',
    support: "⚙ **Need help?**\nYou can join the support server here:\n**https://discord.gg/43SaDy6 **",
    facedesk: 'https://giphy.com/gifs/XLOsdacfjL5cI',
    smea: 'https://giphy.com/gifs/Sb2NkTl1oV6eI',
}
