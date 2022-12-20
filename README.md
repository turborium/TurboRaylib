![TurboRaylib](logo/TurboRaylib.png)

### **TurboRaylib is a cool and clean Raylib bindings for Object Pascal (Delphi and FreePascal)**

**TurboRaylib sticks to the stable versions of RayLib, the current version is 4.2.**  

Unlike other bindings, this version works stably in Win32 and Win64 in Delphi and Lazarus.  
The raylib library has a lot of ABI problems when using DLLs, all known problems have been fixed in these bindings.  
TurboRaylib has a lot of test coverage (see examples).  

**Foldes:**
- "raylib" - TurboRaylib bindings
- "binaries" - Dynamic libraries suitable for TurboRaylib bindings
- "examples" - Many examples for Delphi

You can download official DLL here: https://github.com/raysan5/raylib/releases/tag/4.2.0  

---

![TurboRaylib](logo/raylib_logo_animation.gif)

raylib is highly inspired by Borland BGI graphics lib and by XNA framework and it's specially well suited for prototyping, tooling, graphical applications, embedded systems and education.

**NOTE for ADVENTURERS:** *raylib is a programming library to enjoy videogames programming; no fancy interface, no visual helpers, no debug button... just coding in the most pure spartan-programmers way.* See: https://www.raylib.com/

---

**Modules**

Header     | Supported          |
---------  | ------------------ |
raylib.h   | :heavy_check_mark: |
raymath.h  | :heavy_check_mark: |
rlgl.h     | :heavy_check_mark: |

**Platforms**

Comiler     | Windows  | OSX          | Linux        |
----------- | -------- | ------------ | ------------ |
Delphi      | ✔        | ❓ no tested | ❓ no tested |
FreePascal  | ✔        | ❓ no tested | ❓ no tested |

---

### How to use?
Just add the "raylib" folder to your project, put the necessary dll next to the exe and get a fun!

**Note:**
- Some Raylib functions require the use of pointers, don't forget to enable {$POINTERMATH ON} option in your source code! 
- Text strings for Raylib must be in UTF8String format, just wrap your string in UTF8String(). Ex: UTF8String('My String').
