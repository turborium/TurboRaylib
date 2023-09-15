// ------------------------------------------------------------------------------------------------------------------
//  ▄████▄▓██   ██▓ ▄▄▄▄   ▓█████  ██▀███   ██▓███    ██████▓██   ██▓ ▄████▄   ██░ ██  ▒█████    ██████  ██▓  ██████
// ▒██▀ ▀█ ▒██  ██▒▓█████▄ ▓█   ▀ ▓██ ▒ ██▒▓██░  ██▒▒██    ▒ ▒██  ██▒▒██▀ ▀█  ▓██░ ██▒▒██▒  ██▒▒██    ▒ ▓██▒▒██    ▒
// ▒▓█    ▄ ▒██ ██░▒██▒ ▄██▒███   ▓██ ░▄█ ▒▓██░ ██▓▒░ ▓██▄    ▒██ ██░▒▓█    ▄ ▒██▀▀██░▒██░  ██▒░ ▓██▄   ▒██▒░ ▓██▄
// ▒▓▓▄ ▄██▒░ ▐██▓░▒██░█▀  ▒▓█  ▄ ▒██▀▀█▄  ▒██▄█▓▒ ▒  ▒   ██▒ ░ ▐██▓░▒▓▓▄ ▄██▒░▓█ ░██ ▒██   ██░  ▒   ██▒░██░  ▒   ██▒
// ▒ ▓███▀ ░░ ██▒▓░░▓█  ▀█▓░▒████▒░██▓ ▒██▒▒██▒ ░  ░▒██████▒▒ ░ ██▒▓░▒ ▓███▀ ░░▓█▒░██▓░ ████▓▒░▒██████▒▒░██░▒██████▒▒
// ░ ░▒ ▒  ░ ██▒▒▒ ░▒▓███▀▒░░ ▒░ ░░ ▒▓ ░▒▓░▒▓▒░ ░  ░▒ ▒▓▒ ▒ ░  ██▒▒▒ ░ ░▒ ▒  ░ ▒ ░░▒░▒░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░░▓  ▒ ▒▓▒ ▒ ░
//   ░  ▒  ▓██ ░▒░ ▒░▒   ░  ░ ░  ░  ░▒ ░ ▒░░▒ ░     ░ ░▒  ░ ░▓██ ░▒░   ░  ▒    ▒ ░▒░ ░  ░ ▒ ▒░ ░ ░▒  ░ ░ ▒ ░░ ░▒  ░ ░
// ░       ▒ ▒ ░░   ░    ░    ░     ░░   ░ ░░       ░  ░  ░  ▒ ▒ ░░  ░         ░  ░░ ░░ ░ ░ ▒  ░  ░  ░   ▒ ░░  ░  ░
// ░ ░     ░ ░      ░         ░  ░   ░                    ░  ░ ░     ░ ░       ░  ░  ░    ░ ░        ░   ░        ░
// ░       ░ ░           ░                                   ░ ░     ░
// ------------------------------------------------------------------------------------------------------------------
//    _  __ ________       _  __ ______     _ ________         _  __ ________________
//   _  __ ____  __/___  ___________  /__________  __ \_____ _____  ____  /__(_)__  /_
//       _  __  /  _  / / /_  ___/_  __ \  __ \_  /_/ /  __ `/_  / / /_  /__  /__  __ \
//       _  _  /   / /_/ /_  /   _  /_/ / /_/ /  _, _// /_/ /_  /_/ /_  / _  / _  /_/ /
//          /_/    \__,_/ /_/    /_.___/\____//_/ |_| \__,_/ _\__, / /_/  /_/  /_.___/
//                                                           /____/
//
//  TurboRaylib - Delphi and FreePascal headers for Raylib 4.5.
//  Raylib - A simple and easy-to-use library to enjoy videogames programming (www.raylib.com)
//
//  Download compilled Raylib 4.2 library: https://github.com/raysan5/raylib/releases/tag/4.5.0
//
//  Headers licensed under an unmodified MIT license, that allows static linking with closed source software
//
//  Copyright (c) 2022-2023 Turborium (https://github.com/turborium/TurboRaylib)
// -------------------------------------------------------------------------------------------------------------------

// Declare RAY_STATIC for static linking. You will have to deal with adding lib's.
{.$DEFINE RAY_STATIC}

// You can declare names of binary files for dll here, use LibName const.
{$IFDEF WIN32}
  const LibName = 'raylib32.dll'; // for example
{$ENDIF}

{$IFDEF WIN64}
  const LibName = 'raylib64.dll'; // for example
{$ENDIF}

// Define INDEPNDENT_RLGL to allow make rlgl.pas independent of raylib.pas
// Define INDEPNDENT_RAYMATH to allow make raymath.pas independent of raylib.pas
