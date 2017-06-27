@echo off
cls
if exist config/config.sample.yml rename config/config.sample.yml config.yml
rem ###
set /a shutdown_menu_info=0
set /a shutdown_ignore=0
set /a mysys=0
set /a restart_count=0
set /a unknown_error_warn=0
set /a log_output=0
set /a error_shutdown=0
set /a update_failure=0 
mode 120,30
chcp 65001
rem ###
goto menu

:menu
mode 120,30
cls
echo Yuuki-Bot - @Seriel, @KcrPL
echo ------------------------------------------------------------------------------------------------------------------------
echo [*] Welcome.
echo.
echo Welcome to this handy script, it will help you get started with Yuuki-Bot :)
echo.
echo What do you want to do?
echo.
if %mysys%==1 echo [ WARNING ]
if %mysys%==1 echo Mysys library not detected, look at log file on your desktop.
if %mysys%==1 echo.

if %update_failure%==1 echo [ WARNING ] 
if %update_failure%==1 echo Update failure. Please check log file located on your desktop.
if %update_failure%==1 echo.

if %shutdown_menu_info%==1 echo [ INFO ]
if %shutdown_menu_info%==1 echo Yuuki-Bot has been shutted down. Please check log.
if %shutdown_menu_info%==1 echo.

echo 1. Update/Install Yuuki
echo 2. Launch Yuuki.
echo.
echo 3. Open Log file (here)
echo 4. Open Log file (in Notepad)
echo 5. Delete Log file

if %shutdown_ignore%==1 echo ... C. [X] Shutdown command will be ignored, the bot will restart.
if %shutdown_ignore%==0 echo ... C. [ ] Shutdown command will be ignored, the bot will restart.

if %log_output%==1 echo ... D. [X] Log everything from bot onto screen. (NOT RECOMENDED)
if %log_output%==0 echo ... D. [ ] Log everything from bot onto screen. (NOT RECOMENDED)

if %error_shutdown%==1 echo ... E. [X] Shutdown Yuuki after an error.
if %error_shutdown%==0 echo ... E. [ ] Shutdown Yuuki after an error. 

set /p s=Choose: 
if %s%==1 goto update_yuuki
if %s%==2 goto startup_yuuki
if %s%==3 goto show_log
if %s%==4 goto open_log
if %s%==5 goto del_log
if %s%==c goto shutdown_ignore_set
if %s%==C goto shutdown_ignore_set
if %s%==d goto log_output_set
if %s%==D goto log_output_set
if %s%==e goto error_shutdown_yuuki
if %s%==E goto error_shutdown_yuuki
goto menu
:error_shutdown_yuuki
if %error_shutdown%==0 goto error_shutdown_yuuki_1
if %error_shutdown%==1 goto error_shutdown_yuuki_0
goto menu
:error_shutdown_yuuki_1
set /a error_shutdown=1
goto menu
:error_shutdown_yuuki_0
set /a error_shutdown=0
goto menu
:log_output_set
if %log_output%==0 goto log_output_1
if %log_output%==1 goto log_output_0
goto menu
:log_output_1
set /a log_output=1
goto menu
:log_output_0
set /a log_output=0
goto menu
:shutdown_ignore_set
if %shutdown_ignore%==0 goto shutdown_ignore_1
if %shutdown_ignore%==1 goto shutdown_ignore_0
goto menu
:shutdown_ignore_1
set /a shutdown_ignore=1
goto menu
:shutdown_ignore_0
set /a shutdown_ignore=0
goto menu
:show_log
if not exist C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt goto show_log_error
mode 80,9001
cls
type C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
echo.
echo :--------------------------------------:
echo END OF LOG FILE
echo Press anything to go back to main menu.
pause>NUL
goto menu
:open_log
if not exist C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt goto show_log_error
start C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
goto menu
:del_log
if not exist C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt goto show_log_error

