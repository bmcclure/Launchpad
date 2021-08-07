# Launchpad

Manage your game platforms and create beautifully-simple .exe files to launch games from any platform 
within Steam or other applications.

![main-window--tri](https://user-images.githubusercontent.com/277977/113593737-c25f6780-9604-11eb-8b72-ad191c45570a.png)

Every launcher in the list creates a small .exe file you can add right to Steam that handles the entire launch process seamlessly. Or if you don't want to use another platform, you can run all of your launchers directly from Launchpad!

Check out my [introduction series on YouTube](https://www.youtube.com/watch?v=KsbVijnHt68&list=PLdWnfeiq_bKdDLcvORj8qoYnot5teCnMv&index=1).

## Introduction

Gone are the days when your entire game library exists in the form of game discs--digital downloads are 
where it's at. But there are many different options for where and how to download and play PC games. And
frustratingly, many games are specific to certain distribution platforms, meaning gamers are often forced
to run several different game platforms on their PC simultaneously.

This is where Launchpad comes in. It helps you take control of your games and game platforms, letting you
launch your games the way you want, without the usual pitfalls and compatibility issues that come along with
trying to make game platforms work well together.

Launchpad can handle almost any advanced launch scenario you can throw at it!

Launchpad can be used as a game launcher itself (you can run all your launchers directly from the UI!),
but what's cool is that each game launcher exists as a self-contained .exe file with the right name and icon,
and you can add it right to Steam or any other platform that allows external games.

## Why Use Launchpad

Let's take Steam as an example, because that was the original use case for Launchpad's creation.

Adding Non-Steam games to Steam often works well, but it is a bit quirky, and sometimes features are broken
or it might not work at all. Some common issues include:
- Some games that open via URL or the Windows Store can't be added to Steam.
- Some games cause Steam to say you're playing only for a moment and then stop even though you're still in-game. 
  In these cases, playtime cannot be tracked and your friends don't know you're playing a game.
- Some games launch in ways where the Steam overlay doesn't hook into their process
- Some games that use external launchers continue to say you're playing the game after you exit--sometimes for 
  days if you don't notice.
- Changing a game's icon in Steam adds a shortcut arrow that obscures the icon and makes it obvious it doesn't 
  belong

Launchpad was created to solve all of these issues and more. It gives you a simple way to create a lightweight .exe 
file for any game that looks and acts the way you want. You can add these files to Steam, or any other launcher. Or 
you can simply launch them directly to help you control how your games run.

## Features

Launchpad is getting new features all the time. Some of its main functionality includes:
- A simple, themeable GUI for managing your games and launchers, as well as optionally displaying progress while 
launching your games. The default theme fits in great with Steam!
- Generate .exe files to launch any type of game from any PC game platform
- Manage and detect installed games from Steam, Epic, Origin, Blizzard, and Bethesda.net effortlessly
- Add custom games from any other platform without editing a single config file
- Sync games with Launchpad's online launcher API to pre-configure advanced details automatically
- Fully automate a game's launcher (such as starting it or closing it before or after running the game, with 
customizable behaviors and delays)
- Run games from shortcut, .exe file, URI, or a custom command. Run games directly, or as a scheduled task. Take over 
process ownership from another launcher
- Run and/or close a custom list of programs (such as performance hogging apps or music apps) before and/or after running 
a game
- And more!

## Screenshots

More information such as usage details is below, but since pictures speak a thousand words, here's some screenshots
of various parts of Launchpad:

Note: The following screenshots are out of date, but here for historical purposes. New screenshots will be posted soon.

Initial Setup Window:

![setup_window](https://user-images.githubusercontent.com/277977/104859465-91b83d80-58f3-11eb-8cc6-d1e0f7700303.png)

Launcher Manager (Main Window):

![main_window](https://user-images.githubusercontent.com/277977/104806114-147db300-57a3-11eb-90cd-d69bf8ffe39b.png)

Launcher Editor:

![launcher_editor](https://user-images.githubusercontent.com/277977/104805901-66253e00-57a1-11eb-9cb3-7ded6ab56f23.png)

Managed Launcher Editor:

![managed_launcher_editor](https://user-images.githubusercontent.com/277977/104805908-79d0a480-57a1-11eb-9dbc-4c0e2ec2401c.png)

Managed Game Editor:

![managed_game_editor](https://user-images.githubusercontent.com/277977/104805909-7e955880-57a1-11eb-8d58-b8a1ab277a2a.png)

Platforms:

![platforms_window](https://user-images.githubusercontent.com/277977/104806125-23646580-57a3-11eb-9cee-f8d9e0bcd0bf.png)

Platform Editor:

![platform_editor](https://user-images.githubusercontent.com/277977/104805919-9d93ea80-57a1-11eb-9243-dfc4a6399f36.png)

Detected Games:

![detected_games](https://user-images.githubusercontent.com/277977/104805917-979e0980-57a1-11eb-8dfa-ff569cfe833a.png)

Detected Game Editor:

![detected_game](https://user-images.githubusercontent.com/277977/104805930-a8e71600-57a1-11eb-8006-7e8dfa464c95.png)

Settings:

![settings](https://user-images.githubusercontent.com/277977/104805935-ae446080-57a1-11eb-9e27-b85cae96a933.png)

Generated Launcher Files:

![generated_launchers](https://user-images.githubusercontent.com/277977/106828218-c0eede80-6657-11eb-963f-5228b67f3957.png)

## How To Use

If you're a new user, head over to the Releases page and simply download and run the latest Launchpad-x.x.x.exe
installer file!

The setup screen that runs on first launch will walk you through some initial options and get you started 
detecting your games and creating your first launchers.

Once you've got some launchers created, simply Build All, and you will have a .exe file for each game launcher
that you can add to Steam or any other platform.

## Updating Launchpad

Launchpad automatically notifies you when there are updates available, and clicking Update will automatically download
and start the latest installer.

You can also click Check for Updates in the main Launchpad menu at any time.

## Note on AHK version of Launchpad

Launchpad is built with the AutoHotKey v2-alpha release. Since this is an alpha release, is it under rapid development and breaking changes occur regularly.

It is for this reason that we recommend using the installer release of Launchpad, which always includes the correct version of AutoHotKey v2 that it's compatible with.

Using the installer, you'll never have to worry about which AHK version to use. If you with to use the AHK version of Launchpad, such as for development purposes, you must have a compatible version of AHK v2 available. The simplest way to do this is to first install the Launchpad installer, which will put a compatible version of AutoHotKey in its "Vendor\AutoHotKey" directory. You can then run the AHK version of Launchpad using this AutoHotKey binary.

## Note on Portability

Launchpad's configuration files are portable, but the launchers that Launchpad
generates from them might not be. Some functionality in Launchpad relies on dependencies existing in the right
place, and even if the same game is installed on another computer, that computer may not necessarily be able to use
your generated launcher file.

If you reinstall your OS or move your games, you'll probably want to open Launchpad and rebuild your launchers to
make sure they are fully up-to-date.

## Credits

Launchpad was conceived and developed by Ben McClure of Volantis Development (ben@volantisdev.com) using the 
powerful scripting language AutoHotKey.

Launchpad automatically downloads a few dependencies for use during its operation. The dependencies it installs are:
- [AutoHotKey](https://www.autohotkey.com/)
- [IconsExt](https://www.nirsoft.net/utils/iconsext.html)
- [Protoc](https://github.com/protocolbuffers/protobuf)

These dependencies each use different licensing from Launchpad, and they have their own release cycles, so Launchpad 
doesn't include them in your initial download.

Launchpad downloads and manages these dependencies internally, and you don't ever have to even think about them.

## Contributing

Any and all contributions are greatly appreciated! Here are some ideas for ways that you could help:
- Help write documentation
- Test Launchpad and find out where it could be improved. Report bugs and make feature requests: https://github.com/VolantisDev/Launchpad/issues
- Submit PRs for fixing bugs or adding functionality to Launchpad itself: https://github.com/VolantisDev/Launchpad/pulls



To start contributing, follow the below guidelines: 

**1.**  Fork [this](git@github.com:Contributed-Repositories/jopiter-backend.git) repository.

**2.**  Clone your forked copy of the project.

     $ git clone https://github.com/<your_user_name>/jopiter-backend.git

     
**3.** Checkout into a new branch 

     $ git checkout -b <branch_name>

**4.** Make your changes

**5.** Add and commit your changes

     $ git add . && git commit -m "<your_message>"
     
**6.** Push Code to Github under your branch 

     $ git push origin <branch_name>   

## Attribution

- Icons made by [iconixar](https://www.flaticon.com/authors/iconixar) from [Flaticon](https://www.flaticon.com/).
- Spinner graphics by loading.io
- Launchpad uses parts of the 7zip program for extracting archives. 7-Zip is licensed under the GNU LGPL, and its full source code can 
be downloaded from [7-zip.org](www.7-zip.org).
- Some launch techniques for Battle.net were learned by studying the excellent [BnetLauncher](https://github.com/dafzor/bnetlauncher) by @dafzor. Launchpad no longer
uses BnetLauncher and does not include any of BnetLauncher's code, but would not be where it is today without it.
- The Launchpad Overlay feature was learned with the support of @lemasato and by studying his very useful [Non-Steam-Overlay-Manager](https://github.com/lemasato/Non-Steam-Overlay-Manager) tool.
