This folder contains multiple files used for basic custom commands.
For each file there will be a `.sample.` version available. Remove the `.sample.` from the name to use the file, then adjust it according to your needs. Most of these files achieve the same purposes, but some are more complex than others.

Custom text commands can only show static strings for now, with the exception of the ones in the .rb files, which can show some dynamic content, but custom.rb won't be able to access the `event`, however you can still access the Commandrb bot object using `$cbot`.

## Files:

### custom.yml`
The simplest way of creating a custom command. Follow the sample file to see how it is formatted. There are two entries, `:text:` and `:image:`. 

For text commands the entered text will be displayed as a response when any prefix is used with the word enclosed in two `:`.

For image commands, the file specificed will be uploaded to Discord when the word is triggered with any bot prefix behind it. The files are relative to the bots folder.

### custom.rb
This file is a special Ruby file in which you can set various variables to dynamically create commands (For example parsing a list of similar commands and then creating them all at once.). Naturally, this file is much more complex than the yml alternative. Modifying any variable other than the special custom ones inside this file is not recommened and probably won't work, so don't! (See below..)

### code.rb
This file is quite simply Ruby code which will be required by the bot at runtime. This is an excellent way of expanding upon the bot without making an major changes.

Inside this file you can tinker with various aspects of the bot, and even create complex custom commands using the full commandrb specification. 

Help for this file cannot be given at this time, for now look around at the bot code to get an idea of how commands are structured.