cls
echo Yuuki-Bot - @Seriel, @KcrPL
echo ------------------------------------------------------------------------------------------------------------------------
echo.
echo Do you really want to delete an Log file?
echo.
echo 1. Yes
echo 2. No
set /p s=Choose: 
if %s%==1 del /q C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt >NUL
if %s%==1 goto menu
if %s%==2 goto menu
goto del_log
:show_log_error
cls
echo Yuuki-Bot - @Seriel, @KcrPL
echo ------------------------------------------------------------------------------------------------------------------------
echo [*] Error.
echo.
echo Error has occurred.
echo Error code: 404 :P
echo.
echo Log file cannot be found.
echo Press anything to go back to main menu.
pause>NUL
goto menu
:git_clone_err
cls
echo Yuuki-Bot - @Seriel, @KcrPL
echo ------------------------------------------------------------------------------------------------------------------------
echo [*] Error.
echo.
echo Error has occurred.
echo Error code: 128
echo.
echo fatal: Not a git repository (or any of the parent directories): .git
echo.
echo UPDATE SCRIPT FAILED...
echo Please download this using git clone command.
echo Press anything to go back to main menu.
pause>NUL
goto menu
:git_not_installed
cls
echo Yuuki-Bot - @Seriel, @KcrPL
echo ------------------------------------------------------------------------------------------------------------------------
echo [*] Error.
echo.
echo Error has occurred.
echo Error code: 11
echo.
echo You need to install git to be able to use gems from git repositories. For help
echo installing git, please refer to GitHub's tutorial at
echo https://help.github.com/articles/set-up-git
echo.
echo Press anything to open that site in your default browser and to go back to main menu.
pause>NUL
start https://help.github.com/articles/set-up-git
goto menu


:update_yuuki
set /a mysys=0
set /a update_failure=0
cls
echo Yuuki-Bot - @Seriel, @KcrPL
echo ------------------------------------------------------------------------------------------------------------------------
echo.
echo Please wait while updating... 
echo Everything is being logged into log file on your desktop. 	
echo.
echo Yuuki-Bot. (C)Seriel, (C)KcrPL >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
echo Start of an LOG FILE >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
echo Date %date%, Time %time% >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
echo. >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
echo [INFO] '..:: Updating/Installing Yuuki started ::..' >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
call gem install bundler >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
	set /a temperrorlev=%errorlevel%
	if not %temperrorlev%==0 echo [ERROR] gem install bundler command returned exit code: %temperrorlev%
echo. >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
echo [INFO] '..:: Installing/Updating Bundle ::..' >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
call bundle install >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
set /a temperrorlev=%errorlevel%

	if %temperrorlev%==1 set /a mysys=1
	if %temperrorlev%==1 echo [WARNING] mysys library not detected, NEED TO INSTALL. >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
	if %temperrorlev%==11 goto git_not_installed
	if %temperrorlev%==10 set /a update_failure=1
	if %temperrorlev%==10 echo [WARNING] bundle install command failed. (ERR CODE 10) gem installation failed. >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
	
	echo. >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
echo [INFO] '..:: Updating Yuuki-Bot ::..' >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
call git pull >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
set /a temperrorlev=%errorlevel%
	if not %temperrorlev%==0 echo [ERROR] git clone returned exit code: %temperrorlev% 
	if %temperrorlev%==128 goto git_clone_err
goto update_yuuki_end
:update_yuuki_end
set /a exiting=6
set /a timeouterror=1
timeout 1 /nobreak >NUL && set /a timeouterror=0
goto update_yuuki_end1
:update_yuuki_end1
cls
echo Yuuki-Bot - @Seriel, @KcrPL
echo ------------------------------------------------------------------------------------------------------------------------
echo.
echo Updating finished.
echo.
echo The log file is saved on your desktop.
echo (C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt)
echo.
echo Going back in.. %exiting%
if %exiting%==6 echo :------: 6
if %exiting%==5 echo :----- : 5
if %exiting%==4 echo :----  : 4
if %exiting%==3 echo :---   : 3
if %exiting%==2 echo :--    : 2
if %exiting%==1 echo :-     : 1
if %exiting%==0 echo :      :
if %exiting%==0 goto menu
if %timeouterror%==0 timeout 1 /nobreak >NUL
if %timeouterror%==1 ping localhost -n 2 >NUL
set /a exiting=%exiting%-1
goto update_yuuki_end1
:startup_yuuki
cls
echo Yuuki-Bot - @Seriel, @KcrPL
echo ------------------------------------------------------------------------------------------------------------------------
echo. >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
echo.
echo Check out log file saved on your desktop!
echo (C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt)
echo.
echo [INFO] Starting up Yuuki-Bot...>>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
echo [INFO] Starting up Yuuki-Bot...
echo Time: %time%, Date: %date%>>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
echo Time: %time%, Date: %date%
echo Restarts: %restart_count%
echo.
if %unknown_error_warn%==1 echo [ WARNING ]
if %unknown_error_warn%==1 echo PLEASE CHECK LOG FILE!
echo.
	
