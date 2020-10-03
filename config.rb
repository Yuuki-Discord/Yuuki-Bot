#!/usr/bin/env ruby

# frozen_string_literal: true

require 'yaml'
require 'io/console'

puts 'If you want to create a config file manually, please stop this program with Ctrl+C ' \
    'and follow the instructions in config/README.md.'
puts 'Press any key to continue!'
STDIN.getch

# Load in a fresh state from the sample file. Hopefully this hasn't been changed
file = File.open('config/config.sample.yml')
configstring = file.read()
puts '-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
puts 'Okay! First of all you\'ll need to create a bot account!'
puts 'To do that, go here -> https://discordapp.com/developers/applications/me <-'
puts 'And login to your Discord account! Then follow the instructions to make a new app'
puts 'After you have your app, select the "Bot" tab and click the blue button ' \
    'labelled "Add Bot"'
puts 'Then click "click to reveal" next to \'Token:\' and copy the long string inside!'
print 'Please paste that string here: '
token = gets.chomp

puts '-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
puts 'Awesome! Now you\'ll need to head back to the "General information" tab' \
    'and fetch the Client ID, which should be a long number.'
print 'And paste that here: '
appid = gets.chomp

puts '-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
puts 'Wew, that\'s the hard part out of the way. ' \
    'Now you get to decide some needed options for your bot!'
puts 'Your bot will need at least one prefix to be used. For example: ' \
    'if you use the prefix s!, your help command will be \'s!help\'.'
puts 'If your prefix is a word, please add a space after it! ' \
    '(For example enter \'tomoe\' for \'tomoe ping\' instead of \'tomoeping\''
print 'Enter your first prefix here: '
prefix = gets.chomp

puts "Nice prefix! Your bots help command will be: '#{prefix}help'"

puts '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
puts 'That\'s enough information to get the bot launching, but there\'s one more thing we need.'
puts 'If you haven\'t already, go to User Settings -> Appearance, and enable Developer Mode.'
puts 'Then, right click your own name and select Copy ID.'
print 'Paste that ID here: '
id = gets.chomp
puts 'Nice! This will make you the owner of the bot and allow you to control things ' \
    'and add more owners through commands.'

puts "\nPlease note that there's more to verything configured above!"
puts 'Check config/config.sample.yml and config.yml to fine-tune the options.'

puts "\n We're now collating the information and generating a configuration file..."
configstring.gsub!('EXAMPLETOKEN', token)
configstring.gsub!('306142257818632193', appid)
configstring.gsub!('s!!', prefix)
configstring.gsub!('1234567890', id)
File.write('config/config.yml', configstring)

puts 'All done! Feel free to launch the bot now!'
