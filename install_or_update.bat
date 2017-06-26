@echo off
echo :: Installing/Updating Bundler
gem install bundler
echo :: Installing/Udating Bundle..
bundle install
echo :: Updating Yuuki-Bot..
git pull
echo Done! Please load run.bat if successful!
pause