rem ### BOT ###
if %log_output%==1 echo [INFO] User decided NOT to log output from Yuuki.>>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
if %log_output%==1 echo.>>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
echo. >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
if %log_output%==0 echo [INFO] Logging from Yuuki-Bot >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt

if %log_output%==0 call bundle exec ruby run.rb >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
if %log_output%==1 call bundle exec ruby run.rb


set /a temperrorlev=%errorlevel%
		if %temperrorlev%==1002 echo [INFO] Yuuki-Bot wants to restart. Restarting... >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
		if %temperrorlev%==1001 echo [INFO] Yuuki-Bot wants to shutdown. Returning to menu... >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
		
	if %temperrorlev%==1001 goto shutdown_yuuki
	if %temperrorlev%==1002 goto restart_yuuki

	
	echo. >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
	if %temperrorlev%==10 echo [ERROR] Yuuki-Bot startup failed. (ERROR CODE 10) Could not locate Gemfile or .bundle/directory >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
	if %temperrorlev%==10 echo [WARNING] Unrecoverable error, Yuuki will now exit.>>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
	if %temperrorlev%==10 goto unrecoverable_err
	if not %temperrorlev%==0 goto unknown_error_yuuki
set /a restart_count=%restart_count%+1

rem ### BOT ###
	goto startup_yuuki
	
:unrecoverable_err
cls
set /a shutdown_menu_info=1
goto menu
:unknown_error_yuuki
cls
echo.>>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
echo [ERROR] Yuuki-Bot sent unknown error code! ERROR Code: %temperrorlev% >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
echo.>>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt

if %error_shutdown%==1 echo [INFO] User decided to shutdown Bot after error. >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
if %error_shutdown%==1 set /a shutdown_menu_info=1
if %error_shutdown%==1 goto menu


echo Ignoring, restarting yuuki. >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt

set /a unknown_error_warn=1
set /a restart_count=%restart_count%+1
goto restart_yuuki
:shutdown_yuuki
cls
if %shutdown_ignore%==1 echo [INFO] User decided to ignore shutdown command. Restarting... >>C:\Users\%username%\Desktop\Yuuki-Bot_Log.txt
if %shutdown_ignore%==1 set /a restart_count=%restart_count%+1
if %shutdown_ignore%==1 goto startup_yuuki
if %shutdown_ignore%==0 set /a shutdown_menu_info=1
if %shutdown_ignore%==0 goto menu
goto menu
:restart_yuuki
set /a exiting=10
set /a timeouterror=1
timeout 1 /nobreak >NUL && set /a timeouterror=0
goto restart_yuuki1

:restart_yuuki1
cls
echo Yuuki-Bot - @Seriel, @KcrPL
echo ------------------------------------------------------------------------------------------------------------------------
echo.
echo Restarting Yuuki
echo.
echo Restarting in.. %exiting%
if %exiting%==10 echo :----------: 10
if %exiting%==9 echo :--------- : 9
if %exiting%==8 echo :--------  : 8
if %exiting%==7 echo :-------   : 7
if %exiting%==6 echo :------    : 6
if %exiting%==5 echo :-----     : 5
if %exiting%==4 echo :----      : 4
if %exiting%==3 echo :---       : 3
if %exiting%==2 echo :--        : 2
if %exiting%==1 echo :-         : 1
if %exiting%==0 echo :          :
if %exiting%==0 goto startup_yuuki
if %timeouterror%==0 timeout 1 /nobreak >NUL
if %timeouterror%==1 ping localhost -n 2 >NUL
set /a exiting=%exiting%-1
goto restart_yuuki1


















