@echo off
:repeat
call bundle exec ruby run.rb || goto :repeat
echo Success!
pause