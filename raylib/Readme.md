```
-------------------------------------------------------------------------------------------------------------------
   _  __ ________       _  __ ______     _ ________         _  __ ________________
  _  __ ____  __/___  ___________  /__________  __ \_____ _____  ____  /__(_)__  /_
      _  __  /  _  / / /_  ___/_  __ \  __ \_  /_/ /  __ `/_  / / /_  /__  /__  __ \
      _  _  /   / /_/ /_  /   _  /_/ / /_/ /  _, _// /_/ /_  /_/ /_  / _  / _  /_/ /
         /_/    \__,_/ /_/    /_.___/\____//_/ |_| \__,_/ _\__, / /_/  /_/  /_.___/
                                                          /____/

 TurboRaylib - Delphi and FreePascal headers for Raylib 4.5.
 Raylib - A simple and easy-to-use library to enjoy videogames programming (www.raylib.com)

 Download compilled Raylib 4.5 library: https://github.com/raysan5/raylib/releases/tag/4.5.0

 Translator: @Turborium

 Headers licensed under an unmodified MIT license, that allows static linking with closed source software

 Copyright (c) 2022-2023 Turborium (https://github.com/turborium/TurboRaylib)
-------------------------------------------------------------------------------------------------------------------
```
  
TurboRaylib - https://github.com/turborium/TurboRaylib  
  
This folder contains the Raylib header files for the Object Pascal language.
The core files are supplied under the MIT license.

Files:
- raylib.inc - Config file
- raylib.pas - Raylib core functions
- raymath.pas - Raylib math functions
- rlgl.pas - OpenGL abstraction
- /extras - Additional files, supplied under the original license
- LICENSE - MIT license

How to use?
Just add the necessary files to your project, put the necessary dll next to the exe and get a fun!

Note:
  Some Raylib functions require the use of pointers, don't forget to enable {$POINTERMATH ON} option in your source code! 
  Text strings for Raylib must be in UTF8String format, just wrap your string in UTF8String(). Ex: UTF8String('My String').

-------------------------------------------------------------------------------------------------------------------
   
<br>
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br>
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br>
<br>
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br>
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br>
<br>
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br>
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br>
<br>
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br>
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br>
<br>
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br>
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br>
<br>
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br>
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br>
<br>
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br>
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br>
<br>
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br>
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br> 
<br>

```
-------------------------------------------------------------------------------------------------------------------

▄████▄▓██   ██▓ ▄▄▄▄   ▓█████  ██▀███   ██▓███    ██████▓██   ██▓ ▄████▄   ██░ ██  ▒█████    ██████  ██▓  ██████
▒██▀ ▀█ ▒██  ██▒▓█████▄ ▓█   ▀ ▓██ ▒ ██▒▓██░  ██▒▒██    ▒ ▒██  ██▒▒██▀ ▀█  ▓██░ ██▒▒██▒  ██▒▒██    ▒ ▓██▒▒██    ▒
▒▓█    ▄ ▒██ ██░▒██▒ ▄██▒███   ▓██ ░▄█ ▒▓██░ ██▓▒░ ▓██▄    ▒██ ██░▒▓█    ▄ ▒██▀▀██░▒██░  ██▒░ ▓██▄   ▒██▒░ ▓██▄
▒▓▓▄ ▄██▒░ ▐██▓░▒██░█▀  ▒▓█  ▄ ▒██▀▀█▄  ▒██▄█▓▒ ▒  ▒   ██▒ ░ ▐██▓░▒▓▓▄ ▄██▒░▓█ ░██ ▒██   ██░  ▒   ██▒░██░  ▒   ██▒
▒ ▓███▀ ░░ ██▒▓░░▓█  ▀█▓░▒████▒░██▓ ▒██▒▒██▒ ░  ░▒██████▒▒ ░ ██▒▓░▒ ▓███▀ ░░▓█▒░██▓░ ████▓▒░▒██████▒▒░██░▒██████▒▒
░ ░▒ ▒  ░ ██▒▒▒ ░▒▓███▀▒░░ ▒░ ░░ ▒▓ ░▒▓░▒▓▒░ ░  ░▒ ▒▓▒ ▒ ░  ██▒▒▒ ░ ░▒ ▒  ░ ▒ ░░▒░▒░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░░▓  ▒ ▒▓▒ ▒ ░
░  ▒  ▓██ ░▒░ ▒░▒   ░  ░ ░  ░  ░▒ ░ ▒░░▒ ░     ░ ░▒  ░ ░▓██ ░▒░   ░  ▒    ▒ ░▒░ ░  ░ ▒ ▒░ ░ ░▒  ░ ░ ▒ ░░ ░▒  ░ ░
░       ▒ ▒ ░░   ░    ░    ░     ░░   ░ ░░       ░  ░  ░  ▒ ▒ ░░  ░         ░  ░░ ░░ ░ ░ ▒  ░  ░  ░   ▒ ░░  ░  ░
░ ░     ░ ░      ░         ░  ░   ░                    ░  ░ ░     ░ ░       ░  ░  ░    ░ ░        ░   ░        ░
░       ░ ░           ░                                   ░ ░     ░

REMEMBER - using a ready-made "engine" for graphics (like a Raylib) in your game can save you from cyberpsychosis!
Write games, don't write game engines. BASED. 🍉

-------------------------------------------------------------------------------------------------------------------
```
