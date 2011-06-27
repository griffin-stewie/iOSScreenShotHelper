# iOS Screen Shot Helper #

iOS Screen Shot Helper is SIMBL plugin that gives you taking screen shot and save as png file with some option like cropping Statusbar, Tabbar, etc.

## Installation ##

* Install [SIMBL](http://culater.net/software/SIMBL/SIMBL.php)
* Quit iOS Simulator.
* move “iOSScreenShotHelper.bundle” into your SIMBL plugin folder.
  * Result path is “/Library/Application Support/SIMBL/Plugins/iOSScreenShotHelper.bundle” or “/Users/YOU/Library/Application Support/SIMBL/Plugins/iOSScreenShotHelper.bundle”.

## Usage ##

* Press ⌘ + ⌃ + C as same as default shortcut for "Copy Screen"
* Screen shots save into "~/Desktop/iOSScreenShots/" as default

### Option ###

"SSHelper" Menu shows options below

* Crop StatusBar
* Crop NavigationBar
* Crop TabBar
* Crop ToolBar

## Preferences ##

Currently there is no preference user interface.    
You can change directory of saving screen shots following command with terminal.app and restart iOS simulator.


> defaults write ~/Library/Application\ Support/iOSScreenShotHelper/iOSScreenShotHelper ScreenShotSaveFilePath "PATH FOR SCREEN SHOTS"