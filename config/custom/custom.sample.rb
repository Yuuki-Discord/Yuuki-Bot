# Three different ways to add custom commands easy.


#### NOTE ####
# The below examples that use {user} and {userid} do not currently function.
# This feature is planned for later.

custom = {}

# 1. Make your own hashes!
custom[:pong] = {
  :type => 'text',
  :response => 'Ping!'
}

custom[:hi] = {
  :type => 'text',
  :response => 'Hello, {user}!'
}

custom[:mentionme] = {
  :type => 'text',
  :response => 'Hello, <@{userid}>!'
}

# 2. All in one hash!
custom_text = {
  :pong => 'Ping!',
  :hi => 'Hello, {user}!',
  :mentionme => 'Hello, <@{userid}>!'
}

# 3. Change one variable(!)
custom_text[:pong] = 'Ping'
custom_text[:hi] = 'Hello, {user}!'
custom_text[:mentionme] = 'Hello, <@{userid}>!'

# Don't forget images!
custom_image = {}

custom_image[:soon] = 'images/soon.png'


custom_text = {
    lenny: '( ͡° ͜ʖ ͡°)',
    shrug: '¯\_(ツ)_/¯',
    support: "⚙ **Need help?**\nYou can join the support server here:\n**https://discord.gg/43SaDy6 **",
    facedesk: 'https://giphy.com/gifs/XLOsdacfjL5cI',
    smea: 'https://giphy.com/gifs/Sb2NkTl1oV6eI',
}
