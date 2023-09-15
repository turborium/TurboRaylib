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
//  Download compilled Raylib 4.5 library: https://github.com/raysan5/raylib/releases/tag/4.5.0
//
//  Original files: raylib.h
//
//  Translator: @Turborium
//
//  Headers licensed under an unmodified MIT license, that allows static linking with closed source software
//
//  Copyright (c) 2022-2023 Turborium (https://github.com/turborium/TurboRaylib)
// -------------------------------------------------------------------------------------------------------------------

unit raylib;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}
{$ALIGN 8}
{$MINENUMSIZE 4}

interface

{$INCLUDE raylib.inc}

const
  RAYLIB_VERSION = 4.5;

{$IF not Declared(LibName)}
const
  LibName = {$IFDEF MSWINDOWS}'raylib.dll'{$IFEND}{$IFDEF DARWIN}'libraylib.dylib'{$IFEND}{$IFDEF LINUX}'libraylib.so'{$IFEND};
{$ENDIF}

// Returning structs with size equal to or less than 8 bytes - is not defined for cdecl,
// unfortunately raylib makes heavy use of returning structures.
// Delphi x86 always uses the OUT parameter, while msvc returns a structure in EDX:EAX if its size is 1, 2, 4, 8 bytes.
// I get around this problem by converting the structure to UInt8, UInt16, Uint32, UInt64 on import.
// see: https://blog.aaronballman.com/2012/02/describing-the-msvc-abi-for-structure-return-types/
// and this: http://rvelthuis.de/articles/articles-convert.html
{$IF (not Defined(FPC)) and Defined(WIN32)}{$DEFINE RET_TRICK}{$ENDIF}

//----------------------------------------------------------------------------------
// Some basic Defines
//----------------------------------------------------------------------------------

const
  PI = System.Pi;
  EPSILON = 0.000001;
  DEG2RAD = (PI / 180.0);
  RAD2DEG = (180.0 / PI);

//----------------------------------------------------------------------------------
// Enumerators Definition
//----------------------------------------------------------------------------------

// System/Window config flags
// NOTE: Every bit registers one state (use it with bit masks)
// By default all flags are set to 0
type
  PConfigFlags = ^TConfigFlags;
  TConfigFlags = Cardinal;
const
  FLAG_VSYNC_HINT               = TConfigFlags($00000040); // Set to try enabling V-Sync on GPU
  FLAG_FULLSCREEN_MODE          = TConfigFlags($00000002); // Set to run program in fullscreen
  FLAG_WINDOW_RESIZABLE         = TConfigFlags($00000004); // Set to allow resizable window
  FLAG_WINDOW_UNDECORATED       = TConfigFlags($00000008); // Set to disable window decoration (frame and buttons)
  FLAG_WINDOW_HIDDEN            = TConfigFlags($00000080); // Set to hide window
  FLAG_WINDOW_MINIMIZED         = TConfigFlags($00000200); // Set to minimize window (iconify)
  FLAG_WINDOW_MAXIMIZED         = TConfigFlags($00000400); // Set to maximize window (expanded to monitor)
  FLAG_WINDOW_UNFOCUSED         = TConfigFlags($00000800); // Set to window non focused
  FLAG_WINDOW_TOPMOST           = TConfigFlags($00001000); // Set to window always on top
  FLAG_WINDOW_ALWAYS_RUN        = TConfigFlags($00000100); // Set to allow windows running while minimized
  FLAG_WINDOW_TRANSPARENT       = TConfigFlags($00000010); // Set to allow transparent framebuffer
  FLAG_WINDOW_HIGHDPI           = TConfigFlags($00002000); // Set to support HighDPI
  FLAG_WINDOW_MOUSE_PASSTHROUGH = TConfigFlags($00004000); // Set to support mouse passthrough, only supported when FLAG_WINDOW_UNDECORATED
  FLAG_MSAA_4X_HINT             = TConfigFlags($00000020); // Set to try enabling MSAA 4X
  FLAG_INTERLACED_HINT          = TConfigFlags($00010000); // Set to try enabling interlaced video format (for V3D)

// Trace log level
// NOTE: Organized by priority level
type
  PTraceLogLevel = ^TTraceLogLevel;
  TTraceLogLevel = Integer;
const
  LOG_ALL     = TTraceLogLevel(0); // Display all logs
  LOG_TRACE   = TTraceLogLevel(1); // Trace logging, intended for internal use only
  LOG_DEBUG   = TTraceLogLevel(2); // Debug logging, used for internal debugging, it should be disabled on release builds
  LOG_INFO    = TTraceLogLevel(3); // Info logging, used for program execution info
  LOG_WARNING = TTraceLogLevel(4); // Warning logging, used on recoverable failures
  LOG_ERROR   = TTraceLogLevel(5); // Error logging, used on unrecoverable failures
  LOG_FATAL   = TTraceLogLevel(6); // Fatal logging, used to abort program: exit(EXIT_FAILURE)
  LOG_NONE    = TTraceLogLevel(7); // Disable logging

// Keyboard keys (US keyboard layout)
// NOTE: Use GetKeyPressed() to allow redefining
// required keys for alternative layouts
type
  PKeyboardKey = ^TKeyboardKey;
  TKeyboardKey = Integer;
const
  KEY_NULL          = TKeyboardKey(0);   // Key: NULL, used for no key pressed
  // Alphanumeric keys
  KEY_APOSTROPHE    = TKeyboardKey(39);  // Key: '
  KEY_COMMA         = TKeyboardKey(44);  // Key: ,
  KEY_MINUS         = TKeyboardKey(45);  // Key: -
  KEY_PERIOD        = TKeyboardKey(46);  // Key: .
  KEY_SLASH         = TKeyboardKey(47);  // Key: /
  KEY_ZERO          = TKeyboardKey(48);  // Key: 0
  KEY_ONE           = TKeyboardKey(49);  // Key: 1
  KEY_TWO           = TKeyboardKey(50);  // Key: 2
  KEY_THREE         = TKeyboardKey(51);  // Key: 3
  KEY_FOUR          = TKeyboardKey(52);  // Key: 4
  KEY_FIVE          = TKeyboardKey(53);  // Key: 5
  KEY_SIX           = TKeyboardKey(54);  // Key: 6
  KEY_SEVEN         = TKeyboardKey(55);  // Key: 7
  KEY_EIGHT         = TKeyboardKey(56);  // Key: 8
  KEY_NINE          = TKeyboardKey(57);  // Key: 9
  KEY_SEMICOLON     = TKeyboardKey(59);  // Key: ;
  KEY_EQUAL         = TKeyboardKey(61);  // Key: =
  KEY_A             = TKeyboardKey(65);  // Key: A | a
  KEY_B             = TKeyboardKey(66);  // Key: B | b
  KEY_C             = TKeyboardKey(67);  // Key: C | c
  KEY_D             = TKeyboardKey(68);  // Key: D | d
  KEY_E             = TKeyboardKey(69);  // Key: E | e
  KEY_F             = TKeyboardKey(70);  // Key: F | f
  KEY_G             = TKeyboardKey(71);  // Key: G | g
  KEY_H             = TKeyboardKey(72);  // Key: H | h
  KEY_I             = TKeyboardKey(73);  // Key: I | i
  KEY_J             = TKeyboardKey(74);  // Key: J | j
  KEY_K             = TKeyboardKey(75);  // Key: K | k
  KEY_L             = TKeyboardKey(76);  // Key: L | l
  KEY_M             = TKeyboardKey(77);  // Key: M | m
  KEY_N             = TKeyboardKey(78);  // Key: N | n
  KEY_O             = TKeyboardKey(79);  // Key: O | o
  KEY_P             = TKeyboardKey(80);  // Key: P | p
  KEY_Q             = TKeyboardKey(81);  // Key: Q | q
  KEY_R             = TKeyboardKey(82);  // Key: R | r
  KEY_S             = TKeyboardKey(83);  // Key: S | s
  KEY_T             = TKeyboardKey(84);  // Key: T | t
  KEY_U             = TKeyboardKey(85);  // Key: U | u
  KEY_V             = TKeyboardKey(86);  // Key: V | v
  KEY_W             = TKeyboardKey(87);  // Key: W | w
  KEY_X             = TKeyboardKey(88);  // Key: X | x
  KEY_Y             = TKeyboardKey(89);  // Key: Y | y
  KEY_Z             = TKeyboardKey(90);  // Key: Z | z
  KEY_LEFT_BRACKET  = TKeyboardKey(91);  // Key: [
  KEY_BACKSLASH     = TKeyboardKey(92);  // Key: '\'
  KEY_RIGHT_BRACKET = TKeyboardKey(93);  // Key: ]
  KEY_GRAVE         = TKeyboardKey(96);  // Key: `
  // Function keys
  KEY_SPACE         = TKeyboardKey(32);  // Key: Space
  KEY_ESCAPE        = TKeyboardKey(256); // Key: Esc
  KEY_ENTER         = TKeyboardKey(257); // Key: Enter
  KEY_TAB           = TKeyboardKey(258); // Key: Tab
  KEY_BACKSPACE     = TKeyboardKey(259); // Key: Backspace
  KEY_INSERT        = TKeyboardKey(260); // Key: Ins
  KEY_DELETE        = TKeyboardKey(261); // Key: Del
  KEY_RIGHT         = TKeyboardKey(262); // Key: Cursor right
  KEY_LEFT          = TKeyboardKey(263); // Key: Cursor left
  KEY_DOWN          = TKeyboardKey(264); // Key: Cursor down
  KEY_UP            = TKeyboardKey(265); // Key: Cursor up
  KEY_PAGE_UP       = TKeyboardKey(266); // Key: Page up
  KEY_PAGE_DOWN     = TKeyboardKey(267); // Key: Page down
  KEY_HOME          = TKeyboardKey(268); // Key: Home
  KEY_END           = TKeyboardKey(269); // Key: End
  KEY_CAPS_LOCK     = TKeyboardKey(280); // Key: Caps lock
  KEY_SCROLL_LOCK   = TKeyboardKey(281); // Key: Scroll down
  KEY_NUM_LOCK      = TKeyboardKey(282); // Key: Num lock
  KEY_PRINT_SCREEN  = TKeyboardKey(283); // Key: Print screen
  KEY_PAUSE         = TKeyboardKey(284); // Key: Pause
  KEY_F1            = TKeyboardKey(290); // Key: F1
  KEY_F2            = TKeyboardKey(291); // Key: F2
  KEY_F3            = TKeyboardKey(292); // Key: F3
  KEY_F4            = TKeyboardKey(293); // Key: F4
  KEY_F5            = TKeyboardKey(294); // Key: F5
  KEY_F6            = TKeyboardKey(295); // Key: F6
  KEY_F7            = TKeyboardKey(296); // Key: F7
  KEY_F8            = TKeyboardKey(297); // Key: F8
  KEY_F9            = TKeyboardKey(298); // Key: F9
  KEY_F10           = TKeyboardKey(299); // Key: F10
  KEY_F11           = TKeyboardKey(300); // Key: F11
  KEY_F12           = TKeyboardKey(301); // Key: F12
  KEY_LEFT_SHIFT    = TKeyboardKey(340); // Key: Shift left
  KEY_LEFT_CONTROL  = TKeyboardKey(341); // Key: Control left
  KEY_LEFT_ALT      = TKeyboardKey(342); // Key: Alt left
  KEY_LEFT_SUPER    = TKeyboardKey(343); // Key: Super left
  KEY_RIGHT_SHIFT   = TKeyboardKey(344); // Key: Shift right
  KEY_RIGHT_CONTROL = TKeyboardKey(345); // Key: Control right
  KEY_RIGHT_ALT     = TKeyboardKey(346); // Key: Alt right
  KEY_RIGHT_SUPER   = TKeyboardKey(347); // Key: Super right
  KEY_KB_MENU       = TKeyboardKey(348); // Key: KB menu
  // Keypad keys
  KEY_KP_0          = TKeyboardKey(320); // Key: Keypad 0
  KEY_KP_1          = TKeyboardKey(321); // Key: Keypad 1
  KEY_KP_2          = TKeyboardKey(322); // Key: Keypad 2
  KEY_KP_3          = TKeyboardKey(323); // Key: Keypad 3
  KEY_KP_4          = TKeyboardKey(324); // Key: Keypad 4
  KEY_KP_5          = TKeyboardKey(325); // Key: Keypad 5
  KEY_KP_6          = TKeyboardKey(326); // Key: Keypad 6
  KEY_KP_7          = TKeyboardKey(327); // Key: Keypad 7
  KEY_KP_8          = TKeyboardKey(328); // Key: Keypad 8
  KEY_KP_9          = TKeyboardKey(329); // Key: Keypad 9
  KEY_KP_DECIMAL    = TKeyboardKey(330); // Key: Keypad .
  KEY_KP_DIVIDE     = TKeyboardKey(331); // Key: Keypad /
  KEY_KP_MULTIPLY   = TKeyboardKey(332); // Key: Keypad *
  KEY_KP_SUBTRACT   = TKeyboardKey(333); // Key: Keypad -
  KEY_KP_ADD        = TKeyboardKey(334); // Key: Keypad +
  KEY_KP_ENTER      = TKeyboardKey(335); // Key: Keypad Enter
  KEY_KP_EQUAL      = TKeyboardKey(336); // Key: Keypad =
  // Android key buttons
  KEY_BACK          = TKeyboardKey(4);   // Key: Android back button
  KEY_MENU          = TKeyboardKey(82);  // Key: Android menu button
  KEY_VOLUME_UP     = TKeyboardKey(24);  // Key: Android volume up button
  KEY_VOLUME_DOWN   = TKeyboardKey(25);  // Key: Android volume down button

// Mouse buttons
type
  PMouseButton = ^TMouseButton;
  TMouseButton = Cardinal;
const
  MOUSE_BUTTON_LEFT    = TMouseButton(0); // Mouse button left
  MOUSE_BUTTON_RIGHT   = TMouseButton(1); // Mouse button right
  MOUSE_BUTTON_MIDDLE  = TMouseButton(2); // Mouse button middle (pressed wheel)
  MOUSE_BUTTON_SIDE    = TMouseButton(3); // Mouse button side (advanced mouse device)
  MOUSE_BUTTON_EXTRA   = TMouseButton(4); // Mouse button extra (advanced mouse device)
  MOUSE_BUTTON_FORWARD = TMouseButton(5); // Mouse button forward (advanced mouse device)
  MOUSE_BUTTON_BACK    = TMouseButton(6); // Mouse button back (advanced mouse device)

// Mouse cursor
type
  PMouseCursor = ^TMouseCursor;
  TMouseCursor = Integer;
const
  MOUSE_CURSOR_DEFAULT       = TMouseCursor(0);  // Default pointer shape
  MOUSE_CURSOR_ARROW         = TMouseCursor(1);  // Arrow shape
  MOUSE_CURSOR_IBEAM         = TMouseCursor(2);  // Text writing cursor shape
  MOUSE_CURSOR_CROSSHAIR     = TMouseCursor(3);  // Cross shape
  MOUSE_CURSOR_POINTING_HAND = TMouseCursor(4);  // Pointing hand cursor
  MOUSE_CURSOR_RESIZE_EW     = TMouseCursor(5);  // Horizontal resize/move arrow shape
  MOUSE_CURSOR_RESIZE_NS     = TMouseCursor(6);  // Vertical resize/move arrow shape
  MOUSE_CURSOR_RESIZE_NWSE   = TMouseCursor(7);  // Top-left to bottom-right diagonal resize/move arrow shape
  MOUSE_CURSOR_RESIZE_NESW   = TMouseCursor(8);  // The top-right to bottom-left diagonal resize/move arrow shape
  MOUSE_CURSOR_RESIZE_ALL    = TMouseCursor(9);  // The omnidirectional resize/move cursor shape
  MOUSE_CURSOR_NOT_ALLOWED   = TMouseCursor(10); // The operation-not-allowed shape

// Gamepad buttons
type
  PGamepadButton = ^TGamepadButton;
  TGamepadButton = Integer;
const
  GAMEPAD_BUTTON_UNKNOWN          = TGamepadButton(0);  // Unknown button, just for error checking
  GAMEPAD_BUTTON_LEFT_FACE_UP     = TGamepadButton(1);  // Gamepad left DPAD up button
  GAMEPAD_BUTTON_LEFT_FACE_RIGHT  = TGamepadButton(2);  // Gamepad left DPAD right button
  GAMEPAD_BUTTON_LEFT_FACE_DOWN   = TGamepadButton(3);  // Gamepad left DPAD down button
  GAMEPAD_BUTTON_LEFT_FACE_LEFT   = TGamepadButton(4);  // Gamepad left DPAD left button
  GAMEPAD_BUTTON_RIGHT_FACE_UP    = TGamepadButton(5);  // Gamepad right button up (i.e. PS3: Triangle, Xbox: Y)
  GAMEPAD_BUTTON_RIGHT_FACE_RIGHT = TGamepadButton(6);  // Gamepad right button right (i.e. PS3: Square, Xbox: X)
  GAMEPAD_BUTTON_RIGHT_FACE_DOWN  = TGamepadButton(7);  // Gamepad right button down (i.e. PS3: Cross, Xbox: A)
  GAMEPAD_BUTTON_RIGHT_FACE_LEFT  = TGamepadButton(8);  // Gamepad right button left (i.e. PS3: Circle, Xbox: B)
  GAMEPAD_BUTTON_LEFT_TRIGGER_1   = TGamepadButton(9);  // Gamepad top/back trigger left (first), it could be a trailing button
  GAMEPAD_BUTTON_LEFT_TRIGGER_2   = TGamepadButton(10); // Gamepad top/back trigger left (second), it could be a trailing button
  GAMEPAD_BUTTON_RIGHT_TRIGGER_1  = TGamepadButton(11); // Gamepad top/back trigger right (one), it could be a trailing button
  GAMEPAD_BUTTON_RIGHT_TRIGGER_2  = TGamepadButton(12); // Gamepad top/back trigger right (second), it could be a trailing button
  GAMEPAD_BUTTON_MIDDLE_LEFT      = TGamepadButton(13); // Gamepad center buttons, left one (i.e. PS3: Select)
  GAMEPAD_BUTTON_MIDDLE           = TGamepadButton(14); // Gamepad center buttons, middle one (i.e. PS3: PS, Xbox: XBOX)
  GAMEPAD_BUTTON_MIDDLE_RIGHT     = TGamepadButton(15); // Gamepad center buttons, right one (i.e. PS3: Start)
  GAMEPAD_BUTTON_LEFT_THUMB       = TGamepadButton(16); // Gamepad joystick pressed button left
  GAMEPAD_BUTTON_RIGHT_THUMB      = TGamepadButton(17); // Gamepad joystick pressed button right

// Gamepad axis
type
  PGamepadAxis = ^TGamepadAxis;
  TGamepadAxis = Integer;
const
  GAMEPAD_AXIS_LEFT_X        = TGamepadAxis(0); // Gamepad left stick X axis
  GAMEPAD_AXIS_LEFT_Y        = TGamepadAxis(1); // Gamepad left stick Y axis
  GAMEPAD_AXIS_RIGHT_X       = TGamepadAxis(2); // Gamepad right stick X axis
  GAMEPAD_AXIS_RIGHT_Y       = TGamepadAxis(3); // Gamepad right stick Y axis
  GAMEPAD_AXIS_LEFT_TRIGGER  = TGamepadAxis(4); // Gamepad back trigger left, pressure level: [1..-1]
  GAMEPAD_AXIS_RIGHT_TRIGGER = TGamepadAxis(5); // Gamepad back trigger right, pressure level: [1..-1]

// Material map index
type
  PMaterialMapIndex = ^TMaterialMapIndex;
  TMaterialMapIndex = Integer;
const
  MATERIAL_MAP_ALBEDO     = TMaterialMapIndex(0);  // Albedo material (same as: MATERIAL_MAP_DIFFUSE)
  MATERIAL_MAP_METALNESS  = TMaterialMapIndex(1);  // Metalness material (same as: MATERIAL_MAP_SPECULAR)
  MATERIAL_MAP_NORMAL     = TMaterialMapIndex(2);  // Normal material
  MATERIAL_MAP_ROUGHNESS  = TMaterialMapIndex(3);  // Roughness material
  MATERIAL_MAP_OCCLUSION  = TMaterialMapIndex(4);  // Ambient occlusion material
  MATERIAL_MAP_EMISSION   = TMaterialMapIndex(5);  // Emission material
  MATERIAL_MAP_HEIGHT     = TMaterialMapIndex(6);  // Heightmap material
  MATERIAL_MAP_CUBEMAP    = TMaterialMapIndex(7);  // Cubemap material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
  MATERIAL_MAP_IRRADIANCE = TMaterialMapIndex(8);  // Irradiance material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
  MATERIAL_MAP_PREFILTER  = TMaterialMapIndex(9);  // Prefilter material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
  MATERIAL_MAP_BRDF       = TMaterialMapIndex(10); // Brdf material
  MATERIAL_MAP_DIFFUSE    = MATERIAL_MAP_ALBEDO;
  MATERIAL_MAP_SPECULAR   = MATERIAL_MAP_METALNESS;

// Shader location index
type
  PShaderLocationIndex = ^TShaderLocationIndex;
  TShaderLocationIndex = Integer;
const
  SHADER_LOC_VERTEX_POSITION   = TShaderLocationIndex(0);  // Shader location: vertex attribute: position
  SHADER_LOC_VERTEX_TEXCOORD01 = TShaderLocationIndex(1);  // Shader location: vertex attribute: texcoord01
  SHADER_LOC_VERTEX_TEXCOORD02 = TShaderLocationIndex(2);  // Shader location: vertex attribute: texcoord02
  SHADER_LOC_VERTEX_NORMAL     = TShaderLocationIndex(3);  // Shader location: vertex attribute: normal
  SHADER_LOC_VERTEX_TANGENT    = TShaderLocationIndex(4);  // Shader location: vertex attribute: tangent
  SHADER_LOC_VERTEX_COLOR      = TShaderLocationIndex(5);  // Shader location: vertex attribute: color
  SHADER_LOC_MATRIX_MVP        = TShaderLocationIndex(6);  // Shader location: matrix uniform: model-view-projection
  SHADER_LOC_MATRIX_VIEW       = TShaderLocationIndex(7);  // Shader location: matrix uniform: view (camera transform)
  SHADER_LOC_MATRIX_PROJECTION = TShaderLocationIndex(8);  // Shader location: matrix uniform: projection
  SHADER_LOC_MATRIX_MODEL      = TShaderLocationIndex(9);  // Shader location: matrix uniform: model (transform)
  SHADER_LOC_MATRIX_NORMAL     = TShaderLocationIndex(10); // Shader location: matrix uniform: normal
  SHADER_LOC_VECTOR_VIEW       = TShaderLocationIndex(11); // Shader location: vector uniform: view
  SHADER_LOC_COLOR_DIFFUSE     = TShaderLocationIndex(12); // Shader location: vector uniform: diffuse color
  SHADER_LOC_COLOR_SPECULAR    = TShaderLocationIndex(13); // Shader location: vector uniform: specular color
  SHADER_LOC_COLOR_AMBIENT     = TShaderLocationIndex(14); // Shader location: vector uniform: ambient color
  SHADER_LOC_MAP_ALBEDO        = TShaderLocationIndex(15); // Shader location: sampler2d texture: albedo (same as: SHADER_LOC_MAP_DIFFUSE)
  SHADER_LOC_MAP_METALNESS     = TShaderLocationIndex(16); // Shader location: sampler2d texture: metalness (same as: SHADER_LOC_MAP_SPECULAR)
  SHADER_LOC_MAP_NORMAL        = TShaderLocationIndex(17); // Shader location: sampler2d texture: normal
  SHADER_LOC_MAP_ROUGHNESS     = TShaderLocationIndex(18); // Shader location: sampler2d texture: roughness
  SHADER_LOC_MAP_OCCLUSION     = TShaderLocationIndex(19); // Shader location: sampler2d texture: occlusion
  SHADER_LOC_MAP_EMISSION      = TShaderLocationIndex(20); // Shader location: sampler2d texture: emission
  SHADER_LOC_MAP_HEIGHT        = TShaderLocationIndex(21); // Shader location: sampler2d texture: height
  SHADER_LOC_MAP_CUBEMAP       = TShaderLocationIndex(22); // Shader location: samplerCube texture: cubemap
  SHADER_LOC_MAP_IRRADIANCE    = TShaderLocationIndex(23); // Shader location: samplerCube texture: irradiance
  SHADER_LOC_MAP_PREFILTER     = TShaderLocationIndex(24); // Shader location: samplerCube texture: prefilter
  SHADER_LOC_MAP_BRDF          = TShaderLocationIndex(25); // Shader location: sampler2d texture: brdf
  SHADER_LOC_MAP_DIFFUSE       = SHADER_LOC_MAP_ALBEDO;
  SHADER_LOC_MAP_SPECULAR      = SHADER_LOC_MAP_METALNESS;

// Shader uniform data type
type
  PShaderUniformDataType = ^TShaderUniformDataType;
  TShaderUniformDataType = Integer;
const
  SHADER_UNIFORM_FLOAT     = TShaderUniformDataType(0); // Shader uniform type: float
  SHADER_UNIFORM_VEC2      = TShaderUniformDataType(1); // Shader uniform type: vec2 (2 float)
  SHADER_UNIFORM_VEC3      = TShaderUniformDataType(2); // Shader uniform type: vec3 (3 float)
  SHADER_UNIFORM_VEC4      = TShaderUniformDataType(3); // Shader uniform type: vec4 (4 float)
  SHADER_UNIFORM_INT       = TShaderUniformDataType(4); // Shader uniform type: int
  SHADER_UNIFORM_IVEC2     = TShaderUniformDataType(5); // Shader uniform type: ivec2 (2 int)
  SHADER_UNIFORM_IVEC3     = TShaderUniformDataType(6); // Shader uniform type: ivec3 (3 int)
  SHADER_UNIFORM_IVEC4     = TShaderUniformDataType(7); // Shader uniform type: ivec4 (4 int)
  SHADER_UNIFORM_SAMPLER2D = TShaderUniformDataType(8); // Shader uniform type: sampler2d

// Shader attribute data types
type
  PShaderAttributeDataType = ^TShaderAttributeDataType;
  TShaderAttributeDataType = Integer;
const
  SHADER_ATTRIB_FLOAT = TShaderAttributeDataType(0); // Shader attribute type: float
  SHADER_ATTRIB_VEC2  = TShaderAttributeDataType(1); // Shader attribute type: vec2 (2 float)
  SHADER_ATTRIB_VEC3  = TShaderAttributeDataType(2); // Shader attribute type: vec3 (3 float)
  SHADER_ATTRIB_VEC4  = TShaderAttributeDataType(3); // Shader attribute type: vec4 (4 float)

// Pixel formats
// NOTE: Support depends on OpenGL version and platform
type
  PPixelFormat = ^TPixelFormat;
  TPixelFormat = Integer;
const
  PIXELFORMAT_UNCOMPRESSED_GRAYSCALE    = TPixelFormat(1);  // 8 bit per pixel (no alpha)
  PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA   = TPixelFormat(2);  // 8*2 bpp (2 channels)
  PIXELFORMAT_UNCOMPRESSED_R5G6B5       = TPixelFormat(3);  // 16 bpp
  PIXELFORMAT_UNCOMPRESSED_R8G8B8       = TPixelFormat(4);  // 24 bpp
  PIXELFORMAT_UNCOMPRESSED_R5G5B5A1     = TPixelFormat(5);  // 16 bpp (1 bit alpha)
  PIXELFORMAT_UNCOMPRESSED_R4G4B4A4     = TPixelFormat(6);  // 16 bpp (4 bit alpha)
  PIXELFORMAT_UNCOMPRESSED_R8G8B8A8     = TPixelFormat(7);  // 32 bpp
  PIXELFORMAT_UNCOMPRESSED_R32          = TPixelFormat(8);  // 32 bpp (1 channel - float)
  PIXELFORMAT_UNCOMPRESSED_R32G32B32    = TPixelFormat(9);  // 32*3 bpp (3 channels - float)
  PIXELFORMAT_UNCOMPRESSED_R32G32B32A32 = TPixelFormat(10); // 32*4 bpp (4 channels - float)
  PIXELFORMAT_COMPRESSED_DXT1_RGB       = TPixelFormat(11); // 4 bpp (no alpha)
  PIXELFORMAT_COMPRESSED_DXT1_RGBA      = TPixelFormat(12); // 4 bpp (1 bit alpha)
  PIXELFORMAT_COMPRESSED_DXT3_RGBA      = TPixelFormat(13); // 8 bpp
  PIXELFORMAT_COMPRESSED_DXT5_RGBA      = TPixelFormat(14); // 8 bpp
  PIXELFORMAT_COMPRESSED_ETC1_RGB       = TPixelFormat(15); // 4 bpp
  PIXELFORMAT_COMPRESSED_ETC2_RGB       = TPixelFormat(16); // 4 bpp
  PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA  = TPixelFormat(17); // 8 bpp
  PIXELFORMAT_COMPRESSED_PVRT_RGB       = TPixelFormat(18); // 4 bpp
  PIXELFORMAT_COMPRESSED_PVRT_RGBA      = TPixelFormat(19); // 4 bpp
  PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA  = TPixelFormat(20); // 8 bpp
  PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA  = TPixelFormat(21); // 2 bpp

// Texture parameters: filter mode
// NOTE 1: Filtering considers mipmaps if available in the texture
// NOTE 2: Filter is accordingly set for minification and magnification
type
  PTextureFilter = ^TTextureFilter;
  TTextureFilter = Integer;
const
  TEXTURE_FILTER_POINT           = TTextureFilter(0); // No filter, just pixel approximation
  TEXTURE_FILTER_BILINEAR        = TTextureFilter(1); // Linear filtering
  TEXTURE_FILTER_TRILINEAR       = TTextureFilter(2); // Trilinear filtering (linear with mipmaps)
  TEXTURE_FILTER_ANISOTROPIC_4X  = TTextureFilter(3); // Anisotropic filtering 4x
  TEXTURE_FILTER_ANISOTROPIC_8X  = TTextureFilter(4); // Anisotropic filtering 8x
  TEXTURE_FILTER_ANISOTROPIC_16X = TTextureFilter(5); // Anisotropic filtering 16x

// Texture parameters: wrap mode
type
  PTextureWrap = ^TTextureWrap;
  TTextureWrap = Integer;
const
  TEXTURE_WRAP_REPEAT        = TTextureWrap(0); // Repeats texture in tiled mode
  TEXTURE_WRAP_CLAMP         = TTextureWrap(1); // Clamps texture to edge pixel in tiled mode
  TEXTURE_WRAP_MIRROR_REPEAT = TTextureWrap(2); // Mirrors and repeats the texture in tiled mode
  TEXTURE_WRAP_MIRROR_CLAMP  = TTextureWrap(3); // Mirrors and clamps to border the texture in tiled mode

// Cubemap layouts
type
  PCubemapLayout = ^TCubemapLayout;
  TCubemapLayout = Integer;
const
  CUBEMAP_LAYOUT_AUTO_DETECT         = TCubemapLayout(0); // Automatically detect layout type
  CUBEMAP_LAYOUT_LINE_VERTICAL       = TCubemapLayout(1); // Layout is defined by a vertical line with faces
  CUBEMAP_LAYOUT_LINE_HORIZONTAL     = TCubemapLayout(2); // Layout is defined by a horizontal line with faces
  CUBEMAP_LAYOUT_CROSS_THREE_BY_FOUR = TCubemapLayout(3); // Layout is defined by a 3x4 cross with cubemap faces
  CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE = TCubemapLayout(4); // Layout is defined by a 4x3 cross with cubemap faces
  CUBEMAP_LAYOUT_PANORAMA            = TCubemapLayout(5); // Layout is defined by a panorama image (equirectangular map)

// Font type, defines generation method
type
  PFontType = ^TFontType;
  TFontType = Integer;
const
  FONT_DEFAULT = TFontType(0); // Default font generation, anti-aliased
  FONT_BITMAP  = TFontType(1); // Bitmap font generation, no anti-aliasing
  FONT_SDF     = TFontType(2); // SDF font generation, requires external shader

// Color blending modes (pre-defined)
type
  PBlendMode = ^TBlendMode;
  TBlendMode = Integer;
const
  BLEND_ALPHA             = TBlendMode(0); // Blend textures considering alpha (default)
  BLEND_ADDITIVE          = TBlendMode(1); // Blend textures adding colors
  BLEND_MULTIPLIED        = TBlendMode(2); // Blend textures multiplying colors
  BLEND_ADD_COLORS        = TBlendMode(3); // Blend textures adding colors (alternative)
  BLEND_SUBTRACT_COLORS   = TBlendMode(4); // Blend textures subtracting colors (alternative)
  BLEND_ALPHA_PREMULTIPLY = TBlendMode(5); // Blend premultiplied textures considering alpha
  BLEND_CUSTOM            = TBlendMode(6); // Blend textures using custom src/dst factors (use rlSetBlendFactors())
  BLEND_CUSTOM_SEPARATE   = TBlendMode(7); // Blend textures using custom rgb/alpha separate src/dst factors (use rlSetBlendFactorsSeparate())

// Gestures
// NOTE: Provided as bit-wise flags to enable only desired gestures
type
  PGesture = ^TGesture;
  TGesture = Cardinal;
const
  GESTURE_NONE        = TGesture(0);   // No gesture
  GESTURE_TAP         = TGesture(1);   // Tap gesture
  GESTURE_DOUBLETAP   = TGesture(2);   // Double tap gesture
  GESTURE_HOLD        = TGesture(4);   // Hold gesture
  GESTURE_DRAG        = TGesture(8);   // Drag gesture
  GESTURE_SWIPE_RIGHT = TGesture(16);  // Swipe right gesture
  GESTURE_SWIPE_LEFT  = TGesture(32);  // Swipe left gesture
  GESTURE_SWIPE_UP    = TGesture(64);  // Swipe up gesture
  GESTURE_SWIPE_DOWN  = TGesture(128); // Swipe down gesture
  GESTURE_PINCH_IN    = TGesture(256); // Pinch in gesture
  GESTURE_PINCH_OUT   = TGesture(512); // Pinch out gesture

// Camera system modes
type
  PCameraMode = ^TCameraMode;
  TCameraMode = Integer;
const
  CAMERA_CUSTOM       = TCameraMode(0); // Custom camera
  CAMERA_FREE         = TCameraMode(1); // Free camera
  CAMERA_ORBITAL      = TCameraMode(2); // Orbital camera
  CAMERA_FIRST_PERSON = TCameraMode(3); // First person camera
  CAMERA_THIRD_PERSON = TCameraMode(4); // Third person camera

// Camera projection
type
  PCameraProjection = ^TCameraProjection;
  TCameraProjection = Integer;
const
  CAMERA_PERSPECTIVE  = TCameraProjection(0); // Perspective projection
  CAMERA_ORTHOGRAPHIC = TCameraProjection(1); // Orthographic projection

// N-patch layout
type
  PNPatchLayout = ^TNPatchLayout;
  TNPatchLayout = Integer;
const
  NPATCH_NINE_PATCH             = TNPatchLayout(0); // Npatch layout: 3x3 tiles
  NPATCH_THREE_PATCH_VERTICAL   = TNPatchLayout(1); // Npatch layout: 1x3 tiles
  NPATCH_THREE_PATCH_HORIZONTAL = TNPatchLayout(2); // Npatch layout: 3x1 tiles

// Callbacks to hook some internal functions
// WARNING: These callbacks are intended for advance users
type
  // Logging: Redirect trace log messages
  TTraceLogCallback = procedure(LogLevel: TTraceLogLevel; const Text: PAnsiChar; Args: Pointer); cdecl varargs;
  // FileIO: Load binary data
  TLoadFileDataCallback = function(FileName: PAnsiChar; out BytesRead: Cardinal): PAnsiChar; cdecl;
  // FileIO: Save binary data
  TSaveFileDataCallback = function(FileName: PAnsiChar; Data: Pointer; BytesToWrite: Cardinal): Boolean; cdecl;
  // FileIO: Load text data
  TLoadFileTextCallback = function(FileName: PAnsiChar): PAnsiChar; cdecl;
  // FileIO: Save text data
  TSaveFileTextCallback = function(FileName: PAnsiChar; Text: PAnsiChar): Boolean; cdecl;

//----------------------------------------------------------------------------------
// Structures Definition
//----------------------------------------------------------------------------------

type
  // Vector2, 2 components
  PVector2 = ^TVector2;
  TVector2 = record
    X: Single; // Vector x component
    Y: Single; // Vector y component
    constructor Create(X, Y: Single);
  end;

  // Vector3, 3 components
  PVector3 = ^TVector3;
  TVector3 = record
    X: Single; // Vector x component
    Y: Single; // Vector y component
    Z: Single; // Vector z component
    constructor Create(X, Y, Z: Single);
  end;

  // Vector4, 4 components
  PVector4 = ^TVector4;
  TVector4 = record
    X: Single; // Vector x component
    Y: Single; // Vector y component
    Z: Single; // Vector z component
    W: Single; // Vector w component
    constructor Create(X, Y, Z, W: Single);
  end;

  // Quaternion, 4 components (Vector4 alias)
  PQuaternion = ^TQuaternion;
  TQuaternion = TVector4;

  // Matrix, 4x4 components, column major, OpenGL style, right-handed
  PMatrix = ^TMatrix;
  TMatrix = record
    M0, M4, M8, M12: Single;  // Matrix first row (4 components)
    M1, M5, M9, M13: Single;  // Matrix second row (4 components)
    M2, M6, M10, M14: Single; // Matrix third row (4 components)
    M3, M7, M11, M15: Single; // Matrix fourth row (4 components)
  end;

  // Color, 4 components, R8G8B8A8 (32bit)
  PColor = ^TColor;
  TColor = record
    R: Byte; // Color red value
    G: Byte; // Color green value
    B: Byte; // Color blue value
    A: Byte; // Color alpha value
    constructor Create(R, G, B, A: Byte);
  end;

  // Rectangle, 4 components
  PPRectangle = ^PRectangle;
  PRectangle = ^TRectangle;
  TRectangle = record
    X: Single;      // Rectangle top-left corner position x
    Y: Single;      // Rectangle top-left corner position y
    Width: Single;  // Rectangle width
    Height: Single; // Rectangle height
    constructor Create(X, Y, Width, Height: Single);
  end;

  // Image, pixel data stored in CPU memory (RAM)
  PImage = ^TImage;
  TImage = record
    Data: Pointer;         // Image raw data
    Width: Integer;        // Image base width
    Height: Integer;       // Image base height
    Mipmaps: Integer;      // Mipmap levels, 1 by default
    Format: TPixelFormat;  // Data format (PixelFormat type)
    constructor Create(Data: Pointer; Width, Height: Integer; Mipmaps: Integer; Format: TPixelFormat);
  end;

  // Texture, tex data stored in GPU memory (VRAM)
  PTexture = ^TTexture;
  TTexture = record
    Id: Cardinal;          // OpenGL texture id
    Width: Integer;        // Texture base width
    Height: Integer;       // Texture base height
    Mipmaps: Integer;      // Mipmap levels, 1 by default
    Format: TPixelFormat;  // Data format (PixelFormat type)
    constructor Create(Id: Cardinal; Width, Height: Integer; Mipmaps: Integer; Format: TPixelFormat);
  end;

  // Texture2D, same as Texture
  PTexture2D = ^TTexture2D;
  TTexture2D = TTexture;

  // TextureCubemap, same as Texture
  PTextureCubemap = ^TTextureCubemap;
  TTextureCubemap = TTexture;

  // RenderTexture, fbo for texture rendering
  PRenderTexture = ^TRenderTexture;
  TRenderTexture = record
    Id: Cardinal;      // OpenGL framebuffer object id
    Texture: TTexture; // Color buffer attachment texture
    Depth: TTexture;   // Depth buffer attachment texture
  end;

  // RenderTexture2D, same as RenderTexture
  PRenderTexture2D = ^TRenderTexture2D;
  TRenderTexture2D = TRenderTexture;

  // NPatchInfo, n-patch layout info
  PNPatchInfo = ^TNPatchInfo;
  TNPatchInfo = record
    Source: TRectangle;    // Texture source rectangle
    Left: Integer;         // Left border offset
    Top: Integer;          // Top border offset
    Right: Integer;        // Right border offset
    Bottom: Integer;       // Bottom border offset
    Layout: TNPatchLayout; // Layout of the n-patch: 3x3, 1x3 or 3x1
    constructor Create(Source: TRectangle; Left, Top, Right, Bottom: Integer; Layout: TNPatchLayout);
  end;

  // GlyphInfo, font characters glyphs info
  PGlyphInfo = ^TGlyphInfo;
  TGlyphInfo = record
    Value: Integer;    // Character value (Unicode)
    OffsetX: Integer;  // Character offset X when drawing
    OffsetY: Integer;  // Character offset Y when drawing
    AdvanceX: Integer; // Character advance position X
    Image: TImage;     // Character image data
  end;

  // Font, font texture and GlyphInfo array data
  PFont = ^TFont;
  TFont = record
    BaseSize: Integer;     // Base size (default chars height)
    GlyphCount: Integer;   // Number of glyph characters
    GlyphPadding: Integer; // Padding around the glyph characters
    Texture: TTexture2D;   // Texture atlas containing the glyphs
    Recs: PRectangle;      // Rectangles in texture for the glyphs
    Glyphs: PGlyphInfo;    // Glyphs info data
  end;

  // Camera, defines position/orientation in 3d space
  PCamera3D = ^TCamera3D;
  TCamera3D = record
    Position: TVector3;            // Camera position
    Target: TVector3;              // Camera target it looks-at
    Up: TVector3;                  // Camera up vector (rotation over its axis)
    Fovy: Single;                  // Camera field-of-view aperture in Y (degrees) in perspective, used as near plane width in orthographic
    Projection: TCameraProjection; // Camera projection: CAMERA_PERSPECTIVE or CAMERA_ORTHOGRAPHIC
    constructor Create(Position, Target, Up: TVector3; Fovy: Single; Projection: TCameraProjection);
  end;

  // Camera type fallback, defaults to Camera3D
  PCamera = ^TCamera;
  TCamera = TCamera3D;

  // Camera2D, defines position/orientation in 2d space
  PCamera2D = ^TCamera2D;
  TCamera2D = record
    Offset: TVector2; // Camera offset (displacement from target)
    Target: TVector2; // Camera target (rotation and zoom origin)
    Rotation: Single; // Camera rotation in degrees
    Zoom: Single;     // Camera zoom (scaling), should be 1.0f by default
    constructor Create(Offset, Target: TVector2; Rotation, Zoom: Single);
  end;

  // Mesh, vertex data and vao/vbo
  PMesh = ^TMesh;
  TMesh = record
    VertexCount: Integer;   // Number of vertices stored in arrays
    TriangleCount: Integer; // Number of triangles stored (indexed or not)
    // Vertex attributes data
    Vertices: PSingle;      // Vertex position (XYZ - 3 components per vertex) (shader-location = 0)
    Texcoords: PSingle;     // Vertex texture coordinates (UV - 2 components per vertex) (shader-location = 1)
    Texcoords2: PSingle;    // Vertex texture second coordinates (UV - 2 components per vertex) (shader-location = 5)
    Normals: PSingle;       // Vertex normals (XYZ - 3 components per vertex) (shader-location = 2)
    Tangents: PSingle;      // Vertex tangents (XYZW - 4 components per vertex) (shader-location = 4)
    Colors: PByte;          // Vertex colors (RGBA - 4 components per vertex) (shader-location = 3)
    Indices: PWord;         // Vertex indices (in case vertex data comes indexed)
    // Animation vertex data
    AnimVertices: PSingle;  // Animated vertex positions (after bones transformations)
    AnimNormals: PSingle;   // Animated normals (after bones transformations)
    BoneIds: PByte;         // Vertex bone ids, up to 4 bones influence by vertex (skinning)
    BoneWeights: PSingle;   // Vertex bone weight, up to 4 bones influence by vertex (skinning)
    // OpenGL identifiers
    VaoId: Cardinal;        // OpenGL Vertex Array Object id
    VboId: PCardinal;       // OpenGL Vertex Buffer Objects id (default vertex data)
  end;

  // Shader
  PShader = ^TShader;
  TShader = record
    Id: Cardinal;   // Shader program id
    Locs: PInteger; // Shader locations array (RL_MAX_SHADER_LOCATIONS)
  end;

  // MaterialMap
  PMaterialMap = ^TMaterialMap;
  TMaterialMap = record
    Texture: TTexture2D; // Material map texture
    Color: TColor;       // Material map color
    Value: Single;       // Material map value
  end;

  // Material, includes shader and maps
  PMaterial = ^TMaterial;
  TMaterial = record
    Shader: TShader;               // Material shader
    Maps: PMaterialMap;            // Material maps array (MAX_MATERIAL_MAPS)
    Params: array [0..3] of Single; // Material generic parameters (if required)
  end;

  // Transform, vertex transformation data
  PPTransform = ^PTransform;
  PTransform = ^TTransform;
  TTransform = record
    Translation: TVector3; // Translation
    Rotation: TQuaternion; // Rotation
    Scale: TVector3;       // Scale
    constructor Create(Translation: TVector3; Rotation: TQuaternion; Scale: TVector3);
  end;

  // Bone, skeletal animation bone
  PBoneInfo = ^TBoneInfo;
  TBoneInfo = record
    Name: array [0..31] of AnsiChar; // Bone name
    Parent: Integer;                 // Bone parent
  end;

  // Model, meshes, materials and animation data
  PModel = ^TModel;
  TModel = record
    Transform: TMatrix;     // Local transform matrix
    MeshCount: Integer;     // Number of meshes
    MaterialCount: Integer; // Number of materials
    Meshes: PMesh;          // Meshes array
    Materials: PMaterial;   // Materials array
    MeshMaterial: PInteger; // Mesh material number
    // Animation data
    BoneCount: Integer;     // Number of bones
    Bones: PBoneInfo;       // Bones information (skeleton)
    BindPose: PTransform;   // Bones base transformation (pose)
  end;

  // ModelAnimation
  PModelAnimation = ^TModelAnimation;
  TModelAnimation = record
    BoneCount: Integer;      // Number of bones
    FrameCount: Integer;     // Number of animation frames
    Bones: PBoneInfo;        // Bones information (skeleton)
    FramePoses: PPTransform; // Poses array by frame
  end;

  // Ray, ray for raycasting
  PRay = ^TRay;
  TRay = record
    Position: TVector3;  // Ray position (origin)
    Direction: TVector3; // Ray direction
  end;

  // RayCollision, ray hit information
  PRayCollision = ^TRayCollision;
  TRayCollision = record
    Hit: Boolean;     // Did the ray hit something?
    Distance: Single; // Distance to the nearest hit
    Point: TVector3;  // Point of the nearest hit
    Normal: TVector3; // Surface normal of hit
  end;

  // BoundingBox
  PBoundingBox = ^TBoundingBox;
  TBoundingBox = record
    Min: TVector3; // Minimum vertex box-corner
    Max: TVector3; // Maximum vertex box-corner
    constructor Create(Min, Max: TVector3);
  end;

  // Wave, audio wave data
  PWave = ^TWave;
  TWave = record
    FrameCount: Cardinal; // Total number of frames (considering channels)
    SampleRate: Cardinal; // Frequency (samples per second)
    SampleSize: Cardinal; // Bit depth (bits per sample): 8, 16, 32 (24 not supported)
    Channels: Cardinal;   // Number of channels (1-mono, 2-stereo, ...)
    Data: Pointer;        // Buffer data pointer
  end;

  // Opaque structs declaration
  // NOTE: Actual structs are defined internally in raudio module
  PRAudioBuffer = ^TRAudioBuffer;
  TRAudioBuffer = record end;
  PRAudioProcessor = ^TRAudioProcessor;
  TRAudioProcessor = record end;

  // AudioStream, custom audio stream
  PAudioStream = ^TAudioStream;
  TAudioStream = record
    Buffer: PRAudioBuffer;       // Pointer to internal data used by the audio system
    Processor: PRAudioProcessor; // Pointer to internal data processor, useful for audio effects
    SampleRate: Cardinal;        // Frequency (samples per second)
    SampleSize: Cardinal;        // Bit depth (bits per sample): 8, 16, 32 (24 not supported)
    Channels: Cardinal;          // Number of channels (1-mono, 2-stereo, ...)
  end;

  // Sound
  PSound = ^TSound;
  TSound = record
    Stream: TAudioStream; // Audio stream
    FrameCount: Cardinal; // Total number of frames (considering channels)
  end;

  // Music, audio stream, anything longer than ~10 seconds should be streamed
  PMusic = ^TMusic;
  TMusic = record
    Stream: TAudioStream; // Audio stream
    FrameCount: Cardinal; // Total number of frames (considering channels)
    Looping: Boolean;     // Music looping enable
    CtxType: Integer;     // Type of music context (audio filetype)
    CtxData: Pointer;     // Audio context data, depends on type
  end;

  // VrDeviceInfo, Head-Mounted-Display device parameters
  PVrDeviceInfo = ^TVrDeviceInfo;
  TVrDeviceInfo = record
    HResolution: Integer;                        // Horizontal resolution in pixels
    VResolution: Integer;                        // Vertical resolution in pixels
    HScreenSize: Single;                         // Horizontal size in meters
    VScreenSize: Single;                         // Vertical size in meters
    VScreenCenter: Single;                       // Screen center in meters
    EyeToScreenDistance: Single;                 // Distance between eye and display in meters
    LensSeparationDistance: Single;              // Lens separation distance in meters
    InterpupillaryDistance: Single;              // IPD (distance between pupils) in meters
    LensDistortionValues: array [0..3] of Single; // Lens distortion constant parameters
    ChromaAbCorrection: array [0..3] of Single;   // Chromatic aberration correction parameters
  end;

  // VrStereoConfig, VR stereo rendering configuration for simulator
  PVrStereoConfig = ^TVrStereoConfig;
  TVrStereoConfig = record
    Projection: array [0..1] of TMatrix;       // VR projection matrices (per eye)
    ViewOffset: array [0..1] of TMatrix;       // VR view offset matrices (per eye)
    LeftLensCenter: array [0..1] of Single;    // VR left lens center
    RightLensCenter: array [0..1] of Single;   // VR right lens center
    LeftScreenCenter: array [0..1] of Single;  // VR left screen center
    RightScreenCenter: array [0..1] of Single; // VR right screen center
    Scale: array [0..1] of Single;             // VR distortion scale
    ScaleIn: array [0..1] of Single;           // VR distortion scale in
  end;

  // File path list
  PFilePathList = ^TFilePathList;
  TFilePathList = record
    Capacity: Cardinal; // Filepaths max entries
    Count: Cardinal;    // Filepaths entries count
    Paths: ^PAnsiChar;  // Filepaths entries
  end;

// Some Basic Colors
// NOTE: Custom raylib color palette for amazing visuals on WHITE background
const
  LIGHTGRAY:  TColor = (R: 200; G: 200; B: 200; A: 255); // Light Gray
  GRAY:       TColor = (R: 130; G: 130; B: 130; A: 255); // Gray
  DARKGRAY:   TColor = (R: 80;  G: 80;  B: 80;  A: 255); // Dark Gray
  YELLOW:     TColor = (R: 253; G: 249; B: 0;   A: 255); // Yellow
  GOLD:       TColor = (R: 255; G: 203; B: 0;   A: 255); // Gold
  ORANGE:     TColor = (R: 255; G: 161; B: 0;   A: 255); // Orange
  PINK:       TColor = (R: 255; G: 109; B: 194; A: 255); // Pink
  RED:        TColor = (R: 230; G: 41;  B: 55;  A: 255); // Red
  MAROON:     TColor = (R: 190; G: 33;  B: 55;  A: 255); // Maroon
  GREEN:      TColor = (R: 0;   G: 228; B: 48;  A: 255); // Green
  LIME:       TColor = (R: 0;   G: 158; B: 47;  A: 255); // Lime
  DARKGREEN:  TColor = (R: 0;   G: 117; B: 44;  A: 255); // Dark Green
  SKYBLUE:    TColor = (R: 102; G: 191; B: 255; A: 255); // Sky Blue
  BLUE:       TColor = (R: 0;   G: 121; B: 241; A: 255); // Blue
  DARKBLUE:   TColor = (R: 0;   G: 82;  B: 172; A: 255); // Dark Blue
  PURPLE:     TColor = (R: 200; G: 122; B: 255; A: 255); // Purple
  VIOLET:     TColor = (R: 135; G: 60;  B: 190; A: 255); // Violet
  DARKPURPLE: TColor = (R: 112; G: 31;  B: 126; A: 255); // Dark Purple
  BEIGE:      TColor = (R: 211; G: 176; B: 131; A: 255); // Beige
  BROWN:      TColor = (R: 127; G: 106; B: 79;  A: 255); // Brown
  DARKBROWN:  TColor = (R: 76;  G: 63;  B: 47;  A: 255); // Dark beown
  WHITE:      TColor = (R: 255; G: 255; B: 255; A: 255); // White
  BLACK:      TColor = (R: 0;   G: 0;   B: 0;   A: 255); // Black
  BLANK:      TColor = (R: 0;   G: 0;   B: 0;   A: 0);   // Black(Transparent)
  MAGENTA:    TColor = (R: 255; G: 0;   B: 255; A: 255); // Magenta
  RAYWHITE:   TColor = (R: 245; G: 245; B: 245; A: 255); // My own White (raylib logo)

//------------------------------------------------------------------------------------
// Global Variables Definition
//------------------------------------------------------------------------------------
// It's lonely here...

//------------------------------------------------------------------------------------
// Window and Graphics Device Functions (Module: core)
//------------------------------------------------------------------------------------

// Window-related functions

// Initialize window and OpenGL context
procedure InitWindow(Width, Height: Integer; const Title: PAnsiChar);
// Check if KEY_ESCAPE pressed or Close icon pressed
function WindowShouldClose(): Boolean;
// Close window and unload OpenGL context
procedure CloseWindow();
// Check if window has been initialized successfully
function IsWindowReady(): Boolean;
// Check if window is currently fullscreen
function IsWindowFullscreen(): Boolean;
// Check if window is currently hidden (only PLATFORM_DESKTOP)
function IsWindowHidden(): Boolean;
//Check if window is currently minimized (only PLATFORM_DESKTOP)
function IsWindowMinimized(): Boolean;
// Check if window is currently maximized (only PLATFORM_DESKTOP)
function IsWindowMaximized(): Boolean;
// Check if window is currently focused (only PLATFORM_DESKTOP)
function IsWindowFocused(): Boolean;
// Check if window has been resized last frame
function IsWindowResized(): Boolean;
// Check if one specific window flag is enabled
function IsWindowState(Flag: TConfigFlags): Boolean;
// Set window configuration state using flags (only PLATFORM_DESKTOP)
procedure SetWindowState(Flags: TConfigFlags);
// Clear window configuration state flags
procedure ClearWindowState(Flags: TConfigFlags);
// Toggle window state: fullscreen/windowed (only PLATFORM_DESKTOP)
procedure ToggleFullscreen();
// Set window state: maximized, if resizable (only PLATFORM_DESKTOP)
procedure MaximizeWindow();
// Set window state: minimized, if resizable (only PLATFORM_DESKTOP)
procedure MinimizeWindow();
// Set window state: not minimized/maximized (only PLATFORM_DESKTOP)
procedure RestoreWindow();
// Set icon for window (single image, RGBA 32bit, only PLATFORM_DESKTOP)
procedure SetWindowIcon(Image: TImage);
// Set icon for window (multiple images, RGBA 32bit, only PLATFORM_DESKTOP)
procedure SetWindowIcons(Image: PImage; Count: Integer);
// Set title for window (only PLATFORM_DESKTOP)
procedure SetWindowTitle(const Title: PAnsiChar);
// Set window position on screen (only PLATFORM_DESKTOP)
procedure SetWindowPosition(X, Y: Integer);
// Set monitor for the current window (fullscreen mode)
procedure SetWindowMonitor(Monitor: Integer);
// Set window minimum dimensions (for FLAG_WINDOW_RESIZABLE)
procedure SetWindowMinSize(Width, Height: Integer);
// Set window dimensions
procedure SetWindowSize(Width, Height: Integer);
// Set window opacity [0.0f..1.0f] (only PLATFORM_DESKTOP)
procedure SetWindowOpacity(Opacity: Single);
// Get native window handle
function GetWindowHandle(): Pointer;
// Get current screen width
function GetScreenWidth(): Integer;
// Get current screen height
function GetScreenHeight(): Integer;
// Get current render width (it considers HiDPI)
function GetRenderWidth(): Integer;
// Get current render height (it considers HiDPI)
function GetRenderHeight(): Integer;
// Get number of connected monitors
function GetMonitorCount(): Integer;
// Get current connected monitor
function GetCurrentMonitor(): Integer;
// Get specified monitor position
function GetMonitorPosition(Monitor: Integer): TVector2;
// Get specified monitor width (current video mode used by monitor)
function GetMonitorWidth(Monitor: Integer): Integer;
// Get specified monitor height (current video mode used by monitor)
function GetMonitorHeight(Monitor: Integer): Integer;
// Get specified monitor physical width in millimetres
function GetMonitorPhysicalWidth(Monitor: Integer): Integer;
// Get specified monitor physical height in millimetres
function GetMonitorPhysicalHeight(Monitor: Integer): Integer;
// Get specified monitor refresh rate
function GetMonitorRefreshRate(Monitor: Integer): Integer;
// Get window position XY on monitor
function GetWindowPosition(): TVector2;
// Get window scale DPI factor
function GetWindowScaleDPI(): TVector2;
// Get the human-readable, UTF-8 encoded name of the primary monitor
function GetMonitorName(Monitor: Integer): PAnsiChar;
// Set clipboard text content
procedure SetClipboardText(const Text: PAnsiChar);
// Get clipboard text content
function GetClipboardText(): PAnsiChar;
// Enable waiting for events on EndDrawing(), no automatic event polling
procedure EnableEventWaiting();
// Disable waiting for events on EndDrawing(), automatic events polling
procedure DisableEventWaiting();

// Custom frame control functions
// NOTE: Those functions are intended for advance users that want full control over the frame processing
// By default EndDrawing() does this job: draws everything + SwapScreenBuffer() + manage frame timing + PollInputEvents()
// To avoid that behaviour and control frame processes manually, enable in config.h: SUPPORT_CUSTOM_FRAME_CONTROL

// Swap back buffer with front buffer (screen drawing)
procedure SwapScreenBuffer();
// Register all input events
procedure PollInputEvents();
// Wait for some time (halt program execution)
procedure WaitTime(Seconds: Double);

// Cursor-related functions

// Shows cursor
procedure ShowCursor();
// Hides cursor
procedure HideCursor();
// Check if cursor is not visible
function IsCursorHidden(): Boolean;
// Enables cursor (unlock cursor)
procedure EnableCursor();
// Disables cursor (lock cursor)
procedure DisableCursor();
// Check if cursor is on the current screen.
function IsCursorOnScreen(): Boolean;

// Drawing-related functions

// Set background color (framebuffer clear color)
procedure ClearBackground(Color: TColor);
// Setup canvas (framebuffer) to start drawing
procedure BeginDrawing();
// End canvas drawing and swap buffers (double buffering)
procedure EndDrawing();
// Initialize 2D mode with custom camera (2D)
{qqq}procedure BeginMode2D(Camera: TCamera2D);
// Ends 2D mode with custom camera
procedure EndMode2D();
// Initializes 3D mode with custom camera (3D)
{qqq}procedure BeginMode3D(Camera: TCamera3D);
// Ends 3D mode and returns to default 2D orthographic mode
procedure EndMode3D();
// Initializes render texture for drawing
{qqq}procedure BeginTextureMode(Target: TRenderTexture2D);
// Ends drawing to render texture
procedure EndTextureMode();
// Begin custom shader drawing
procedure BeginShaderMode(Shader: TShader);
// End custom shader drawing (use default shader)
procedure EndShaderMode();
// Begin blending mode (alpha, additive, multiplied)
procedure BeginBlendMode(Mode: TBlendMode);
// End blending mode (reset to default: alpha blending)
procedure EndBlendMode();
// Begin scissor mode (define screen area for following drawing)
procedure BeginScissorMode(X, Y, Width, Height: Integer);
// End scissor mode
procedure EndScissorMode();
// Begin stereo rendering (requires VR simulator)
{qqq}procedure BeginVrStereoMode(Config: TVrStereoConfig);
// End stereo rendering (requires VR simulator)
procedure EndVrStereoMode();

// VR stereo config functions for VR simulator

// Load VR stereo config for VR simulator device parameters
function LoadVrStereoConfig(Device: TVrDeviceInfo): TVrStereoConfig;
// Unload VR stereo config
procedure UnloadVrStereoConfig(Config: TVrStereoConfig);

// Shader management functions
// NOTE: Shader functionality is not available on OpenGL 1.1

// Load shader from files and bind default locations
function LoadShader(const VsFileName, FsFileName: PAnsiChar): TShader;
// Load shader from code strings and bind default locations
function LoadShaderFromMemory(const VsCode, FsCode: PAnsiChar): TShader;
// Check if a shader is ready
function IsShaderReady(Shader: TShader): Boolean;
// Get shader uniform location
function GetShaderLocation(Shader: TShader; const UniformName: PAnsiChar): Integer;
// Get shader attribute location
function GetShaderLocationAttrib(Shader: TShader; const AttribName: PAnsiChar): Integer;
// Set shader uniform value
procedure SetShaderValue(Shader: TShader; LocIndex: Integer; const Value: Pointer; UniformType: TShaderUniformDataType);
// Set shader uniform value vector
procedure SetShaderValueV(Shader: TShader; LocIndex: Integer; const Value: Pointer; UniformType: TShaderUniformDataType; Count: Integer);
// Set shader uniform value (matrix 4x4)
procedure SetShaderValueMatrix(Shader: TShader; LocIndex: Integer; Mat: TMatrix);
// Set shader uniform value for texture (sampler2d)
procedure SetShaderValueTexture(Shader: TShader; LocIndex: Integer; Texture: TTexture2D);
// Unload shader from GPU memory (VRAM)
procedure UnloadShader(Shader: TShader);

// Screen-space-related functions

// Get a ray trace from mouse position
function GetMouseRay(MousePosition: TVector2; Camera: TCamera): TRay;
// Get camera transform matrix (view matrix)
function GetCameraMatrix(Camera: TCamera): TMatrix;
// Get camera 2d transform matrix
function GetCameraMatrix2D(Camera: TCamera2D): TMatrix;
// Get the screen space position for a 3d world space position
function GetWorldToScreen(Position: TVector3; Camera: TCamera): TVector2;
// Get the world space position for a 2d camera screen space position
function GetScreenToWorld2D(Position: TVector2; Camera: TCamera2D): TVector2;
// Get size position for a 3d world space position
function GetWorldToScreenEx(Position: TVector3; Camera: TCamera; Width, Height: Integer): TVector2;
// Get the screen space position for a 2d camera world space position
function GetWorldToScreen2D(Position: TVector2; Camera: TCamera2D): TVector2;

// Timing-related functions

// Set target FPS (maximum)
procedure SetTargetFPS(Fps: Integer);
// Returns current FPS
function GetFPS(): Integer;
// Returns time in seconds for last frame drawn (delta time)
function GetFrameTime(): Single;
// Returns elapsed time in seconds since InitWindow()
function GetTime(): Double;

// Misc. functions

// Get a random value between min and max (both included)
function GetRandomValue(Min, Max: Integer): Integer;
// Set the seed for the random number generator
procedure SetRandomSeed(Seed: Cardinal);
// Takes a screenshot of current screen (filename extension defines format)
procedure TakeScreenshot(const FileName: PAnsiChar);
// Setup init configuration flags (view FLAGS)
procedure SetConfigFlags(Flags: TConfigFlags);

// Show trace log messages (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR...)
procedure TraceLog(LogLevel: TTraceLogLevel; const Text: PAnsiChar); cdecl varargs;
// Set the current threshold (minimum) log level
procedure SetTraceLogLevel(LogLevel: TTraceLogLevel);
// Internal memory allocator
function MemAlloc(Size: Cardinal): Pointer;
// Internal memory reallocator
function MemRealloc(Ptr: Pointer; Size: Cardinal): Pointer;
// Internal memory free
procedure MemFree(Ptr: Pointer);

// Open URL with default system browser (if available)
procedure OpenURL(const Url: PAnsiChar);

// Set custom callbacks
// WARNING: Callbacks setup is intended for advance users

// Set custom trace log
procedure SetTraceLogCallback(Callback: TTraceLogCallback);
// Set custom file binary data loader
procedure SetLoadFileDataCallback(Callback: TLoadFileDataCallback);
// Set custom file binary data saver
procedure SetSaveFileDataCallback(Callback: TSaveFileDataCallback);
// Set custom file text data loader
procedure SetLoadFileTextCallback(Callback: TLoadFileTextCallback);
// Set custom file text data saver
procedure SetSaveFileTextCallback(Callback: TSaveFileTextCallback);

// Files management functions

// Load file data as byte array (read)
function LoadFileData(const FileName: PAnsiChar; BytesRead: PCardinal): PByte;
//- function LoadFileData(const FileName: PAnsiChar; out BytesRead: Cardinal): PByte;
// Unload file data allocated by LoadFileData()
procedure UnloadFileData(Data: PByte);
// Save data to file from byte array (write), returns true on success
function SaveFileData(const FileName: PAnsiChar; Data: Pointer; BytesToWrite: Cardinal): Boolean;
// Export data to code (.h), returns true on success
function ExportDataAsCode(const Data: PAnsiChar; Size: Cardinal; const FileName: PAnsiChar): Boolean;
// Load text data from file (read), returns a '\0' terminated string
function LoadFileText(const FileName: PAnsiChar): PAnsiChar;
// Unload file text data allocated by LoadFileText()
procedure UnloadFileText(Text: PAnsiChar);
// Save text data to file (write), string must be '\0' terminated, returns true on success
function SaveFileText(const FileName: PAnsiChar; Text: PAnsiChar): Boolean;
// Check if file exists
function FileExists(const FileName: PAnsiChar): Boolean;
// Check if a directory path exists
function DirectoryExists(const DirPath: PAnsiChar): Boolean;
// Check file extension (including point: .png, .wav)
function IsFileExtension(const FileName, Ext: PAnsiChar): Boolean;
// Get file length in bytes (NOTE: GetFileSize() conflicts with windows.h)
function GetFileLength(const FileName: PAnsiChar): Integer;
// Get pointer to extension for a filename string (includes dot: '.png')
function GetFileExtension(const FileName: PAnsiChar): PAnsiChar;
// Get pointer to filename for a path string
function GetFileName(const FilePath: PAnsiChar): PAnsiChar;
// Get filename string without extension (uses static string)
function GetFileNameWithoutExt(const FilePath: PAnsiChar): PAnsiChar;
// Get full path for a given fileName with path (uses static string)
function GetDirectoryPath(const FilePath: PAnsiChar): PAnsiChar;
// Get previous directory path for a given path (uses static string)
function GetPrevDirectoryPath(const DirPath: PAnsiChar): PAnsiChar;
// Get current working directory (uses static string)
function GetWorkingDirectory(): PAnsiChar;
// Get the directory if the running application (uses static string)
function GetApplicationDirectory(): PAnsiChar;
// Change working directory, return true on success
function ChangeDirectory(const Dir: PAnsiChar): Boolean;
// Check if a given path is a file or a directory
function IsPathFile(const Path: PAnsiChar): Boolean;
// Load directory filepaths
function LoadDirectoryFiles(const DirPath: PAnsiChar): TFilePathList;
// Load directory filepaths with extension filtering and recursive directory scan
function LoadDirectoryFilesEx(const BasePath, Filter: PAnsiChar; ScanSubdirs: Boolean): TFilePathList;
// Unload filepaths
procedure UnloadDirectoryFiles(Files: TFilePathList);
// Check if a file has been dropped into window
function IsFileDropped(): Boolean;
// Load dropped filepaths
function LoadDroppedFiles(): TFilePathList;
// Unload dropped filepaths
procedure UnloadDroppedFiles(Files: TFilePathList);
// Get file modification time (last write time)
function GetFileModTime(const FileName: PAnsiChar): LongInt;

// Compression/Encoding functionality

// Compress data (DEFLATE algorithm), memory must be MemFree()
function CompressData(const Data: PByte; DataSize: Integer; CompDataSize: PInteger): PByte;
//- function CompressData(const Data: PByte; DataSize: Integer; out CompDataSize: Integer): PByte;
// Decompress data (DEFLATE algorithm), memory must be MemFree()
function DecompressData(const CompData: PByte; CompDataSize: Integer; DataSize: PInteger): PByte;
//- function DecompressData(const CompData: PByte; CompDataSize: Integer; out DataSize: Integer): PByte;
// Encode data to Base64 string, memory must be MemFree()
function EncodeDataBase64(const Data: PByte; DataSize: Integer; OutputSize: PInteger): PAnsiChar;
//- function EncodeDataBase64(const Data: PByte; DataSize: Integer; out OutputSize: Integer): PAnsiChar;
// Decode Base64 string data, memory must be MemFree()
function DecodeDataBase64(const Data: PAnsiChar; OutputSize: PInteger): PByte;
//- function DecodeDataBase64(const Data: PAnsiChar; out OutputSize: Integer): PByte;

//------------------------------------------------------------------------------------
// Input Handling Functions (Module: core)
//------------------------------------------------------------------------------------

// Input-related functions: keyboard

// Check if a key has been pressed once
function IsKeyPressed(Key: TKeyboardKey): Boolean;
// Check if a key is being pressed
function IsKeyDown(Key: TKeyboardKey): Boolean;
// Check if a key has been released once
function IsKeyReleased(Key: TKeyboardKey): Boolean;
// Check if a key is NOT being pressed
function IsKeyUp(Key: TKeyboardKey): Boolean;
// Set a custom key to exit program (default is ESC)
procedure SetExitKey(Key: TKeyboardKey);
// Get key pressed (keycode), call it multiple times for keys queued, returns 0 when the queue is empty
function GetKeyPressed(): TKeyboardKey;
// Get char pressed (unicode), call it multiple times for chars queued, returns 0 when the queue is empty
function GetCharPressed(): Integer;

// Input-related functions: gamepads

// Check if a gamepad is available
function IsGamepadAvailable(Gamepad: Integer): Boolean;
// Get gamepad internal name id
function GetGamepadName(Gamepad: Integer): PAnsiChar;
// Check if a gamepad button has been pressed once
function IsGamepadButtonPressed(Gamepad: Integer; Button: TGamepadButton): Boolean;
// Check if a gamepad button is being pressed
function IsGamepadButtonDown(Gamepad: Integer; Button: TGamepadButton): Boolean;
// Check if a gamepad button has been released once
function IsGamepadButtonReleased(Gamepad: Integer; Button: TGamepadButton): Boolean;
// Check if a gamepad button is NOT being pressed
function IsGamepadButtonUp(Gamepad: Integer; Button: TGamepadButton): Boolean;
// Get the last gamepad button pressed
function GetGamepadButtonPressed(): TGamepadButton;
// Get gamepad axis count for a gamepad
function GetGamepadAxisCount(Gamepad: Integer): Integer;
// Get axis movement value for a gamepad axis
function GetGamepadAxisMovement(Gamepad: Integer; Axis: TGamepadAxis): Single;
// Set internal gamepad mappings (SDL_GameControllerDB)
function SetGamepadMappings(const Mappings: PAnsiChar): Integer;

// Input-related functions: mouse

// Check if a mouse button has been pressed once
function IsMouseButtonPressed(Button: TMouseButton): Boolean;
// Check if a mouse button is being pressed
function IsMouseButtonDown(Button: TMouseButton): Boolean;
// Check if a mouse button has been released once
function IsMouseButtonReleased(Button: TMouseButton): Boolean;
// Check if a mouse button is NOT being pressed
function IsMouseButtonUp(Button: TMouseButton): Boolean;
// Get mouse position X
function GetMouseX(): Integer;
// Get mouse position Y
function GetMouseY(): Integer;
// Get mouse position XY
function GetMousePosition(): TVector2;
// Get mouse delta between frames
function GetMouseDelta(): TVector2;
// Set mouse position XY
procedure SetMousePosition(X, Y: Integer);
// Set mouse offset
procedure SetMouseOffset(OffsetX, OffsetY: Integer);
// Set mouse scaling
procedure SetMouseScale(ScaleX, ScaleY: Single);
// Get mouse wheel movement for X or Y, whichever is larger
function GetMouseWheelMove(): Single;
// Get mouse wheel movement for both X and Y
function GetMouseWheelMoveV(): TVector2;
// Set mouse cursor
procedure SetMouseCursor(Cursor: TMouseCursor);

// Input-related functions: touch

// Get touch position X for touch point 0 (relative to screen size)
function GetTouchX(): Integer;
// Get touch position Y for touch point 0 (relative to screen size)
function GetTouchY(): Integer;
// Get touch position XY for a touch point index (relative to screen size)
function GetTouchPosition(Index: Integer): TVector2;
// Get touch point identifier for given index
function GetTouchPointId(Index: Integer): Integer;
// Get touch points count
function GetTouchPointCount(): Integer;

//------------------------------------------------------------------------------------
// Gestures and Touch Handling Functions (Module: rgestures)
//------------------------------------------------------------------------------------

// Enable a set of gestures using flags
procedure SetGesturesEnabled(Flags: TGesture);
// Check if a gesture have been detected
function IsGestureDetected(Gesture: TGesture): Boolean;
// Get latest detected gesture
function GetGestureDetected(): TGesture;
// Get gesture hold time in milliseconds
function GetGestureHoldDuration(): Single;
// Get gesture drag vector
function GetGestureDragVector(): TVector2;
// Get gesture drag angle
function GetGestureDragAngle(): Single;
// Get gesture pinch delta
function GetGesturePinchVector(): TVector2;
// Get gesture pinch angle
function GetGesturePinchAngle(): Single;

//------------------------------------------------------------------------------------
// Camera System Functions (Module: rcamera)
//------------------------------------------------------------------------------------

// Update camera position for selected mode
procedure UpdateCamera(Camera: PCamera; Mode: TCameraMode);
// Update camera movement/rotation
procedure UpdateCameraPro(Camera: PCamera; Movement, Rotation, Zoom: TVector3);

function GetCameraForward(Camera: PCamera): TVector3;
function GetCameraUp(Camera: PCamera): TVector3;
function GetCameraRight(Camera: PCamera): TVector3;
// Camera movement
procedure CameraMoveForward(Camera: PCamera; Distance: Single; MoveInWorldPlane: Boolean);
procedure CameraMoveUp(Camera: PCamera; Distance: Single);
procedure CameraMoveRight(Camera: PCamera; Distance: Single; MoveInWorldPlane: Boolean);
procedure CameraMoveToTarget(Camera: PCamera; Delta: Single);
// Camera rotation
procedure CameraYaw(Camera: PCamera; Angle: Single; RotateAroundTarget: Boolean);
procedure CameraPitch(Camera: PCamera; Angle: Single; LockView: Boolean; RotateAroundTarget, RotateUp: Boolean);
procedure CameraRoll(Camera: PCamera; Angle: Single);
function GetCameraViewMatrix(Camera: PCamera): TMatrix;
function GetCameraProjectionMatrix(Camera: PCamera; Aspect: Single): TMatrix;

//------------------------------------------------------------------------------------
// Basic Shapes Drawing Functions (Module: shapes)
//------------------------------------------------------------------------------------
// Set texture and rectangle to be used on shapes drawing
// NOTE: It can be useful when using basic shapes and one single font,
// defining a font char white rectangle would allow drawing everything in a single draw call

// Set texture and rectangle to be used on shapes drawing
procedure SetShapesTexture(Texture: TTexture2D; Source: TRectangle);

// Basic shapes drawing functions

// Draw a pixel
procedure DrawPixel(PosX, PosY: Integer; Color: TColor);
// Draw a pixel (Vector version)
procedure DrawPixelV(Position: TVector2; Color: TColor);
// Draw a line
procedure DrawLine(StartPosX, StartPosY, EndPosX, EndPosY: Integer; Color: TColor);
// Draw a line (Vector version)
procedure DrawLineV(StartPos, EndPos: TVector2; Color: TColor);
// Draw a line defining thickness
procedure DrawLineEx(StartPos, EndPos: TVector2; Thick: Single; Color: TColor);
// Draw a line using cubic-bezier curves in-out
procedure DrawLineBezier(StartPos, EndPos: TVector2; Thick: Single; Color: TColor);
// Draw line using quadratic bezier curves with a control point
procedure DrawLineBezierQuad(StartPos, EndPos, ControlPos: TVector2; Thick: Single; Color: TColor);
// Draw line using cubic bezier curves with 2 control points
procedure DrawLineBezierCubic(StartPos, EndPos, StartControlPos, EndControlPos: TVector2; Thick: Single; Color: TColor);
// Draw lines sequence
procedure DrawLineStrip(Points: PVector2; PointCount: Integer; Color: TColor);
// Draw a color-filled circle
procedure DrawCircle(CenterX, CenterY: Integer; Radius: Single; Color: TColor);
// Draw a piece of a circle
procedure DrawCircleSector(Center: TVector2; Radius, StartAngle, EndAngle: Single; Segments: Integer; Color: TColor);
// Draw circle sector outline
procedure DrawCircleSectorLines(Center: TVector2; Radius, StartAngle, EndAngle: Single; Segments: Integer; Color: TColor);
// Draw a gradient-filled circle
procedure DrawCircleGradient(CenterX, CenterY: Integer; Radius: Single; Color1, Color2: TColor);
// Draw a color-filled circle (Vector version)
procedure DrawCircleV(Center: TVector2; Radius: Single; Color: TColor);
// Draw circle outline
procedure DrawCircleLines(CenterX, CenterY: Integer; Radius: Single; Color: TColor);
// Draw ellipse
procedure DrawEllipse(CenterX, CenterY: Integer; RadiusH, RadiusV: Single; Color: TColor);
// Draw ellipse outline
procedure DrawEllipseLines(CenterX, CenterY: Integer; RadiusH, RadiusV: Single; Color: TColor);
// Draw ring
procedure DrawRing(Center: TVector2; InnerRadius, OuterRadius, StartAngle, EndAngle: Single; Segments: Integer; Color: TColor);
// Draw ring outline
procedure DrawRingLines(Center: TVector2; InnerRadius, OuterRadius, StartAngle, EndAngle: Single; Segments: Integer; Color: TColor);
// Draw a color-filled rectangle
procedure DrawRectangle(PosX, PosY, Width, Height: Integer; Color: TColor);
// Draw a color-filled rectangle (Vector version)
procedure DrawRectangleV(Position, Size: TVector2; Color: TColor);
// Draw a color-filled rectangle
procedure DrawRectangleRec(Rec: TRectangle; Color: TColor);
// Draw a color-filled rectangle with pro parameters
procedure DrawRectanglePro(Rec: TRectangle; Origin: TVector2; Rotation: Single; Color: TColor);
// Draw a vertical-gradient-filled rectangle
procedure DrawRectangleGradientV(PosX, PosY, Width, Height: Integer; Color1, Color2: TColor);
// Draw a horizontal-gradient-filled rectangle
procedure DrawRectangleGradientH(PosX, PosY, Width, Height: Integer; Color1, Color2: TColor);
// Draw a gradient-filled rectangle with custom vertex colors
procedure DrawRectangleGradientEx(Rec: TRectangle; Col1, Col2, Col3, Col4: TColor);
// Draw rectangle outline
procedure DrawRectangleLines(PosX, PosY, Width, Height: Integer; Color: TColor);
// Draw rectangle outline with extended parameters
procedure DrawRectangleLinesEx(Rec: TRectangle; LineThick: Single; Color: TColor);
// Draw rectangle with rounded edges
procedure DrawRectangleRounded(Rec: TRectangle; Roundness: Single; Segments: Integer; Color: TColor);
// Draw rectangle with rounded edges outline
procedure DrawRectangleRoundedLines(Rec: TRectangle; Roundness: Single; Segments: Integer; LineThick: Single; Color: TColor);
// Draw a color-filled triangle (vertex in counter-clockwise order!)
procedure DrawTriangle(V1, V2, V3: TVector2; Color: TColor);
// Draw triangle outline (vertex in counter-clockwise order!)
procedure DrawTriangleLines(V1, V2, V3: TVector2; Color: TColor);
// Draw a triangle fan defined by points (first vertex is the center)
procedure DrawTriangleFan(Points: PVector2; PointCount: Integer; Color: TColor);
// Draw a triangle strip defined by points
procedure DrawTriangleStrip(Points: PVector2; PointCount: Integer; Color: TColor);
// Draw a regular polygon (Vector version)
procedure DrawPoly(Center: TVector2; Sides: Integer; Radius: Single; Rotation: Single; Color: TColor);
// Draw a polygon outline of n sides
procedure DrawPolyLines(Center: TVector2; Sides: Integer; Radius, Rotation: Single; Color: TColor);
// Draw a polygon outline of n sides with extended parameters
procedure DrawPolyLinesEx(Center: TVector2; Sides: Integer; Radius, Rotation, LineThick: Single; Color: TColor);

// Basic shapes collision detection functions

// Check collision between two rectangles
function CheckCollisionRecs(Rec1, Rec2: TRectangle): Boolean;
// Check collision between two circles
function CheckCollisionCircles(Center1: TVector2; Radius1: Single; Center2: TVector2; Radius2: Single): Boolean;
// Check collision between circle and rectangle
function CheckCollisionCircleRec(Center: TVector2; Radius: Single; Rec: TRectangle): Boolean;
// Check if point is inside rectangle
function CheckCollisionPointRec(Point: TVector2; Rec: TRectangle): Boolean;
// Check if point is inside circle
function CheckCollisionPointCircle(Point, Center: TVector2; Radius: Single): Boolean;
// Check if point is inside a triangle
function CheckCollisionPointTriangle(Point, P1, P2, P3: TVector2): Boolean;
// Check if point is within a polygon described by array of vertices
function CheckCollisionPointPoly(Point: TVector2; Points: PVector2; PointCount: Integer): Boolean;
// Check the collision between two lines defined by two points each, returns collision point by reference
function CheckCollisionLines(StartPos1, EndPos1, StartPos2, EndPos2: TVector2; CollisionPoint: PVector2): Boolean;
// Check if point belongs to line created between two points [p1] and [p2] with defined margin in pixels [threshold]
function CheckCollisionPointLine(Point, P1, P2: TVector2; Threshold: Integer): Boolean;
// Get collision rectangle for two rectangles collision
function GetCollisionRec(Rec1, Rec2: TRectangle): TRectangle;

//------------------------------------------------------------------------------------
// Texture Loading and Drawing Functions (Module: textures)
//------------------------------------------------------------------------------------

// Image loading functions
// NOTE: These functions do not require GPU access

// Load image from file into CPU memory (RAM)
function LoadImage(const FileName: PAnsiChar): TImage;
// Load image from RAW file data
function LoadImageRaw(const FileName: PAnsiChar; Width, Height: Integer; Format: TPixelFormat; HeaderSize: Integer): TImage;
// Load image sequence from file (frames appended to image.data)
function LoadImageAnim(const FileName: PAnsiChar; Frames: PInteger): TImage;
//- function LoadImageAnim(const FileName: PAnsiChar; out Frames: Integer): TImage;
// Load image from memory buffer, fileType refers to extension: i.e. '.png'
function LoadImageFromMemory(const FileType: PAnsiChar; const FileData: PByte; DataSize: Integer): TImage;
// Load image from GPU texture data
function LoadImageFromTexture(Texture: TTexture2D): TImage;
// Load image from screen buffer and (screenshot)
function LoadImageFromScreen(): TImage;
// Check if an image is ready
function IsImageReady(Image: TImage): Boolean;
// Unload image from CPU memory (RAM)
procedure UnloadImage(Image: TImage);
// Export image data to file, returns true on success
function ExportImage(Image: TImage; const FileName: PAnsiChar): Boolean;
// Export image as code file defining an array of bytes, returns true on success
function ExportImageAsCode(Image: TImage; const FileName: PAnsiChar): Boolean;

// Image generation functions

// Generate image: plain color
function GenImageColor(Width, Height: Integer; Color: TColor): TImage;
// Generate image: vertical gradient
function GenImageGradientV(Width, Height: Integer; Top, Bottom: TColor): TImage;
// Generate image: horizontal gradient
function GenImageGradientH(Width, Height: Integer; Left, Right: TColor): TImage;
// Generate image: radial gradient
function GenImageGradientRadial(Width, Height: Integer; Density: Single; Inner, Outer: TColor): TImage;
// Generate image: checked
function GenImageChecked(Width, Height, ChecksX, ChecksY: Integer; Col1, Col2: TColor): TImage;
// Generate image: white noise
function GenImageWhiteNoise(Width, Height: Integer; Factor: Single): TImage;
// Generate image: perlin noise
function GenImagePerlinNoise(Width, Height, OffsetX, OffsetY: Integer; Scale: Single): TImage;
// Generate image: cellular algorithm, bigger tileSize means bigger cells
function GenImageCellular(Width, Height, TileSize: Integer): TImage;
// Generate image: grayscale image from text data
function GenImageText(Width, Height: Integer; const Text: PAnsiChar): TImage;

// Image manipulation functions

// Create an image duplicate (useful for transformations)
function ImageCopy(Image: TImage): TImage;
// Create an image from another image piece
function ImageFromImage(Image: TImage; Rec: TRectangle): TImage;
// Create an image from text (default font)
function ImageText(const Text: PAnsiChar; FontSize: Integer; Color: TColor): TImage;
// Create an image from text (custom sprite font)
function ImageTextEx(Font: TFont; const Text: PAnsiChar; FontSize, Spacing: Single; Tint: TColor): TImage;
// Convert image data to desired format
procedure ImageFormat(Image: PImage; NewFormat: TPixelFormat);
//- procedure ImageFormat(var Image: TImage; NewFormat: TPixelFormat);
// Convert image to POT (power-of-two)
procedure ImageToPOT(Image: PImage; Fill: TColor);
//- procedure ImageToPOT(var Image: TImage; Fill: TColor);
// Crop an image to a defined rectangle
procedure ImageCrop(Image: PImage; Crop: TRectangle);
//- procedure ImageCrop(var Image: TImage; Crop: TRectangle);
// Crop image depending on alpha value
procedure ImageAlphaCrop(Image: PImage; Threshold: Single);
//- procedure ImageAlphaCrop(var Image: TImage; Threshold: Single);
// Clear alpha channel to desired color
procedure ImageAlphaClear(Image: PImage; Color: TColor; Threshold: Single);
//- procedure ImageAlphaClear(var Image: TImage; Color: TColor; Threshold: Single);
// Apply alpha mask to image
procedure ImageAlphaMask(Image: PImage; AlphaMask: TImage);
//- procedure ImageAlphaMask(var Image: TImage; AlphaMask: TImage);
// Premultiply alpha channel
procedure ImageAlphaPremultiply(Image: PImage);
//- procedure ImageAlphaPremultiply(var Image: TImage);
// Apply Gaussian blur using a box blur approximation
procedure ImageBlurGaussian(Image: PImage; BlurSize: Integer);
//- procedure ImageBlurGaussian(var Image: TImage; BlurSize: Integer);
// Resize image (Bicubic scaling algorithm)
procedure ImageResize(Image: PImage; NewWidth, NewHeight: Integer);
//- procedure ImageResize(var Image: TImage; NewWidth, NewHeight: Integer);
// Resize image (Nearest-Neighbor scaling algorithm)
procedure ImageResizeNN(Image: PImage; NewWidth, NewHeight: Integer);
//- procedure ImageResizeNN(var Image: TImage; NewWidth, NewHeight: Integer);
// Resize canvas and fill with color
procedure ImageResizeCanvas(Image: PImage; NewWidth, NewHeight, OffsetX, OffsetY: Integer; Fill: TColor);
//- procedure ImageResizeCanvas(var Image: TImage; NewWidth, NewHeight, OffsetX, OffsetY: Integer; Fill: TColor);
// Compute all mipmap levels for a provided image
procedure ImageMipmaps(Image: PImage);
//- procedure ImageMipmaps(var Image: TImage);
// Dither image data to 16bpp or lower (Floyd-Steinberg dithering)
procedure ImageDither(Image: PImage; RBpp, GBpp, BBpp, ABpp: Integer);
//- procedure ImageDither(var Image: TImage; RBpp, GBpp, BBpp, ABpp: Integer);
// Flip image vertically
procedure ImageFlipVertical(Image: PImage);
//- procedure ImageFlipVertical(var Image: TImage);
// Flip image horizontally
procedure ImageFlipHorizontal(Image: PImage);
//- procedure ImageFlipHorizontal(var Image: TImage);
// Rotate image clockwise 90deg
procedure ImageRotateCW(Image: PImage);
//- procedure ImageRotateCW(var Image: TImage);
// Rotate image counter-clockwise 90deg
procedure ImageRotateCCW(Image: PImage);
//- procedure ImageRotateCCW(var Image: TImage);
//Modify image color: tint
procedure ImageColorTint(Image: PImage; Color: TColor);
//- procedure ImageColorTint(var Image: TImage; Color: TColor);
// Modify image color: invert
procedure ImageColorInvert(Image: PImage);
//- procedure ImageColorInvert(var Image: TImage);
// Modify image color: grayscale
procedure ImageColorGrayscale(Image: PImage);
//- procedure ImageColorGrayscale(var Image: TImage);
// Modify image color: contrast (-100 to 100)
procedure ImageColorContrast(Image: PImage; Contrast: Single);
//- procedure ImageColorContrast(var Image: TImage; Contrast: Single);
// Modify image color: brightness (-255 to 255)
procedure ImageColorBrightness(Image: PImage; Brightness: Integer);
//- procedure ImageColorBrightness(var Image: TImage; Brightness: Integer);
// Modify image color: replace color
procedure ImageColorReplace(Image: PImage; Color, Replace: TColor);
//- procedure ImageColorReplace(var Image: TImage; Color, Replace: TColor);
// Load color data from image as a Color array (RGBA - 32bit)
function LoadImageColors(Image: TImage): PColor;
// Load colors palette from image as a Color array (RGBA - 32bit)
function LoadImagePalette(Image: TImage; MaxPaletteSize: Integer; ColorCount: PInteger): PColor;
//- function LoadImagePalette(Image: TImage; MaxPaletteSize: Integer; out ColorCount: Integer): PColor;
// Unload color data loaded with LoadImageColors()
procedure UnloadImageColors(Colors: PColor);
// Unload colors palette loaded with LoadImagePalette()
procedure UnloadImagePalette(Colors: PColor);
// Get image alpha border rectangle
function GetImageAlphaBorder(Image: TImage; Threshold: Single): TRectangle;
// Get image pixel color at (x, y) position
function GetImageColor(Image: TImage; X, Y: Integer): TColor;

// Image drawing functions
// NOTE: Image software-rendering functions (CPU)

// Clear image background with given color
procedure ImageClearBackground(Dst: PImage; Color: TColor);
//- procedure ImageClearBackground(var Dst: TImage; Color: TColor);
// Draw pixel within an image
procedure ImageDrawPixel(Dst: PImage; PosX, PosY: Integer; Color: TColor);
//- procedure ImageDrawPixel(var Dst: TImage; PosX, PosY: Integer; Color: TColor);
// Draw pixel within an image (Vector version)
procedure ImageDrawPixelV(Dst: PImage; Position: TVector2; Color: TColor);
//- procedure ImageDrawPixelV(var Dst: TImage; Position: TVector2; Color: TColor);
// Draw line within an image
procedure ImageDrawLine(Dst: PImage; StartPosX, StartPosY, EndPosX, EndPosY: Integer; Color: TColor);
//- procedure ImageDrawLine(var Dst: TImage; StartPosX, StartPosY, EndPosX, EndPosY: Integer; Color: TColor);
// Draw line within an image (Vector version)
procedure ImageDrawLineV(Dst: PImage; Start, End_: TVector2; Color: TColor);
//- procedure ImageDrawLineV(var Dst: TImage; Start, End_: TVector2; Color: TColor);
// Draw a filled circle within an image
procedure ImageDrawCircle(Dst: PImage; CenterX, CenterY, Radius: Integer; Color: TColor);
//- procedure ImageDrawCircle(var Dst: TImage; CenterX, CenterY, Radius: Integer; Color: TColor);
// Draw a filled circle within an image (Vector version)
procedure ImageDrawCircleV(Dst: PImage; Center: TVector2; Radius: Integer; Color: TColor);
//- procedure ImageDrawCircleV(var Dst: TImage; Center: TVector2; Radius: Integer; Color: TColor);
// Draw circle outline within an image
procedure ImageDrawCircleLines(Dst: PImage; CenterX, CenterY, Radius: Integer; Color: TColor);
//- procedure ImageDrawCircleLines(var Dst: TImage; CenterX, CenterY, Radius: Integer; Color: TColor);
// Draw circle outline within an image (Vector version)
procedure ImageDrawCircleLinesV(Dst: PImage; Center: TVector2; Radius: Integer; Color: TColor);
//- procedure ImageDrawCircleLinesV(var Dst: TImage; Center: TVector2; Radius: Integer; Color: TColor);
// Draw rectangle within an image
procedure ImageDrawRectangle(Dst: PImage; PosX, PosY, Width, Height: Integer; Color: TColor);
//- procedure ImageDrawRectangle(var Dst: TImage; PosX, PosY, Width, Height: Integer; Color: TColor);
// Draw rectangle within an image (Vector version)
procedure ImageDrawRectangleV(Dst: PImage; Position, Size: TVector2; Color: TColor);
//- procedure ImageDrawRectangleV(var Dst: TImage; Position, Size: TVector2; Color: TColor);
// Draw rectangle within an image
procedure ImageDrawRectangleRec(Dst: PImage; Rec: TRectangle; Color: TColor);
//- procedure ImageDrawRectangleRec(var Dst: TImage; Rec: TRectangle; Color: TColor);
// Draw rectangle lines within an image
procedure ImageDrawRectangleLines(Dst: PImage; Rec: TRectangle; Thick: Integer; Color: TColor);
//- procedure ImageDrawRectangleLines(var Dst: TImage; Rec: TRectangle; Thick: Integer; Color: TColor);
// Draw a source image within a destination image (tint applied to source)
procedure ImageDraw(Dst: PImage; Src: TImage; SrcRec, DstRec: TRectangle; Tint: TColor);
//- procedure ImageDraw(var Dst: TImage; Src: TImage; SrcRec, DstRec: TRectangle; Tint: TColor);
// Draw text (using default font) within an image (destination)
procedure ImageDrawText(Dst: PImage; const Text: PAnsiChar; PosX, PosY, FontSize: Integer; Color: TColor);
//- procedure ImageDrawText(var Dst: TImage; const Text: PAnsiChar; PosX, PosY, FontSize: Integer; Color: TColor);
// Draw text (custom sprite font) within an image (destination)
procedure ImageDrawTextEx(Dst: PImage; Font: TFont; const Text: PAnsiChar; Position: TVector2; FontSize, Spacing: Single; Tint: TColor);
//- procedure ImageDrawTextEx(var Dst: TImage; Font: TFont; const Text: PAnsiChar; Position: TVector2; FontSize, Spacing: Single; Tint: TColor);

// Texture loading functions
// NOTE: These functions require GPU access

// Load texture from file into GPU memory (VRAM)
function LoadTexture(const FileName: PAnsiChar): TTexture2D;
// Load texture from image data
function LoadTextureFromImage(Image: TImage): TTexture2D;
// Load cubemap from image, multiple image cubemap layouts supported
function LoadTextureCubemap(Image: TImage; Layout: TCubemapLayout): TTextureCubemap;
// Load texture for rendering (framebuffer)
function LoadRenderTexture(Width, Height: Integer): TRenderTexture2D;
// Check if a texture is ready
function IsTextureReady(Texture: TTexture2D): Boolean;
// Unload texture from GPU memory (VRAM)
procedure UnloadTexture(Texture: TTexture2D);
// Check if a render texture is ready
function IsRenderTextureReady(Texture: TRenderTexture2D): Boolean;
// Unload render texture from GPU memory (VRAM)
procedure UnloadRenderTexture(Target: TRenderTexture2D);
// Update GPU texture with new data
procedure UpdateTexture(Texture: TTexture2D; const Pixels: Pointer);
// Update GPU texture rectangle with new data
procedure UpdateTextureRec(Texture: TTexture2D; Rec: TRectangle; const Pixels: Pointer);

// Texture configuration functions

// Generate GPU mipmaps for a texture
procedure GenTextureMipmaps(Texture: PTexture2D);
//- procedure GenTextureMipmaps(var Texture: TTexture2D);
// Set texture scaling filter mode
procedure SetTextureFilter(Texture: TTexture2D; Filter: TTextureFilter);
// Set texture wrapping mode
procedure SetTextureWrap(Texture: TTexture2D; Wrap: TTextureWrap);

// Texture drawing functions

// Draw a Texture2D
procedure DrawTexture(Texture: TTexture2D; PosX, PosY: Integer; Tint: TColor);
// Draw a Texture2D with position defined as Vector2
procedure DrawTextureV(Texture: TTexture2D; Position: TVector2; Tint: TColor);
// Draw a Texture2D with extended parameters
procedure DrawTextureEx(Texture: TTexture2D; Position: TVector2; Rotation, Scale: Single; Tint: TColor);
// Draw a part of a texture defined by a rectangle
procedure DrawTextureRec(Texture: TTexture2D; Source: TRectangle; Position: TVector2; Tint: TColor);
// Draw a part of a texture defined by a rectangle with 'pro' parameters
procedure DrawTexturePro(Texture: TTexture2D; Source, Dest: TRectangle; Origin: TVector2; Rotation: Single; Tint: TColor);
// Draws a texture (or part of it) that stretches or shrinks nicely
procedure DrawTextureNPatch(Texture: TTexture2D; NPatchInfo: TNPatchInfo; Dest: TRectangle; Origin: TVector2; Rotation: Single; Tint: TColor);

// Color/pixel related functions

// Get color with alpha applied, alpha goes from 0.0f to 1.0f
function Fade(Color: TColor; Alpha: Single): TColor;
// Get hexadecimal value for a Color
function ColorToInt(Color: TColor): Integer;
// Get Color normalized as float [0..1]
function ColorNormalize(Color: TColor): TVector4;
// Get Color from normalized values [0..1]
function ColorFromNormalized(Normalized: TVector4): TColor;
// Get HSV values for a Color, hue [0..360], saturation/value [0..1]
function ColorToHSV(Color: TColor): TVector3;
// Get a Color from HSV values, hue [0..360], saturation/value [0..1]
function ColorFromHSV(Hue, Saturation, Value: Single): TColor;
// Get color multiplied with another color
function ColorTint(Color, Tint: TColor): TColor;
// Get color with brightness correction, brightness factor goes from -1.0f to 1.0f
function ColorBrightness(Color: TColor; Factor: Single): TColor;
// Get color with contrast correction, contrast values between -1.0f and 1.0f
function ColorContrast(Color: TColor; Contrast: Single): TColor;
// Get color with alpha applied, alpha goes from 0.0f to 1.0f
function ColorAlpha(Color: TColor; Alpha: Single): TColor;
// Get src alpha-blended into dst color with tint
function ColorAlphaBlend(Dst, Src, Tint: TColor): TColor;
// Get Color structure from hexadecimal value
function GetColor(HexValue: Cardinal): TColor;
// Get Color from a source pixel pointer of certain format
function GetPixelColor(SrcPtr: Pointer; Format: TPixelFormat): TColor;
// Set color formatted into destination pixel pointer
procedure SetPixelColor(DstPtr: Pointer; Color: TColor; Format: TPixelFormat);
// Get pixel data size in bytes for certain format
function GetPixelDataSize(Width, Height: Integer; Format: TPixelFormat): Integer;

//------------------------------------------------------------------------------------
// TFont Loading and Text Drawing Functions (Module: text)
//------------------------------------------------------------------------------------

// Font loading/unloading functions

// Get the default Font
function GetFontDefault(): TFont;
// Load font from file into GPU memory (VRAM)
function LoadFont(const FileName: PAnsiChar): TFont;
// Load font from file with extended parameters, use NULL for fontChars and 0 for glyphCount to load the default character set
function LoadFontEx(const FileName: PAnsiChar; FontSize: Integer; FontChars: PInteger; GlyphCount: Integer): TFont;
// Load font from Image (XNA style)
function LoadFontFromImage(Image: TImage; Key: TColor; FirstChar: Integer): TFont;
// Load font from memory buffer, fileType refers to extension: i.e. '.ttf'
function LoadFontFromMemory(const FileType: PAnsiChar; const FileData: PByte; DataSize, FontSize: Integer; FontChars: PInteger; GlyphCount: Integer): TFont;
// Check if a font is ready
function IsFontReady(Font: TFont): Boolean;
// Load font data for further uses
function LoadFontData(const FileData: PByte; DataSize, FontSize: Integer; FontChars: PInteger; GlyphCount, Type_: TFontType): PGlyphInfo;
// Generate image font atlas using chars info
function GenImageFontAtlas(const Chars: PGlyphInfo; Recs: PPRectangle; GlyphCount, FontSize, Padding, PackMethod: Integer): TImage;
//- function GenImageFontAtlas(const Chars: PGlyphInfo; out Recs: PRectangle; GlyphCount, FontSize, Padding, PackMethod: Integer): TImage;
// Unload font chars info data (RAM)
procedure UnloadFontData(Chars: PGlyphInfo; GlyphCount: Integer);
// Unload Font from GPU memory (VRAM)
procedure UnloadFont(Font: TFont);
// Export font as code file, returns true on success
procedure ExportFontAsCode(Font: TFont; const FileName: PAnsiChar);

// Text drawing functions

// Draw current FPS
procedure DrawFPS(PosX, PosY: Integer);
// Draw text (using default font)
procedure DrawText(const Text: PAnsiChar; PosX, PosY, FontSize: Integer; Color: TColor);
// Draw text using font and additional parameters
procedure DrawTextEx(Font: TFont; const Text: PAnsiChar; Position: TVector2; FontSize, Spacing: Single; Tint: TColor);
// Draw text using Font and pro parameters (rotation)
procedure DrawTextPro(Font: TFont; const Text: PAnsiChar; Position, Origin: TVector2; Rotation, FontSize, Spacing: Single; Tint: TColor);
// Draw one character (codepoint)
procedure DrawTextCodepoint(Font: TFont; Codepoint: Integer; Position: TVector2; FontSize: Single; Tint: TColor);
// Draw multiple character (codepoint)
procedure DrawTextCodepoints(Font: TFont; const codepoints: PInteger; Count: Integer; Position: TVector2; FontSize, Spacing: Single; Tint: TColor);

// Text font info functions

// Measure string width for default font
function MeasureText(const Text: PAnsiChar; FontSize: Integer): Integer;
// Measure string size for Font
function MeasureTextEx(Font: TFont; const Text: PAnsiChar; FontSize, Spacing: Single): TVector2;
// Get glyph index position in font for a codepoint (unicode character), fallback to '?' if not found
function GetGlyphIndex(Font: TFont; Codepoint: Integer): Integer;
// Get glyph font info data for a codepoint (unicode character), fallback to '?' if not found
function GetGlyphInfo(Font: TFont; Codepoint: Integer): TGlyphInfo;
// Get glyph rectangle in font atlas for a codepoint (unicode character), fallback to '?' if not found
function GetGlyphAtlasRec(Font: TFont; Codepoint: Integer): TRectangle;

// Text codepoints management functions (unicode characters)

// Load UTF-8 text encoded from codepoints array
function LoadUTF8(const Codepoints: PInteger; Length: Integer): PAnsiChar;
// Unload UTF-8 text encoded from codepoints array
procedure UnloadUTF8(Text: PAnsiChar);
// Load all codepoints from a UTF-8 text string, codepoints count returned by parameter
function LoadCodepoints(const Text: PAnsiChar; Count: PInteger): PInteger;
//- function LoadCodepoints(const Text: PAnsiChar; out Count: Integer): PInteger;
// Unload codepoints data from memory
procedure UnloadCodepoints(Codepoints: PInteger);
// Get total number of codepoints in a UTF-8 encoded string
function GetCodepointCount(const Text: PAnsiChar): Integer;
// Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
function GetCodepoint(const Text: PAnsiChar; CodepointSize: PInteger): Integer;
// Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
function GetCodepointNext(const Text: PAnsiChar; CodepointSize: PInteger): Integer;
// Get previous codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
function GetCodepointPrevious(const Text: PAnsiChar; CodepointSize: PInteger): Integer;
// Encode one codepoint into UTF-8 byte array (array length returned as parameter)
function CodepointToUTF8(Codepoint: Integer; Utf8Size: PInteger): PAnsiChar;
//- function CodepointToUTF8(Codepoint: Integer; out Utf8Size: Integer): PAnsiChar;

// Text strings management functions (no UTF-8 strings, only byte chars)
// NOTE: Some strings allocate memory internally for returned strings, just be careful!

// Copy one string to another, returns bytes copied
function TextCopy(Dst: PAnsiChar; const Src: PAnsiChar): Integer;
// Check if two text string are equal
function TextIsEqual(const Text1, Text2: PAnsiChar): Boolean;
// Get text length, checks for '\0' ending
function TextLength(const Text: PAnsiChar): Cardinal;
// Text formatting with variables (sprintf() style)
function TextFormat(const Text: PAnsiChar): PAnsiChar; cdecl varargs;
// Get a piece of a text string
function TextSubtext(const Text: PAnsiChar; Position, Length: Integer): PAnsiChar;
// Replace text string (WARNING: memory must be freed!)
function TextReplace(Text: PAnsiChar; const Replace, By: PAnsiChar): PAnsiChar;
// Insert text in a position (WARNING: memory must be freed!)
function TextInsert(const Text, Insert: PAnsiChar; Position: Integer): PAnsiChar;
// Join text strings with delimiter
function TextJoin(const TextList: PPAnsiChar; Count: Integer; const Delimiter: PAnsiChar): PAnsiChar;
// Split text into multiple strings
function TextSplit(const Text: PAnsiChar; Delimiter: Char; Count: PInteger): PPAnsiChar;
//- function TextSplit(const Text: PAnsiChar; Delimiter: Char; out Count: Integer): PPAnsiChar;
// Append text at specific position and move cursor!
procedure TextAppend(Text: PAnsiChar; const Append: PAnsiChar; Position: PInteger);
//- procedure TextAppend(Text: PAnsiChar; const Append: PAnsiChar; var Position: Integer);
// Find first text occurrence within a string
function TextFindIndex(const Text, Find: PAnsiChar): Integer;
// Get upper case version of provided string
function TextToUpper(const Text: PAnsiChar): PAnsiChar;
// Get lower case version of provided string
function TextToLower(const Text: PAnsiChar): PAnsiChar;
// Get Pascal case notation version of provided string
function TextToPascal(const Text: PAnsiChar): PAnsiChar;
// Get integer value from text (negative values not supported)
function TextToInteger(const Text: PAnsiChar): Integer;

//------------------------------------------------------------------------------------
// Basic 3d Shapes Drawing Functions (Module: models)
//------------------------------------------------------------------------------------

// Basic geometric 3D shapes drawing functions

// Draw a line in 3D world space
procedure DrawLine3D(StartPos, EndPos: TVector3; Color: TColor);
// Draw a point in 3D space, actually a small line
procedure DrawPoint3D(Position: TVector3; Color: TColor);
// Draw a circle in 3D world space
procedure DrawCircle3D(Center: TVector3; Radius: Single; RotationAxis: TVector3; RotationAngle: Single; Color: TColor);
// Draw a color-filled triangle (vertex in counter-clockwise order!)
procedure DrawTriangle3D(V1, V2, V3: TVector3; Color: TColor);
// Draw a triangle strip defined by points
procedure DrawTriangleStrip3D(Points: PVector3; PointCount: Integer; Color: TColor);
// Draw cube
procedure DrawCube(Position: TVector3; Width, Height, Length: Single; Color: TColor);
// Draw cube (Vector version)
procedure DrawCubeV(Position, Size: TVector3; Color: TColor);
// Draw cube wires
procedure DrawCubeWires(Position: TVector3; Width, Height, Length: Single; Color: TColor);
// Draw cube wires (Vector version)
procedure DrawCubeWiresV(Position, Size: TVector3; Color: TColor);
// Draw sphere
procedure DrawSphere(CenterPos: TVector3; Radius: Single; Color: TColor);
// Draw sphere with extended parameters
procedure DrawSphereEx(CenterPos: TVector3; Radius: Single; Rings, Slices: Integer; Color: TColor);
// Draw sphere wires
procedure DrawSphereWires(CenterPos: TVector3; Radius: Single; Rings, Slices: Integer; Color: TColor);
// Draw a cylinder/cone
procedure DrawCylinder(Position: TVector3; RadiusTop, RadiusBottom, Height: Single; Slices: Integer; Color: TColor);
// Draw a cylinder with base at startPos and top at endPos
procedure DrawCylinderEx(StartPos, EndPos: TVector3; StartRadius, EndRadius: Single; Sides: Integer; Color: TColor);
// Draw a cylinder/cone wires
procedure DrawCylinderWires(Position: TVector3; RadiusTop, RadiusBottom, Height: Single; Slices: Integer; Color: TColor);
// Draw a cylinder wires with base at startPos and top at endPos
procedure DrawCylinderWiresEx(StartPos, EndPos: TVector3; StartRadius, EndRadius: Single; Sides: Integer; Color: TColor);
// Draw a capsule with the center of its sphere caps at startPos and endPos
procedure DrawCapsule(StartPos, EndPos: TVector3; Radius: Single; Slices, Rings: Integer; Color: TColor);
// Draw capsule wireframe with the center of its sphere caps at startPos and endPos
procedure DrawCapsuleWires(StartPos, EndPos: TVector3; Radius: Single; Slices, Rings: Integer; Color: TColor);
// Draw a plane XZ
procedure DrawPlane(CenterPos: TVector3; Size: TVector2; Color: TColor);
// Draw a ray line
procedure DrawRay(Ray: TRay; Color: TColor);
// Draw a grid (centered at (0, 0, 0))
procedure DrawGrid(Slices: Integer; Spacing: Single);

//------------------------------------------------------------------------------------
// TModel 3d Loading and Drawing Functions (Module: models)
//------------------------------------------------------------------------------------

// Model management functions

// Load model from files (meshes and materials)
function LoadModel(const FileName: PAnsiChar): TModel;
// Load model from generated mesh (default material)
function LoadModelFromMesh(Mesh: TMesh): TModel;
// Check if a model is ready
function IsModelReady(Model: TModel): Boolean;
// Unload model (including meshes) from memory (RAM and/or VRAM)
procedure UnloadModel(Model: TModel);
// Compute model bounding box limits (considers all meshes)
function GetModelBoundingBox(Model: TModel): TBoundingBox;

//Model drawing functions

// Draw a model (with texture if set)
procedure DrawModel(Model: TModel; Position: TVector3; Scale: Single; Tint: TColor);
// Draw a model with extended parameters
procedure DrawModelEx(Model: TModel; Position, RotationAxis: TVector3; RotationAngle: Single; Scale: TVector3; Tint: TColor);
// Draw a model wires (with texture if set)
procedure DrawModelWires(Model: TModel; Position: TVector3; Scale: Single; Tint: TColor);
// Draw a model wires (with texture if set) with extended parameters
procedure DrawModelWiresEx(Model: TModel; Position, RotationAxis: TVector3; RotationAngle: Single; Scale: TVector3; Tint: TColor);
// Draw bounding box (wires)
procedure DrawBoundingBox(Box: TBoundingBox; Color: TColor);
// Draw a billboard texture
procedure DrawBillboard(Camera: TCamera; Texture: TTexture2D; Position: TVector3; Size: Single; Tint: TColor);
// Draw a billboard texture defined by source
procedure DrawBillboardRec(Camera: TCamera; Texture: TTexture2D; Source: TRectangle; Position: TVector3; Size: TVector2; Tint: TColor);
// Draw a billboard texture defined by source and rotation
procedure DrawBillboardPro(Camera: TCamera; Texture: TTexture2D; Source: TRectangle; Position, Up: TVector3; Size, Origin: TVector2; Rotation: Single; Tint: TColor);

// Mesh management functions

// Upload mesh vertex data in GPU and provide VAO/VBO ids
procedure UploadMesh(Mesh: PMesh; Dynamic_: Boolean);
//- procedure UploadMesh(var Mesh: TMesh; Dynamic_: Boolean);
// Update mesh vertex data in GPU for a specific buffer index
procedure UpdateMeshBuffer(Mesh: TMesh; Index: Integer; const Data: Pointer; DataSize, Offset: Integer);
// Unload mesh data from CPU and GPU
procedure UnloadMesh(Mesh: TMesh);
// Draw a 3d mesh with material and transform
procedure DrawMesh(Mesh: TMesh; Material: TMaterial; Transform: TMatrix);
// Draw multiple mesh instances with material and different transforms
procedure DrawMeshInstanced(Mesh: TMesh; Material: TMaterial; const Transforms: PMatrix; Instances: Integer);
// Export mesh data to file, returns true on success
function ExportMesh(Mesh: TMesh; const FileName: PAnsiChar): Boolean;
// Compute mesh bounding box limits
function GetMeshBoundingBox(Mesh: TMesh): TBoundingBox;
// Compute mesh tangents
procedure GenMeshTangents(Mesh: PMesh);
//- procedure GenMeshTangents(var Mesh: TMesh);

// Mesh generation functions

// Generate polygonal mesh
function GenMeshPoly(Sides: Integer; Radius: Single): TMesh;
// Generate plane mesh (with subdivisions)
function GenMeshPlane(Width, Length: Single; ResX, ResZ: Integer): TMesh;
// Generate cuboid mesh
function GenMeshCube(Width, Height, Length: Single): TMesh;
// Generate sphere mesh (standard sphere)
function GenMeshSphere(Radius: Single; Rings, Slices: Integer): TMesh;
// Generate half-sphere mesh (no bottom cap)
function GenMeshHemiSphere(Radius: Single; Rings, Slices: Integer): TMesh;
// Generate cylinder mesh
function GenMeshCylinder(Radius, Height: Single; Slices: Integer): TMesh;
// Generate cone/pyramid mesh
function GenMeshCone(Radius, Height: Single; Slices: Integer): TMesh;
// Generate torus mesh
function GenMeshTorus(Radius, Size: Single; RadSeg, Sides: Integer): TMesh;
// Generate trefoil knot mesh
function GenMeshKnot(Radius, Size: Single; RadSeg, Sides: Integer): TMesh;
// Generate heightmap mesh from image data
function GenMeshHeightmap(Heightmap: TImage; Size: TVector3): TMesh;
// Generate cubes-based map mesh from image data
function GenMeshCubicmap(Cubicmap: TImage; CubeSize: TVector3): TMesh;

// Material loading/unloading functions

// Load materials from model file
function LoadMaterials(const FileName: PAnsiChar; MaterialCount: PInteger): PMaterial;
//- function LoadMaterials(const FileName: PAnsiChar; out MaterialCount: Integer): PMaterial;
// Load default material (Supports: DIFFUSE, SPECULAR, NORMAL maps)
function LoadMaterialDefault(): TMaterial;
// Check if a material is ready
function IsMaterialReady(Material: TMaterial): Boolean;
// Unload material from GPU memory (VRAM)
procedure UnloadMaterial(Material: TMaterial);
// Set texture for a material map type (MATERIAL_MAP_DIFFUSE, MATERIAL_MAP_SPECULAR...)
procedure SetMaterialTexture(Material: PMaterial; MapType: TMaterialMapIndex; Texture: TTexture2D);
//- procedure SetMaterialTexture(var Material: TMaterial; MapType: TMaterialMapIndex; Texture: TTexture2D);
// Set material for a mesh
procedure SetModelMeshMaterial(Model: PModel; MeshId, MaterialId: Integer);
//- procedure SetModelMeshMaterial(var Model: TModel; MeshId, MaterialId: Integer);

// Model animations loading/unloading functions

// Load model animations from file
function LoadModelAnimations(const FileName: PAnsiChar; AnimCount: PCardinal): PModelAnimation;
//- function LoadModelAnimations(const FileName: PAnsiChar; var AnimCount: Cardinal): PModelAnimation;
// Update model animation pose
procedure UpdateModelAnimation(Model: TModel; Anim: TModelAnimation; Frame: Integer);
// Unload animation data
procedure UnloadModelAnimation(Anim: TModelAnimation);
// Unload animation array data
procedure UnloadModelAnimations(Animations: PModelAnimation; Count: Cardinal);
// Check model animation skeleton match
function IsModelAnimationValid(Model: TModel; Anim: TModelAnimation): Boolean;

// Collision detection functions

// Check collision between two spheres
function CheckCollisionSpheres(Center1: TVector3; Radius1: Single; Center2: TVector3; Radius2: Single): Boolean;
// Check collision between two bounding boxes
function CheckCollisionBoxes(Box1, Box2: TBoundingBox): Boolean;
// Check collision between box and sphere
function CheckCollisionBoxSphere(Box: TBoundingBox; Center: TVector3; Radius: Single): Boolean;
// Get collision info between ray and sphere
function GetRayCollisionSphere(Ray: TRay; Center: TVector3; Radius: Single): TRayCollision;
// Get collision info between ray and box
function GetRayCollisionBox(Ray: TRay; Box: TBoundingBox): TRayCollision;
// Get collision info between ray and mesh
function GetRayCollisionMesh(Ray: TRay; Mesh: TMesh; Transform: TMatrix): TRayCollision;
// Get collision info between ray and triangle
function GetRayCollisionTriangle(Ray: TRay; P1, P2, P3: TVector3): TRayCollision;
// Get collision info between ray and quad
function GetRayCollisionQuad(Ray: TRay; P1, P2, P3, P4: TVector3): TRayCollision;

//------------------------------------------------------------------------------------
// Audio Loading and Playing Functions (Module: audio)
//------------------------------------------------------------------------------------

type
  PAudioCallback = ^TAudioCallback;
  TAudioCallback = procedure (BufferData: Pointer; Frames: Cardinal); cdecl;

// Audio device management functions

// Initialize audio device and context
procedure InitAudioDevice();
// Close the audio device and context
procedure CloseAudioDevice();
// Check if audio device has been initialized successfully
function IsAudioDeviceReady(): Boolean;
// Set master volume (listener)
procedure SetMasterVolume(Volume: Single);

// Wave/Sound loading/unloading functions

// Load wave data from file
function LoadWave(const FileName: PAnsiChar): TWave;
// Load wave from memory buffer, fileType refers to extension: i.e. '.wav'
function LoadWaveFromMemory(const FileType: PAnsiChar; const FileData: PByte; DataSize: Integer): TWave;
// Checks if wave data is ready
function IsWaveReady(Wave: TWave): Boolean;
// Load sound from file
function LoadSound(const FileName: PAnsiChar): TSound;
// Load sound from wave data
function LoadSoundFromWave(Wave: TWave): TSound;
// Checks if a sound is ready
function IsSoundReady(Sound: TSound): Boolean;
// Update sound buffer with new data
procedure UpdateSound(Sound: TSound; const Data: Pointer; SampleCount: Integer);
// Unload wave data
procedure UnloadWave(Wave: TWave);
// Unload sound
procedure UnloadSound(Sound: TSound);
// Export wave data to file, returns true on success
function ExportWave(Wave: TWave; const FileName: PAnsiChar): Boolean;
// Export wave sample data to code (.h), returns true on success
function ExportWaveAsCode(Wave: TWave; const FileName: PAnsiChar): Boolean;

// Wave/Sound management functions

// Play a sound
procedure PlaySound(Sound: TSound);
// Stop playing a sound
procedure StopSound(Sound: TSound);
// Pause a sound
procedure PauseSound(Sound: TSound);
// Resume a paused sound
procedure ResumeSound(Sound: TSound);
// Check if a sound is currently playing
function IsSoundPlaying(Sound: TSound): Boolean;
// Set volume for a sound (1.0 is max level)
procedure SetSoundVolume(Sound: TSound; Volume: Single);
// Set pitch for a sound (1.0 is base level)
procedure SetSoundPitch(Sound: TSound; Pitch: Single);
// Set pan for a sound (0.5 is center)
procedure SetSoundPan(Sound: TSound; Pan: Single);
// Copy a wave to a new wave
function WaveCopy(Wave: TWave): TWave;
// Crop a wave to defined samples range
procedure WaveCrop(Wave: PWave; InitSample, FinalSample: Integer);
//- procedure WaveCrop(var Wave: TWave; InitSample, FinalSample: Integer);
// Convert wave data to desired format
procedure WaveFormat(Wave: PWave; SampleRate, SampleSize, Channels: Integer);
//- procedure WaveFormat(var Wave: TWave; SampleRate, SampleSize, Channels: Integer);
// Load samples data from wave as a floats array
function LoadWaveSamples(Wave: TWave): PSingle;
// Unload samples data loaded with LoadWaveSamples()
procedure UnloadWaveSamples(Samples: PSingle);

// Music management functions

// Load music stream from file
function LoadMusicStream(const FileName: PAnsiChar): TMusic;
// Load music stream from data
function LoadMusicStreamFromMemory(const FileType: PAnsiChar; const Data: PByte; DataSize: Integer): TMusic;
// Checks if a music stream is ready
function IsMusicReady(Music: TMusic): Boolean;
// Unload music stream
procedure UnloadMusicStream(Music: TMusic);
// Start music playing
procedure PlayMusicStream(Music: TMusic);
// Check if music is playing
function IsMusicStreamPlaying(Music: TMusic): Boolean;
// Updates buffers for music streaming
procedure UpdateMusicStream(Music: TMusic);
// Stop music playing
procedure StopMusicStream(Music: TMusic);
// Pause music playing
procedure PauseMusicStream(Music: TMusic);
// Resume playing paused music
procedure ResumeMusicStream(Music: TMusic);
// Seek music to a position (in seconds)
procedure SeekMusicStream(Music: TMusic; Position: Single);
// Set volume for music (1.0 is max level)
procedure SetMusicVolume(Music: TMusic; Volume: Single);
// Set pitch for a music (1.0 is base level)
procedure SetMusicPitch(Music: TMusic; Pitch: Single);
// Set pan for a music (0.5 = center)
procedure SetMusicPan(Music: TMusic; Pan: Single);
// Get music time length (in seconds)
function GetMusicTimeLength(Music: TMusic): Single;
// Get current music time played (in seconds)
function GetMusicTimePlayed(Music: TMusic): Single;

// AudioStream management functions

// Load audio stream (to stream raw audio pcm data)
function LoadAudioStream(SampleRate, SampleSize, Channels: Cardinal): TAudioStream;
// Checks if an audio stream is ready
function IsAudioStreamReady(Stream: TAudioStream): Boolean;
// Unload audio stream and free memory
procedure UnloadAudioStream(Stream: TAudioStream);
// Update audio stream buffers with data
procedure UpdateAudioStream(Stream: TAudioStream; const Data: Pointer; FrameCount: Integer);
// Check if any audio stream buffers requires refill
function IsAudioStreamProcessed(Stream: TAudioStream): Boolean;
// Play audio stream
procedure PlayAudioStream(Stream: TAudioStream);
// Pause audio stream
procedure PauseAudioStream(Stream: TAudioStream);
// Resume audio stream
procedure ResumeAudioStream(Stream: TAudioStream);
// Check if audio stream is playing
function IsAudioStreamPlaying(Stream: TAudioStream): Boolean;
// Stop audio stream
procedure StopAudioStream(Stream: TAudioStream);
// Set volume for audio stream (1.0 is max level)
procedure SetAudioStreamVolume(Stream: TAudioStream; Volume: Single);
// Set pitch for audio stream (1.0 is base level)
procedure SetAudioStreamPitch(Stream: TAudioStream; Pitch: Single);
// Set pan for audio stream (0.5 is centered)
procedure SetAudioStreamPan(Stream: TAudioStream; Pan: Single);
// Default size for new audio streams
procedure SetAudioStreamBufferSizeDefault(Size: Integer);
// Audio thread callback to request new data
procedure SetAudioStreamCallback(Stream: TAudioStream; Callback: TAudioCallback);

// Attach audio stream processor to stream
procedure AttachAudioStreamProcessor(Stream: TAudioStream; Processor: TAudioCallback);
// Detach audio stream processor from stream
procedure DetachAudioStreamProcessor(Stream: TAudioStream; Processor: TAudioCallback);

// Attach audio stream processor to the entire audio pipeline
procedure AttachAudioMixedProcessor(Processor: TAudioCallback);
// Detach audio stream processor from the entire audio pipeline
procedure DetachAudioMixedProcessor(Processor: TAudioCallback);

implementation

{$IFDEF FPC}
uses
  Math;
{$ENDIF}

// Raylib makes extensive use of passing structs to functions, and changes those structs in the future.
// Since structs are in fact passed as references, these changes result in undefined behavior in the ABI.
// Ultimately, I decided to simply describe the "wrappers" that protect against changes.

// Window-related functions

procedure Lib_InitWindow(Width, Height: Integer; const Title: PAnsiChar);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'InitWindow';
procedure InitWindow(Width, Height: Integer; const Title: PAnsiChar);
begin
  Lib_InitWindow(Width, Height, Title);
end;

function Lib_WindowShouldClose(): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'WindowShouldClose';
function WindowShouldClose(): Boolean;
begin
  Result := Lib_WindowShouldClose();
end;

procedure Lib_CloseWindow();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CloseWindow';
procedure CloseWindow();
begin
  Lib_CloseWindow();
end;

function Lib_IsWindowReady(): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsWindowReady';
function IsWindowReady(): Boolean;
begin
  Result := Lib_IsWindowReady();
end;

function Lib_IsWindowFullscreen(): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsWindowFullscreen';
function IsWindowFullscreen(): Boolean;
begin
  Result := Lib_IsWindowFullscreen();
end;

function Lib_IsWindowHidden(): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsWindowHidden';
function IsWindowHidden(): Boolean;
begin
  Result := Lib_IsWindowHidden();
end;

function Lib_IsWindowMinimized(): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsWindowMinimized';
function IsWindowMinimized(): Boolean;
begin
  Result := Lib_IsWindowMinimized();
end;

function Lib_IsWindowMaximized(): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsWindowMaximized';
function IsWindowMaximized(): Boolean;
begin
  Result := Lib_IsWindowMaximized();
end;

function Lib_IsWindowFocused(): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsWindowFocused';
function IsWindowFocused(): Boolean;
begin
  Result := Lib_IsWindowFocused();
end;

function Lib_IsWindowResized(): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsWindowResized';
function IsWindowResized(): Boolean;
begin
  Result := Lib_IsWindowResized();
end;

function Lib_IsWindowState(Flag: TConfigFlags): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsWindowState';
function IsWindowState(Flag: TConfigFlags): Boolean;
begin
  Result := Lib_IsWindowState(Flag);
end;

procedure Lib_SetWindowState(Flags: TConfigFlags);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetWindowState';
procedure SetWindowState(Flags: TConfigFlags);
begin
  Lib_SetWindowState(Flags);
end;

procedure Lib_ClearWindowState(Flags: TConfigFlags);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ClearWindowState';
procedure ClearWindowState(Flags: TConfigFlags);
begin
  Lib_ClearWindowState(Flags);
end;

procedure Lib_ToggleFullscreen();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ToggleFullscreen';
procedure ToggleFullscreen();
begin
  Lib_ToggleFullscreen();
end;

procedure Lib_MaximizeWindow();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MaximizeWindow';
procedure MaximizeWindow();
begin
  Lib_MaximizeWindow();
end;

procedure Lib_MinimizeWindow();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MinimizeWindow';
procedure MinimizeWindow();
begin
  Lib_MinimizeWindow();
end;

procedure Lib_RestoreWindow();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'RestoreWindow';
procedure RestoreWindow();
begin
  Lib_RestoreWindow();
end;

procedure Lib_SetWindowIcon(Image: TImage);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetWindowIcon';
procedure SetWindowIcon(Image: TImage);
begin
  Lib_SetWindowIcon(Image);
end;

procedure Lib_SetWindowIcons(Image: PImage; Count: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetWindowIcons';
procedure SetWindowIcons(Image: PImage; Count: Integer);
begin
  Lib_SetWindowIcons(Image, Count);
end;

procedure Lib_SetWindowTitle(const Title: PAnsiChar);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetWindowTitle';
procedure SetWindowTitle(const Title: PAnsiChar);
begin
  Lib_SetWindowTitle(Title);
end;

procedure Lib_SetWindowPosition(X, Y: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetWindowPosition';
procedure SetWindowPosition(X, Y: Integer);
begin
  Lib_SetWindowPosition(X, Y);
end;

procedure Lib_SetWindowMonitor(Monitor: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetWindowMonitor';
procedure SetWindowMonitor(Monitor: Integer);
begin
  Lib_SetWindowMonitor(Monitor);
end;

procedure Lib_SetWindowMinSize(Width, Height: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetWindowMinSize';
procedure SetWindowMinSize(Width, Height: Integer);
begin
  Lib_SetWindowMinSize(Width, Height);
end;

procedure Lib_SetWindowSize(Width, Height: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetWindowSize';
procedure SetWindowSize(Width, Height: Integer);
begin
  Lib_SetWindowSize(Width, Height);
end;

procedure Lib_SetWindowOpacity(Opacity: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetWindowOpacity';
procedure SetWindowOpacity(Opacity: Single);
begin
  Lib_SetWindowOpacity(Opacity);
end;

function Lib_GetWindowHandle(): Pointer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetWindowHandle';
function GetWindowHandle(): Pointer;
begin
  Result := Lib_GetWindowHandle();
end;

function Lib_GetScreenWidth(): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetScreenWidth';
function GetScreenWidth(): Integer;
begin
  Result := Lib_GetScreenWidth();
end;

function Lib_GetScreenHeight(): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetScreenHeight';
function GetScreenHeight(): Integer;
begin
  Result := Lib_GetScreenHeight();
end;

function Lib_GetRenderWidth(): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetRenderWidth';
function GetRenderWidth(): Integer;
begin
  Result := Lib_GetRenderWidth();
end;

function Lib_GetRenderHeight(): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetRenderHeight';
function GetRenderHeight(): Integer;
begin
  Result := Lib_GetRenderHeight();
end;

function Lib_GetMonitorCount(): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetMonitorCount';
function GetMonitorCount(): Integer;
begin
  Result := Lib_GetMonitorCount();
end;

function Lib_GetCurrentMonitor(): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetCurrentMonitor';
function GetCurrentMonitor(): Integer;
begin
  Result := Lib_GetCurrentMonitor();
end;

function Lib_GetMonitorPosition(Monitor: Integer): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetMonitorPosition';
function GetMonitorPosition(Monitor: Integer): TVector2;
begin
  Result := TVector2(Lib_GetMonitorPosition(Monitor));
end;

function Lib_GetMonitorWidth(Monitor: Integer): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetMonitorWidth';
function GetMonitorWidth(Monitor: Integer): Integer;
begin
  Result := Lib_GetMonitorWidth(Monitor);
end;

function Lib_GetMonitorHeight(Monitor: Integer): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetMonitorHeight';
function GetMonitorHeight(Monitor: Integer): Integer;
begin
  Result := Lib_GetMonitorHeight(Monitor);
end;

function Lib_GetMonitorPhysicalWidth(Monitor: Integer): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetMonitorPhysicalWidth';
function GetMonitorPhysicalWidth(Monitor: Integer): Integer;
begin
  Result := GetMonitorPhysicalWidth(Monitor);
end;

function Lib_GetMonitorPhysicalHeight(Monitor: Integer): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetMonitorPhysicalHeight';
function GetMonitorPhysicalHeight(Monitor: Integer): Integer;
begin
  Result := Lib_GetMonitorPhysicalHeight(Monitor);
end;

function Lib_GetMonitorRefreshRate(Monitor: Integer): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetMonitorRefreshRate';
function GetMonitorRefreshRate(Monitor: Integer): Integer;
begin
  Result := Lib_GetMonitorRefreshRate(Monitor);
end;

function Lib_GetWindowPosition(): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetWindowPosition';
function GetWindowPosition(): TVector2;
begin
  Result := TVector2(Lib_GetWindowPosition());
end;

function Lib_GetWindowScaleDPI(): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetWindowScaleDPI';
function GetWindowScaleDPI(): TVector2;
begin
  Result := TVector2(Lib_GetWindowScaleDPI());
end;

function Lib_GetMonitorName(Monitor: Integer): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetMonitorName';
function GetMonitorName(Monitor: Integer): PAnsiChar;
begin
  Result := Lib_GetMonitorName(Monitor);
end;

procedure Lib_SetClipboardText(const Text: PAnsiChar);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetClipboardText';
procedure SetClipboardText(const Text: PAnsiChar);
begin
  Lib_SetClipboardText(Text);
end;

function Lib_GetClipboardText(): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetClipboardText';
function GetClipboardText(): PAnsiChar;
begin
  Result := Lib_GetClipboardText();
end;

procedure Lib_EnableEventWaiting();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'EnableEventWaiting';
procedure EnableEventWaiting();
begin
  Lib_EnableEventWaiting();
end;

procedure Lib_DisableEventWaiting();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DisableEventWaiting';
procedure DisableEventWaiting();
begin
  Lib_DisableEventWaiting();
end;

// Custom frame control functions

procedure Lib_SwapScreenBuffer();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SwapScreenBuffer';
procedure SwapScreenBuffer();
begin
  Lib_SwapScreenBuffer();
end;

procedure Lib_PollInputEvents();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'PollInputEvents';
procedure PollInputEvents();
begin
  Lib_PollInputEvents();
end;

procedure Lib_WaitTime(Seconds: Double);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'WaitTime';
procedure WaitTime(Seconds: Double);
begin
  Lib_WaitTime(Seconds);
end;

// Cursor-related functions

procedure Lib_ShowCursor();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ShowCursor';
procedure ShowCursor();
begin
  Lib_ShowCursor();
end;

procedure Lib_HideCursor();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'HideCursor';
procedure HideCursor();
begin
  Lib_HideCursor();
end;

function Lib_IsCursorHidden(): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsCursorHidden';
function IsCursorHidden(): Boolean;
begin
  Result := Lib_IsCursorHidden();
end;

procedure Lib_EnableCursor();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'EnableCursor';
procedure EnableCursor();
begin
  Lib_EnableCursor();
end;

procedure Lib_DisableCursor();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DisableCursor';
procedure DisableCursor();
begin
  Lib_DisableCursor();
end;

function Lib_IsCursorOnScreen(): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsCursorOnScreen';
function IsCursorOnScreen(): Boolean;
begin
  Result := Lib_IsCursorOnScreen();
end;

// Drawing-related functions

procedure Lib_ClearBackground(Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ClearBackground';
procedure ClearBackground(Color: TColor);
begin
  Lib_ClearBackground(Color);
end;

procedure Lib_BeginDrawing();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'BeginDrawing';
procedure BeginDrawing();
begin
  Lib_BeginDrawing();
end;

procedure Lib_EndDrawing();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'EndDrawing';
procedure EndDrawing();
begin
  Lib_EndDrawing();
end;

procedure Lib_BeginMode2D(Camera: TCamera2D);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'BeginMode2D';
procedure BeginMode2D(Camera: TCamera2D);
begin
  Lib_BeginMode2D(Camera);
end;

procedure Lib_EndMode2D();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'EndMode2D';
procedure EndMode2D();
begin
  Lib_EndMode2D();
end;

procedure Lib_BeginMode3D(Camera: TCamera3D);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'BeginMode3D';
procedure BeginMode3D(Camera: TCamera3D);
begin
  Lib_BeginMode3D(Camera);
end;

procedure Lib_EndMode3D();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'EndMode3D';
procedure EndMode3D();
begin
  Lib_EndMode3D();
end;

procedure Lib_BeginTextureMode(Target: TRenderTexture2D);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'BeginTextureMode';
procedure BeginTextureMode(Target: TRenderTexture2D);
begin
  Lib_BeginTextureMode(Target);
end;

procedure Lib_EndTextureMode();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'EndTextureMode';
procedure EndTextureMode();
begin
  Lib_EndTextureMode();
end;

procedure Lib_BeginShaderMode(Shader: TShader);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'BeginShaderMode';
procedure BeginShaderMode(Shader: TShader);
begin
  Lib_BeginShaderMode(Shader);
end;

procedure Lib_EndShaderMode();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'EndShaderMode';
procedure EndShaderMode();
begin
  Lib_EndShaderMode();
end;

procedure Lib_BeginBlendMode(Mode: TBlendMode);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'BeginBlendMode';
procedure BeginBlendMode(Mode: TBlendMode);
begin
  Lib_BeginBlendMode(Mode);
end;

procedure Lib_EndBlendMode();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'EndBlendMode';
procedure EndBlendMode();
begin
  Lib_EndBlendMode();
end;

procedure Lib_BeginScissorMode(X, Y, Width, Height: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'BeginScissorMode';
procedure BeginScissorMode(X, Y, Width, Height: Integer);
begin
  Lib_BeginScissorMode(X, Y, Width, Height);
end;

procedure Lib_EndScissorMode();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'EndScissorMode';
procedure EndScissorMode();
begin
  Lib_EndScissorMode();
end;

procedure Lib_BeginVrStereoMode(Config: TVrStereoConfig);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'BeginVrStereoMode';
procedure BeginVrStereoMode(Config: TVrStereoConfig);
begin
  Lib_BeginVrStereoMode(Config);
end;

procedure Lib_EndVrStereoMode();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'EndVrStereoMode';
procedure EndVrStereoMode();
begin
  Lib_EndVrStereoMode();
end;

// VR stereo config functions for VR simulator

function Lib_LoadVrStereoConfig(Device: TVrDeviceInfo): TVrStereoConfig;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadVrStereoConfig';
function LoadVrStereoConfig(Device: TVrDeviceInfo): TVrStereoConfig;
begin
  Result := Lib_LoadVrStereoConfig(Device);
end;

procedure Lib_UnloadVrStereoConfig(Config: TVrStereoConfig);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadVrStereoConfig';
procedure UnloadVrStereoConfig(Config: TVrStereoConfig);
begin
  Lib_UnloadVrStereoConfig(Config);
end;

// Shader management functions

function Lib_LoadShader(const VsFileName, FsFileName: PAnsiChar): {$IFNDEF RET_TRICK}TShader{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadShader';
function LoadShader(const VsFileName, FsFileName: PAnsiChar): TShader;
begin
  Result := TShader(Lib_LoadShader(VsFileName, FsFileName));
end;

function Lib_LoadShaderFromMemory(const VsCode, FsCode: PAnsiChar): {$IFNDEF RET_TRICK}TShader{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadShaderFromMemory';
function LoadShaderFromMemory(const VsCode, FsCode: PAnsiChar): TShader;
begin
  Result := TShader(Lib_LoadShaderFromMemory(VsCode, FsCode));
end;

function Lib_IsShaderReady(Shader: TShader): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsShaderReady';
function IsShaderReady(Shader: TShader): Boolean;
begin
  Result := Lib_IsShaderReady(Shader);
end;

function Lib_GetShaderLocation(Shader: TShader; const UniformName: PAnsiChar): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetShaderLocation';
function GetShaderLocation(Shader: TShader; const UniformName: PAnsiChar): Integer;
begin
  Result := Lib_GetShaderLocation(Shader, UniformName);
end;

function Lib_GetShaderLocationAttrib(Shader: TShader; const AttribName: PAnsiChar): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetShaderLocationAttrib';
function GetShaderLocationAttrib(Shader: TShader; const AttribName: PAnsiChar): Integer;
begin
  Result := Lib_GetShaderLocationAttrib(Shader, AttribName);
end;

procedure Lib_SetShaderValue(Shader: TShader; LocIndex: Integer; const Value: Pointer; UniformType: TShaderUniformDataType);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetShaderValue';
procedure SetShaderValue(Shader: TShader; LocIndex: Integer; const Value: Pointer; UniformType: TShaderUniformDataType);
begin
  Lib_SetShaderValue(Shader, LocIndex, Value, UniformType);
end;

procedure Lib_SetShaderValueV(Shader: TShader; LocIndex: Integer; const Value: Pointer; UniformType: TShaderUniformDataType; Count: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetShaderValueV';
procedure SetShaderValueV(Shader: TShader; LocIndex: Integer; const Value: Pointer; UniformType: TShaderUniformDataType; Count: Integer);
begin
  Lib_SetShaderValueV(Shader, LocIndex, Value, UniformType, Count);
end;

procedure Lib_SetShaderValueMatrix(Shader: TShader; LocIndex: Integer; Mat: TMatrix);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetShaderValueMatrix';
procedure SetShaderValueMatrix(Shader: TShader; LocIndex: Integer; Mat: TMatrix);
begin
  Lib_SetShaderValueMatrix(Shader, LocIndex, Mat);
end;

procedure Lib_SetShaderValueTexture(Shader: TShader; LocIndex: Integer; Texture: TTexture2D);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetShaderValueTexture';
procedure SetShaderValueTexture(Shader: TShader; LocIndex: Integer; Texture: TTexture2D);
begin
  Lib_SetShaderValueTexture(Shader, LocIndex, Texture);
end;

procedure Lib_UnloadShader(Shader: TShader);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadShader';
procedure UnloadShader(Shader: TShader);
begin
  Lib_UnloadShader(Shader);
end;

// Screen-space-related functions

function Lib_GetMouseRay(MousePosition: TVector2; Camera: TCamera): TRay;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetMouseRay';
function GetMouseRay(MousePosition: TVector2; Camera: TCamera): TRay;
begin
  Result := Lib_GetMouseRay(MousePosition, Camera);
end;

function Lib_GetCameraMatrix(Camera: TCamera): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetCameraMatrix';
function GetCameraMatrix(Camera: TCamera): TMatrix;
begin
  Result := Lib_GetCameraMatrix(Camera);
end;

function Lib_GetCameraMatrix2D(Camera: TCamera2D): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetCameraMatrix2D';
function GetCameraMatrix2D(Camera: TCamera2D): TMatrix;
begin
  Result := Lib_GetCameraMatrix2D(Camera);
end;

function Lib_GetWorldToScreen(Position: TVector3; Camera: TCamera): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetWorldToScreen';
function GetWorldToScreen(Position: TVector3; Camera: TCamera): TVector2;
begin
  Result := TVector2(Lib_GetWorldToScreen(Position, Camera));
end;

function Lib_GetScreenToWorld2D(Position: TVector2; Camera: TCamera2D): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetScreenToWorld2D';
function GetScreenToWorld2D(Position: TVector2; Camera: TCamera2D): TVector2;
begin
  Result := TVector2(Lib_GetScreenToWorld2D(Position, Camera));
end;

function Lib_GetWorldToScreenEx(Position: TVector3; Camera: TCamera; Width, Height: Integer): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetWorldToScreenEx';
function GetWorldToScreenEx(Position: TVector3; Camera: TCamera; Width, Height: Integer): TVector2;
begin
  Result := TVector2(Lib_GetWorldToScreenEx(Position, Camera, Width, Height));
end;

function Lib_GetWorldToScreen2D(Position: TVector2; Camera: TCamera2D): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetWorldToScreen2D';
function GetWorldToScreen2D(Position: TVector2; Camera: TCamera2D): TVector2;
begin
  Result := TVector2(Lib_GetWorldToScreen2D(Position, Camera));
end;

// Timing-related functions

procedure Lib_SetTargetFPS(Fps: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetTargetFPS';
procedure SetTargetFPS(Fps: Integer);
begin
  Lib_SetTargetFPS(Fps);
end;

function Lib_GetFPS(): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetFPS';
function GetFPS(): Integer;
begin
  Result := Lib_GetFPS();
end;

function Lib_GetFrameTime(): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetFrameTime';
function GetFrameTime(): Single;
begin
  Result := Lib_GetFrameTime();
end;

function Lib_GetTime(): Double;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetTime';
function GetTime(): Double;
begin
  Result := Lib_GetTime();
end;

// Misc. functions

function Lib_GetRandomValue(Min, Max: Integer): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetRandomValue';
function GetRandomValue(Min, Max: Integer): Integer;
begin
  Result := Lib_GetRandomValue(Min, Max);
end;

procedure Lib_SetRandomSeed(Seed: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetRandomSeed';
procedure SetRandomSeed(Seed: Cardinal);
begin
  Lib_SetRandomSeed(Seed);
end;

procedure Lib_TakeScreenshot(const FileName: PAnsiChar);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'TakeScreenshot';
procedure TakeScreenshot(const FileName: PAnsiChar);
begin
  Lib_TakeScreenshot(FileName);
end;

procedure Lib_SetConfigFlags(Flags: TConfigFlags);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetConfigFlags';
procedure SetConfigFlags(Flags: TConfigFlags);
begin
  Lib_SetConfigFlags(Flags);
end;

procedure TraceLog(LogLevel: TTraceLogLevel; const Text: PAnsiChar);
  cdecl varargs; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'TraceLog';

procedure Lib_SetTraceLogLevel(LogLevel: TTraceLogLevel);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetTraceLogLevel';
procedure SetTraceLogLevel(LogLevel: TTraceLogLevel);
begin
  Lib_SetTraceLogLevel(LogLevel);
end;

function Lib_MemAlloc(Size: Cardinal): Pointer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MemAlloc';
function MemAlloc(Size: Cardinal): Pointer;
begin
  Result := Lib_MemAlloc(Size);
end;

function Lib_MemRealloc(Ptr: Pointer; Size: Cardinal): Pointer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MemRealloc';
function MemRealloc(Ptr: Pointer; Size: Cardinal): Pointer;
begin
  Result := Lib_MemRealloc(Ptr, Size);
end;

procedure Lib_MemFree(Ptr: Pointer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MemFree';
procedure MemFree(Ptr: Pointer);
begin
  Lib_MemFree(Ptr);
end;

procedure Lib_OpenURL(const Url: PAnsiChar);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'OpenURL';
procedure OpenURL(const Url: PAnsiChar);
begin
  Lib_OpenURL(Url);
end;

// Set custom callbacks

procedure Lib_SetTraceLogCallback(Callback: TTraceLogCallback);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetTraceLogCallback';
procedure SetTraceLogCallback(Callback: TTraceLogCallback);
begin
  Lib_SetTraceLogCallback(Callback);
end;

procedure Lib_SetLoadFileDataCallback(Callback: TLoadFileDataCallback);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetLoadFileDataCallback';
procedure SetLoadFileDataCallback(Callback: TLoadFileDataCallback);
begin
  Lib_SetLoadFileDataCallback(Callback);
end;

procedure Lib_SetSaveFileDataCallback(Callback: TSaveFileDataCallback);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetSaveFileDataCallback';
procedure SetSaveFileDataCallback(Callback: TSaveFileDataCallback);
begin
  Lib_SetSaveFileDataCallback(Callback);
end;

procedure Lib_SetLoadFileTextCallback(Callback: TLoadFileTextCallback);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetLoadFileTextCallback';
procedure SetLoadFileTextCallback(Callback: TLoadFileTextCallback);
begin
  Lib_SetLoadFileTextCallback(Callback);
end;

procedure Lib_SetSaveFileTextCallback(Callback: TSaveFileTextCallback);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetSaveFileTextCallback';
procedure SetSaveFileTextCallback(Callback: TSaveFileTextCallback);
begin
  Lib_SetSaveFileTextCallback(Callback);
end;

// Files management functions

function Lib_LoadFileData(const FileName: PAnsiChar; BytesRead: PCardinal): PByte;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadFileData';
function LoadFileData(const FileName: PAnsiChar; BytesRead: PCardinal): PByte;
begin
  Result := Lib_LoadFileData(FileName, BytesRead);
end;

procedure Lib_UnloadFileData(Data: PByte);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadFileData';
procedure UnloadFileData(Data: PByte);
begin
  Lib_UnloadFileData(Data);
end;

function Lib_SaveFileData(const FileName: PAnsiChar; Data: Pointer; BytesToWrite: Cardinal): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SaveFileData';
function SaveFileData(const FileName: PAnsiChar; Data: Pointer; BytesToWrite: Cardinal): Boolean;
begin
  Result := Lib_SaveFileData(FileName, Data, BytesToWrite);
end;

function Lib_ExportDataAsCode(const Data: PAnsiChar; Size: Cardinal; const FileName: PAnsiChar): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ExportDataAsCode';
function ExportDataAsCode(const Data: PAnsiChar; Size: Cardinal; const FileName: PAnsiChar): Boolean;
begin
  Result := Lib_ExportDataAsCode(Data, Size, FileName);
end;

function Lib_LoadFileText(const FileName: PAnsiChar): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadFileText';
function LoadFileText(const FileName: PAnsiChar): PAnsiChar;
begin
  Result := Lib_LoadFileText(FileName);
end;

procedure Lib_UnloadFileText(Text: PAnsiChar);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadFileText';
procedure UnloadFileText(Text: PAnsiChar);
begin
  Lib_UnloadFileText(Text);
end;

function Lib_SaveFileText(const FileName: PAnsiChar; Text: PAnsiChar): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SaveFileText';
function SaveFileText(const FileName: PAnsiChar; Text: PAnsiChar): Boolean;
begin
  Result := Lib_SaveFileText(FileName, Text);
end;

function Lib_FileExists(const FileName: PAnsiChar): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'FileExists';
function FileExists(const FileName: PAnsiChar): Boolean;
begin
  Result := Lib_FileExists(FileName);
end;

function Lib_DirectoryExists(const DirPath: PAnsiChar): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DirectoryExists';
function DirectoryExists(const DirPath: PAnsiChar): Boolean;
begin
  Result := Lib_DirectoryExists(DirPath);
end;

function Lib_IsFileExtension(const FileName, Ext: PAnsiChar): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsFileExtension';
function IsFileExtension(const FileName, Ext: PAnsiChar): Boolean;
begin
  Result := Lib_IsFileExtension(FileName, Ext);
end;

function Lib_GetFileLength(const FileName: PAnsiChar): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetFileLength';
function GetFileLength(const FileName: PAnsiChar): Integer;
begin
  Result := Lib_GetFileLength(FileName);
end;

function Lib_GetFileExtension(const FileName: PAnsiChar): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetFileExtension';
function GetFileExtension(const FileName: PAnsiChar): PAnsiChar;
begin
  Result := Lib_GetFileExtension(FileName);
end;

function Lib_GetFileName(const FilePath: PAnsiChar): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetFileName';
function GetFileName(const FilePath: PAnsiChar): PAnsiChar;
begin
  Result := Lib_GetFileName(FilePath);
end;

function Lib_GetFileNameWithoutExt(const FilePath: PAnsiChar): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetFileNameWithoutExt';
function GetFileNameWithoutExt(const FilePath: PAnsiChar): PAnsiChar;
begin
  Result := Lib_GetFileNameWithoutExt(FilePath);
end;

function Lib_GetDirectoryPath(const FilePath: PAnsiChar): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetDirectoryPath';
function GetDirectoryPath(const FilePath: PAnsiChar): PAnsiChar;
begin
  Result := Lib_GetDirectoryPath(FilePath);
end;

function Lib_GetPrevDirectoryPath(const DirPath: PAnsiChar): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetPrevDirectoryPath';
function GetPrevDirectoryPath(const DirPath: PAnsiChar): PAnsiChar;
begin
  Result := Lib_GetPrevDirectoryPath(DirPath);
end;

function Lib_GetWorkingDirectory(): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetWorkingDirectory';
function GetWorkingDirectory(): PAnsiChar;
begin
  Result := Lib_GetWorkingDirectory();
end;

function Lib_GetApplicationDirectory(): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetApplicationDirectory';
function GetApplicationDirectory(): PAnsiChar;
begin
  Result := Lib_GetApplicationDirectory();
end;

function Lib_ChangeDirectory(const Dir: PAnsiChar): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ChangeDirectory';
function ChangeDirectory(const Dir: PAnsiChar): Boolean;
begin
  Result := Lib_ChangeDirectory(Dir);
end;

function Lib_IsPathFile(const Path: PAnsiChar): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsPathFile';
function IsPathFile(const Path: PAnsiChar): Boolean;
begin
  Result := Lib_IsPathFile(Path);
end;

function Lib_LoadDirectoryFiles(const DirPath: PAnsiChar): TFilePathList;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadDirectoryFiles';
function LoadDirectoryFiles(const DirPath: PAnsiChar): TFilePathList;
begin
  Result := Lib_LoadDirectoryFiles(DirPath);
end;

function Lib_LoadDirectoryFilesEx(const BasePath, Filter: PAnsiChar; ScanSubdirs: Boolean): TFilePathList;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadDirectoryFilesEx';
function LoadDirectoryFilesEx(const BasePath, Filter: PAnsiChar; ScanSubdirs: Boolean): TFilePathList;
begin
  Result := Lib_LoadDirectoryFilesEx(BasePath, Filter, ScanSubdirs);
end;

procedure Lib_UnloadDirectoryFiles(Files: TFilePathList);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadDirectoryFiles';
procedure UnloadDirectoryFiles(Files: TFilePathList);
begin
  Lib_UnloadDirectoryFiles(Files);
end;

function Lib_IsFileDropped(): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsFileDropped';
function IsFileDropped(): Boolean;
begin
  Result := Lib_IsFileDropped();
end;

function Lib_LoadDroppedFiles(): TFilePathList;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadDroppedFiles';
function LoadDroppedFiles(): TFilePathList;
begin
  Result := Lib_LoadDroppedFiles();
end;

procedure Lib_UnloadDroppedFiles(Files: TFilePathList);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadDroppedFiles';
procedure UnloadDroppedFiles(Files: TFilePathList);
begin
  Lib_UnloadDroppedFiles(Files);
end;

function Lib_GetFileModTime(const FileName: PAnsiChar): LongInt;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetFileModTime';
function GetFileModTime(const FileName: PAnsiChar): LongInt;
begin
  Result := Lib_GetFileModTime(FileName);
end;

// Compression/Encoding functionality

function Lib_CompressData(const Data: PByte; DataSize: Integer; CompDataSize: PInteger): PByte;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CompressData';
function CompressData(const Data: PByte; DataSize: Integer; CompDataSize: PInteger): PByte;
begin
  Result := Lib_CompressData(Data, DataSize, CompDataSize);
end;

function Lib_DecompressData(const CompData: PByte; CompDataSize: Integer; DataSize: PInteger): PByte;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DecompressData';
function DecompressData(const CompData: PByte; CompDataSize: Integer; DataSize: PInteger): PByte;
begin
  Result := Lib_DecompressData(CompData, CompDataSize, DataSize);
end;

function Lib_EncodeDataBase64(const Data: PByte; DataSize: Integer; OutputSize: PInteger): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'EncodeDataBase64';
function EncodeDataBase64(const Data: PByte; DataSize: Integer; OutputSize: PInteger): PAnsiChar;
begin
  Result := Lib_EncodeDataBase64(Data, DataSize, OutputSize);
end;

function Lib_DecodeDataBase64(const Data: PAnsiChar; OutputSize: PInteger): PByte;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DecodeDataBase64';
function DecodeDataBase64(const Data: PAnsiChar; OutputSize: PInteger): PByte;
begin
  Result := Lib_DecodeDataBase64(Data, OutputSize);
end;

// Input-related functions: keyboard

function Lib_IsKeyPressed(Key: TKeyboardKey): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsKeyPressed';
function IsKeyPressed(Key: TKeyboardKey): Boolean;
begin
  Result := Lib_IsKeyPressed(Key);
end;

function Lib_IsKeyDown(Key: TKeyboardKey): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsKeyDown';
function IsKeyDown(Key: TKeyboardKey): Boolean;
begin
  Result := Lib_IsKeyDown(Key);
end;

function Lib_IsKeyReleased(Key: TKeyboardKey): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsKeyReleased';
function IsKeyReleased(Key: TKeyboardKey): Boolean;
begin
  Result := Lib_IsKeyReleased(Key);
end;

function Lib_IsKeyUp(Key: TKeyboardKey): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsKeyUp';
function IsKeyUp(Key: TKeyboardKey): Boolean;
begin
  Result := Lib_IsKeyUp(Key);
end;

procedure Lib_SetExitKey(Key: TKeyboardKey);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetExitKey';
procedure SetExitKey(Key: TKeyboardKey);
begin
  Lib_SetExitKey(Key);
end;

function Lib_GetKeyPressed(): TKeyboardKey;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetKeyPressed';
function GetKeyPressed(): TKeyboardKey;
begin
  Result := Lib_GetKeyPressed();
end;

function Lib_GetCharPressed(): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetCharPressed';
function GetCharPressed(): Integer;
begin
  Result := Lib_GetCharPressed();
end;

// Input-related functions: gamepads

function Lib_IsGamepadAvailable(Gamepad: Integer): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsGamepadAvailable';
function IsGamepadAvailable(Gamepad: Integer): Boolean;
begin
  Result := Lib_IsGamepadAvailable(Gamepad);
end;

function Lib_GetGamepadName(Gamepad: Integer): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetGamepadName';
function GetGamepadName(Gamepad: Integer): PAnsiChar;
begin
  Result := Lib_GetGamepadName(Gamepad);
end;

function Lib_IsGamepadButtonPressed(Gamepad: Integer; Button: TGamepadButton): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsGamepadButtonPressed';
function IsGamepadButtonPressed(Gamepad: Integer; Button: TGamepadButton): Boolean;
begin
  Result := Lib_IsGamepadButtonPressed(Gamepad, Button);
end;

function Lib_IsGamepadButtonDown(Gamepad: Integer; Button: TGamepadButton): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsGamepadButtonDown';
function IsGamepadButtonDown(Gamepad: Integer; Button: TGamepadButton): Boolean;
begin
  Result := Lib_IsGamepadButtonDown(Gamepad, Button);
end;

function Lib_IsGamepadButtonReleased(Gamepad: Integer; Button: TGamepadButton): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsGamepadButtonReleased';
function IsGamepadButtonReleased(Gamepad: Integer; Button: TGamepadButton): Boolean;
begin
  Result := Lib_IsGamepadButtonReleased(Gamepad, Button);
end;

function Lib_IsGamepadButtonUp(Gamepad: Integer; Button: TGamepadButton): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsGamepadButtonUp';
function IsGamepadButtonUp(Gamepad: Integer; Button: TGamepadButton): Boolean;
begin
  Result := Lib_IsGamepadButtonUp(Gamepad, Button);
end;

function Lib_GetGamepadButtonPressed(): TGamepadButton;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetGamepadButtonPressed';
function GetGamepadButtonPressed(): TGamepadButton;
begin
  Result := Lib_GetGamepadButtonPressed();
end;

function Lib_GetGamepadAxisCount(Gamepad: Integer): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetGamepadAxisCount';
function GetGamepadAxisCount(Gamepad: Integer): Integer;
begin
  Result := Lib_GetGamepadAxisCount(Gamepad);
end;

function Lib_GetGamepadAxisMovement(Gamepad: Integer; Axis: TGamepadAxis): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetGamepadAxisMovement';
function GetGamepadAxisMovement(Gamepad: Integer; Axis: TGamepadAxis): Single;
begin
  Result := Lib_GetGamepadAxisMovement(Gamepad, Axis);
end;

function Lib_SetGamepadMappings(const Mappings: PAnsiChar): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetGamepadMappings';
function SetGamepadMappings(const Mappings: PAnsiChar): Integer;
begin
  Result := Lib_SetGamepadMappings(Mappings);
end;

// Input-related functions: mouse

function Lib_IsMouseButtonPressed(Button: TMouseButton): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsMouseButtonPressed';
function IsMouseButtonPressed(Button: TMouseButton): Boolean;
begin
  Result := Lib_IsMouseButtonPressed(Button);
end;

function Lib_IsMouseButtonDown(Button: TMouseButton): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsMouseButtonDown';
function IsMouseButtonDown(Button: TMouseButton): Boolean;
begin
  Result := Lib_IsMouseButtonDown(Button);
end;

function Lib_IsMouseButtonReleased(Button: TMouseButton): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsMouseButtonReleased';
function IsMouseButtonReleased(Button: TMouseButton): Boolean;
begin
  Result := Lib_IsMouseButtonReleased(Button);
end;

function Lib_IsMouseButtonUp(Button: TMouseButton): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsMouseButtonUp';
function IsMouseButtonUp(Button: TMouseButton): Boolean;
begin
  Result := Lib_IsMouseButtonUp(Button);
end;

function Lib_GetMouseX(): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetMouseX';
function GetMouseX(): Integer;
begin
  Result := Lib_GetMouseX();
end;

function Lib_GetMouseY(): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetMouseY';
function GetMouseY(): Integer;
begin
  Result := Lib_GetMouseY();
end;

function Lib_GetMousePosition(): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetMousePosition';
function GetMousePosition(): TVector2;
begin
  Result := TVector2(Lib_GetMousePosition());
end;

function Lib_GetMouseDelta(): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetMouseDelta';
function GetMouseDelta(): TVector2;
begin
  Result := TVector2(Lib_GetMouseDelta());
end;

procedure Lib_SetMousePosition(X, Y: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetMousePosition';
procedure SetMousePosition(X, Y: Integer);
begin
  Lib_SetMousePosition(X, Y);
end;

procedure Lib_SetMouseOffset(OffsetX, OffsetY: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetMouseOffset';
procedure SetMouseOffset(OffsetX, OffsetY: Integer);
begin
  Lib_SetMouseOffset(OffsetX, OffsetY);
end;

procedure Lib_SetMouseScale(ScaleX, ScaleY: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetMouseScale';
procedure SetMouseScale(ScaleX, ScaleY: Single);
begin
  Lib_SetMouseScale(ScaleX, ScaleY);
end;

function Lib_GetMouseWheelMove(): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetMouseWheelMove';
function GetMouseWheelMove(): Single;
begin
  Result := Lib_GetMouseWheelMove();
end;

function Lib_GetMouseWheelMoveV(): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetMouseWheelMoveV';
function GetMouseWheelMoveV(): TVector2;
begin
  Result := TVector2(Lib_GetMouseWheelMoveV());
end;

procedure Lib_SetMouseCursor(Cursor: TMouseCursor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetMouseCursor';
procedure SetMouseCursor(Cursor: TMouseCursor);
begin
  Lib_SetMouseCursor(Cursor);
end;

// Input-related functions: touch

function Lib_GetTouchX(): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetTouchX';
function GetTouchX(): Integer;
begin
  Result := Lib_GetTouchX();
end;

function Lib_GetTouchY(): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetTouchY';
function GetTouchY(): Integer;
begin
  Result := Lib_GetTouchY();
end;

function Lib_GetTouchPosition(Index: Integer): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetTouchPosition';
function GetTouchPosition(Index: Integer): TVector2;
begin
  Result := TVector2(Lib_GetTouchPosition(Index));
end;

function Lib_GetTouchPointId(Index: Integer): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetTouchPointId';
function GetTouchPointId(Index: Integer): Integer;
begin
  Result := Lib_GetTouchPointId(Index);
end;

function Lib_GetTouchPointCount(): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetTouchPointCount';
function GetTouchPointCount(): Integer;
begin
  Result := Lib_GetTouchPointCount();
end;

// Gestures and Touch Handling Functions (Module: rgestures)

procedure Lib_SetGesturesEnabled(Flags: TGesture);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetGesturesEnabled';
procedure SetGesturesEnabled(Flags: TGesture);
begin
  Lib_SetGesturesEnabled(Flags);
end;

function Lib_IsGestureDetected(Gesture: TGesture): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsGestureDetected';
function IsGestureDetected(Gesture: TGesture): Boolean;
begin
  Result := Lib_IsGestureDetected(Gesture);
end;

function Lib_GetGestureDetected(): TGesture;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetGestureDetected';
function GetGestureDetected(): TGesture;
begin
  Result := Lib_GetGestureDetected();
end;

function Lib_GetGestureHoldDuration(): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetGestureHoldDuration';
function GetGestureHoldDuration(): Single;
begin
  Result := Lib_GetGestureHoldDuration();
end;

function Lib_GetGestureDragVector(): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetGestureDragVector';
function GetGestureDragVector(): TVector2;
begin
  Result := TVector2(Lib_GetGestureDragVector());
end;

function Lib_GetGestureDragAngle(): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetGestureDragAngle';
function GetGestureDragAngle(): Single;
begin
  Result := Lib_GetGestureDragAngle();
end;

function Lib_GetGesturePinchVector(): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetGesturePinchVector';
function GetGesturePinchVector(): TVector2;
begin
  Result := TVector2(Lib_GetGesturePinchVector());
end;

function Lib_GetGesturePinchAngle(): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetGesturePinchAngle';
function GetGesturePinchAngle(): Single;
begin
  Result := Lib_GetGesturePinchAngle();
end;

// Camera System Functions (Module: rcamera)

procedure Lib_UpdateCamera(Camera: PCamera; Mode: TCameraMode);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UpdateCamera';
procedure UpdateCamera(Camera: PCamera; Mode: TCameraMode);
begin
  Lib_UpdateCamera(Camera, Mode);
end;

procedure Lib_UpdateCameraPro(Camera: PCamera; Movement, Rotation, Zoom: TVector3);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UpdateCameraPro';
procedure UpdateCameraPro(Camera: PCamera; Movement, Rotation, Zoom: TVector3);
begin
  Lib_UpdateCameraPro(Camera, Movement, Rotation, Zoom);
end;

function Lib_GetCameraForward(Camera: PCamera): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetCameraForward';
function GetCameraForward(Camera: PCamera): TVector3;
begin
  Result := Lib_GetCameraForward(Camera);
end;

function Lib_GetCameraUp(Camera: PCamera): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetCameraUp';
function GetCameraUp(Camera: PCamera): TVector3;
begin
  Result := Lib_GetCameraUp(Camera);
end;

function Lib_GetCameraRight(Camera: PCamera): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetCameraRight';
function GetCameraRight(Camera: PCamera): TVector3;
begin
  Result := Lib_GetCameraRight(Camera);
end;

procedure Lib_CameraMoveForward(Camera: PCamera; Distance: Single; MoveInWorldPlane: Boolean);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CameraMoveForward';
procedure CameraMoveForward(Camera: PCamera; Distance: Single; MoveInWorldPlane: Boolean);
begin
  Lib_CameraMoveForward(Camera, Distance, MoveInWorldPlane);
end;
procedure Lib_CameraMoveUp(Camera: PCamera; Distance: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CameraMoveUp';
procedure CameraMoveUp(Camera: PCamera; Distance: Single);
begin
  Lib_CameraMoveUp(Camera, Distance);
end;
procedure Lib_CameraMoveRight(Camera: PCamera; Distance: Single; MoveInWorldPlane: Boolean);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CameraMoveRight';
procedure CameraMoveRight(Camera: PCamera; Distance: Single; MoveInWorldPlane: Boolean);
begin
  Lib_CameraMoveRight(Camera, Distance, MoveInWorldPlane);
end;
procedure Lib_CameraMoveToTarget(Camera: PCamera; Delta: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CameraMoveToTarget';
procedure CameraMoveToTarget(Camera: PCamera; Delta: Single);
begin
  Lib_CameraMoveToTarget(Camera, Delta);
end;
procedure Lib_CameraYaw(Camera: PCamera; Angle: Single; RotateAroundTarget: Boolean);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CameraYaw';
procedure CameraYaw(Camera: PCamera; Angle: Single; RotateAroundTarget: Boolean);
begin
  Lib_CameraYaw(Camera, Angle, RotateAroundTarget);
end;
procedure Lib_CameraPitch(Camera: PCamera; Angle: Single; LockView: Boolean; RotateAroundTarget, RotateUp: Boolean);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CameraPitch';
procedure CameraPitch(Camera: PCamera; Angle: Single; LockView: Boolean; RotateAroundTarget, RotateUp: Boolean);
begin
  Lib_CameraPitch(Camera, Angle, LockView, RotateAroundTarget, RotateUp);
end;
procedure Lib_CameraRoll(Camera: PCamera; Angle: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CameraRoll';
procedure CameraRoll(Camera: PCamera; Angle: Single);
begin
  Lib_CameraRoll(Camera, Angle);
end;
function Lib_GetCameraViewMatrix(Camera: PCamera): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetCameraViewMatrix';
function GetCameraViewMatrix(Camera: PCamera): TMatrix;
begin
  Result := Lib_GetCameraViewMatrix(Camera);
end;
function Lib_GetCameraProjectionMatrix(Camera: PCamera; Aspect: Single): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetCameraProjectionMatrix';
function GetCameraProjectionMatrix(Camera: PCamera; Aspect: Single): TMatrix;
begin
  Result := Lib_GetCameraProjectionMatrix(Camera, Aspect);
end;

// Set texture and rectangle to be used on shapes drawing

procedure Lib_SetShapesTexture(Texture: TTexture2D; Source: TRectangle);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetShapesTexture';
procedure SetShapesTexture(Texture: TTexture2D; Source: TRectangle);
begin
  Lib_SetShapesTexture(Texture, Source);
end;

// Basic shapes drawing functions

procedure Lib_DrawPixel(PosX, PosY: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawPixel';
procedure DrawPixel(PosX, PosY: Integer; Color: TColor);
begin
  Lib_DrawPixel(PosX, PosY, Color);
end;

procedure Lib_DrawPixelV(Position: TVector2; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawPixelV';
procedure DrawPixelV(Position: TVector2; Color: TColor);
begin
  Lib_DrawPixelV(Position, Color);
end;

procedure Lib_DrawLine(StartPosX, StartPosY, EndPosX, EndPosY: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawLine';
procedure DrawLine(StartPosX, StartPosY, EndPosX, EndPosY: Integer; Color: TColor);
begin
  Lib_DrawLine(StartPosX, StartPosY, EndPosX, EndPosY, Color);
end;

procedure Lib_DrawLineV(StartPos, EndPos: TVector2; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawLineV';
procedure DrawLineV(StartPos, EndPos: TVector2; Color: TColor);
begin
  Lib_DrawLineV(StartPos, EndPos, Color);
end;

procedure Lib_DrawLineEx(StartPos, EndPos: TVector2; Thick: Single; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawLineEx';
procedure DrawLineEx(StartPos, EndPos: TVector2; Thick: Single; Color: TColor);
begin
  Lib_DrawLineEx(StartPos, EndPos, Thick, Color);
end;

procedure Lib_DrawLineBezier(StartPos, EndPos: TVector2; Thick: Single; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawLineBezier';
procedure DrawLineBezier(StartPos, EndPos: TVector2; Thick: Single; Color: TColor);
begin
  Lib_DrawLineBezier(StartPos, EndPos, Thick, Color);
end;

procedure Lib_DrawLineBezierQuad(StartPos, EndPos, ControlPos: TVector2; Thick: Single; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawLineBezierQuad';
procedure DrawLineBezierQuad(StartPos, EndPos, ControlPos: TVector2; Thick: Single; Color: TColor);
begin
  Lib_DrawLineBezierQuad(StartPos, EndPos, ControlPos, Thick, Color);
end;

procedure Lib_DrawLineBezierCubic(StartPos, EndPos, StartControlPos, EndControlPos: TVector2; Thick: Single; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawLineBezierCubic';
procedure DrawLineBezierCubic(StartPos, EndPos, StartControlPos, EndControlPos: TVector2; Thick: Single; Color: TColor);
begin
  Lib_DrawLineBezierCubic(StartPos, EndPos, StartControlPos, EndControlPos, Thick, Color);
end;

procedure Lib_DrawLineStrip(Points: PVector2; PointCount: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawLineStrip';
procedure DrawLineStrip(Points: PVector2; PointCount: Integer; Color: TColor);
begin
  Lib_DrawLineStrip(Points, PointCount, Color);
end;

procedure Lib_DrawCircle(CenterX, CenterY: Integer; Radius: Single; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawCircle';
procedure DrawCircle(CenterX, CenterY: Integer; Radius: Single; Color: TColor);
begin
  Lib_DrawCircle(CenterX, CenterY,  Radius, Color);
end;

procedure Lib_DrawCircleSector(Center: TVector2; Radius, StartAngle, EndAngle: Single; Segments: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawCircleSector';
procedure DrawCircleSector(Center: TVector2; Radius, StartAngle, EndAngle: Single; Segments: Integer; Color: TColor);
begin
  Lib_DrawCircleSector(Center, Radius, StartAngle, EndAngle, Segments, Color);
end;

procedure Lib_DrawCircleSectorLines(Center: TVector2; Radius, StartAngle, EndAngle: Single; Segments: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawCircleSectorLines';
procedure DrawCircleSectorLines(Center: TVector2; Radius, StartAngle, EndAngle: Single; Segments: Integer; Color: TColor);
begin
  Lib_DrawCircleSectorLines(Center, Radius, StartAngle, EndAngle, Segments, Color);
end;

procedure Lib_DrawCircleGradient(CenterX, CenterY: Integer; Radius: Single; Color1, Color2: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawCircleGradient';
procedure DrawCircleGradient(CenterX, CenterY: Integer; Radius: Single; Color1, Color2: TColor);
begin
  Lib_DrawCircleGradient(CenterX, CenterY, Radius, Color1, Color2);
end;

procedure Lib_DrawCircleV(Center: TVector2; Radius: Single; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawCircleV';
procedure DrawCircleV(Center: TVector2; Radius: Single; Color: TColor);
begin
  Lib_DrawCircleV(Center, Radius, Color);
end;

procedure Lib_DrawCircleLines(CenterX, CenterY: Integer; Radius: Single; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawCircleLines';
procedure DrawCircleLines(CenterX, CenterY: Integer; Radius: Single; Color: TColor);
begin
  Lib_DrawCircleLines(CenterX, CenterY, Radius, Color);
end;

procedure Lib_DrawEllipse(CenterX, CenterY: Integer; RadiusH, RadiusV: Single; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawEllipse';
procedure DrawEllipse(CenterX, CenterY: Integer; RadiusH, RadiusV: Single; Color: TColor);
begin
  Lib_DrawEllipse(CenterX, CenterY, RadiusH, RadiusV, Color);
end;

procedure Lib_DrawEllipseLines(CenterX, CenterY: Integer; RadiusH, RadiusV: Single; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawEllipseLines';
procedure DrawEllipseLines(CenterX, CenterY: Integer; RadiusH, RadiusV: Single; Color: TColor);
begin
  Lib_DrawEllipseLines(CenterX, CenterY, RadiusH, RadiusV, Color);
end;

procedure Lib_DrawRing(Center: TVector2; InnerRadius, OuterRadius, StartAngle, EndAngle: Single; Segments: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawRing';
procedure DrawRing(Center: TVector2; InnerRadius, OuterRadius, StartAngle, EndAngle: Single; Segments: Integer; Color: TColor);
begin
  Lib_DrawRing(Center, InnerRadius, OuterRadius, StartAngle, EndAngle, Segments, Color);
end;

procedure Lib_DrawRingLines(Center: TVector2; InnerRadius, OuterRadius, StartAngle, EndAngle: Single; Segments: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawRingLines';
procedure DrawRingLines(Center: TVector2; InnerRadius, OuterRadius, StartAngle, EndAngle: Single; Segments: Integer; Color: TColor);
begin
  Lib_DrawRingLines(Center, InnerRadius, OuterRadius, StartAngle, EndAngle, Segments, Color);
end;

procedure Lib_DrawRectangle(PosX, PosY, Width, Height: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawRectangle';
procedure DrawRectangle(PosX, PosY, Width, Height: Integer; Color: TColor);
begin
  Lib_DrawRectangle(PosX, PosY, Width, Height, Color);
end;

procedure Lib_DrawRectangleV(Position, Size: TVector2; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawRectangleV';
procedure DrawRectangleV(Position, Size: TVector2; Color: TColor);
begin
  Lib_DrawRectangleV(Position, Size, Color);
end;

procedure Lib_DrawRectangleRec(Rec: TRectangle; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawRectangleRec';
procedure DrawRectangleRec(Rec: TRectangle; Color: TColor);
begin
  Lib_DrawRectangleRec(Rec, Color);
end;

procedure Lib_DrawRectanglePro(Rec: TRectangle; Origin: TVector2; Rotation: Single; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawRectanglePro';
procedure DrawRectanglePro(Rec: TRectangle; Origin: TVector2; Rotation: Single; Color: TColor);
begin
  Lib_DrawRectanglePro(Rec, Origin, Rotation, Color);
end;

procedure Lib_DrawRectangleGradientV(PosX, PosY, Width, Height: Integer; Color1, Color2: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawRectangleGradientV';
procedure DrawRectangleGradientV(PosX, PosY, Width, Height: Integer; Color1, Color2: TColor);
begin
  Lib_DrawRectangleGradientV(PosX, PosY, Width, Height, Color1, Color2);
end;

procedure Lib_DrawRectangleGradientH(PosX, PosY, Width, Height: Integer; Color1, Color2: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawRectangleGradientH';
procedure DrawRectangleGradientH(PosX, PosY, Width, Height: Integer; Color1, Color2: TColor);
begin
  Lib_DrawRectangleGradientH(PosX, PosY, Width, Height, Color1, Color2);
end;

procedure Lib_DrawRectangleGradientEx(Rec: TRectangle; Col1, Col2, Col3, Col4: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawRectangleGradientEx';
procedure DrawRectangleGradientEx(Rec: TRectangle; Col1, Col2, Col3, Col4: TColor);
begin
  Lib_DrawRectangleGradientEx(Rec, Col1, Col2, Col3, Col4);
end;

procedure Lib_DrawRectangleLines(PosX, PosY, Width, Height: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawRectangleLines';
procedure DrawRectangleLines(PosX, PosY, Width, Height: Integer; Color: TColor);
begin
  Lib_DrawRectangleLines(PosX, PosY, Width, Height, Color);
end;

procedure Lib_DrawRectangleLinesEx(Rec: TRectangle; LineThick: Single; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawRectangleLinesEx';
procedure DrawRectangleLinesEx(Rec: TRectangle; LineThick: Single; Color: TColor);
begin
  Lib_DrawRectangleLinesEx(Rec, LineThick, Color);
end;

procedure Lib_DrawRectangleRounded(Rec: TRectangle; Roundness: Single; Segments: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawRectangleRounded';
procedure DrawRectangleRounded(Rec: TRectangle; Roundness: Single; Segments: Integer; Color: TColor);
begin
  Lib_DrawRectangleRounded(Rec, Roundness, Segments, Color);
end;

procedure Lib_DrawRectangleRoundedLines(Rec: TRectangle; Roundness: Single; Segments: Integer; LineThick: Single; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawRectangleRoundedLines';
procedure DrawRectangleRoundedLines(Rec: TRectangle; Roundness: Single; Segments: Integer; LineThick: Single; Color: TColor);
begin
  Lib_DrawRectangleRoundedLines(Rec, Roundness, Segments, LineThick, Color);
end;

procedure Lib_DrawTriangle(V1, V2, V3: TVector2; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawTriangle';
procedure DrawTriangle(V1, V2, V3: TVector2; Color: TColor);
begin
  Lib_DrawTriangle(V1, V2, V3, Color);
end;

procedure Lib_DrawTriangleLines(V1, V2, V3: TVector2; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawTriangleLines';
procedure DrawTriangleLines(V1, V2, V3: TVector2; Color: TColor);
begin
  Lib_DrawTriangleLines(V1, V2, V3, Color);
end;

procedure Lib_DrawTriangleFan(Points: PVector2; PointCount: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawTriangleFan';
procedure DrawTriangleFan(Points: PVector2; PointCount: Integer; Color: TColor);
begin
  Lib_DrawTriangleFan(Points, PointCount, Color);
end;

procedure Lib_DrawTriangleStrip(Points: PVector2; PointCount: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawTriangleStrip';
procedure DrawTriangleStrip(Points: PVector2; PointCount: Integer; Color: TColor);
begin
  Lib_DrawTriangleStrip(Points, PointCount, Color);
end;

procedure Lib_DrawPoly(Center: TVector2; Sides: Integer; Radius: Single; Rotation: Single; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawPoly';
procedure DrawPoly(Center: TVector2; Sides: Integer; Radius: Single; Rotation: Single; Color: TColor);
begin
  Lib_DrawPoly(Center, Sides, Radius, Rotation, Color);
end;

procedure Lib_DrawPolyLines(Center: TVector2; Sides: Integer; Radius, Rotation: Single; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawPolyLines';
procedure DrawPolyLines(Center: TVector2; Sides: Integer; Radius, Rotation: Single; Color: TColor);
begin
  Lib_DrawPolyLines(Center, Sides, Radius, Rotation, Color);
end;

procedure Lib_DrawPolyLinesEx(Center: TVector2; Sides: Integer; Radius, Rotation, LineThick: Single; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawPolyLinesEx';
procedure DrawPolyLinesEx(Center: TVector2; Sides: Integer; Radius, Rotation, LineThick: Single; Color: TColor);
begin
  Lib_DrawPolyLinesEx(Center, Sides, Radius, Rotation, LineThick, Color);
end;

// Basic shapes collision detection functions

function Lib_CheckCollisionRecs(Rec1, Rec2: TRectangle): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CheckCollisionRecs';
function CheckCollisionRecs(Rec1, Rec2: TRectangle): Boolean;
begin
  Result := Lib_CheckCollisionRecs(Rec1, Rec2);
end;

function Lib_CheckCollisionCircles(Center1: TVector2; Radius1: Single; Center2: TVector2; Radius2: Single): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CheckCollisionCircles';
function CheckCollisionCircles(Center1: TVector2; Radius1: Single; Center2: TVector2; Radius2: Single): Boolean;
begin
  Result := Lib_CheckCollisionCircles(Center1, Radius1, Center2, Radius2);
end;

function Lib_CheckCollisionCircleRec(Center: TVector2; Radius: Single; Rec: TRectangle): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CheckCollisionCircleRec';
function CheckCollisionCircleRec(Center: TVector2; Radius: Single; Rec: TRectangle): Boolean;
begin
  Result := Lib_CheckCollisionCircleRec(Center, Radius, Rec);
end;

function Lib_CheckCollisionPointRec(Point: TVector2; Rec: TRectangle): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CheckCollisionPointRec';
function CheckCollisionPointRec(Point: TVector2; Rec: TRectangle): Boolean;
begin
  Result := Lib_CheckCollisionPointRec(Point, Rec);
end;

function Lib_CheckCollisionPointCircle(Point, Center: TVector2; Radius: Single): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CheckCollisionPointCircle';
function CheckCollisionPointCircle(Point, Center: TVector2; Radius: Single): Boolean;
begin
  Result := Lib_CheckCollisionPointCircle(Point, Center, Radius);
end;

function Lib_CheckCollisionPointTriangle(Point, P1, P2, P3: TVector2): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CheckCollisionPointTriangle';
function CheckCollisionPointTriangle(Point, P1, P2, P3: TVector2): Boolean;
begin
  Result := Lib_CheckCollisionPointTriangle(Point, P1, P2, P3);
end;

function Lib_CheckCollisionPointPoly(Point: TVector2; Points: PVector2; PointCount: Integer): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CheckCollisionPointPoly';
function CheckCollisionPointPoly(Point: TVector2; Points: PVector2; PointCount: Integer): Boolean;
begin
  Result := Lib_CheckCollisionPointPoly(Point, Points, PointCount);
end;

function Lib_CheckCollisionLines(StartPos1, EndPos1, StartPos2, EndPos2: TVector2; CollisionPoint: PVector2): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CheckCollisionLines';
function CheckCollisionLines(StartPos1, EndPos1, StartPos2, EndPos2: TVector2; CollisionPoint: PVector2): Boolean;
begin
  Result := Lib_CheckCollisionLines(StartPos1, EndPos1, StartPos2, EndPos2, CollisionPoint);
end;

function Lib_CheckCollisionPointLine(Point, P1, P2: TVector2; Threshold: Integer): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CheckCollisionPointLine';
function CheckCollisionPointLine(Point, P1, P2: TVector2; Threshold: Integer): Boolean;
begin
  Result := Lib_CheckCollisionPointLine(Point, P1, P2, Threshold);
end;

function Lib_GetCollisionRec(Rec1, Rec2: TRectangle): TRectangle;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetCollisionRec';
function GetCollisionRec(Rec1, Rec2: TRectangle): TRectangle;
begin
  Result := Lib_GetCollisionRec(Rec1, Rec2);
end;

// Image loading functions

function Lib_LoadImage(const FileName: PAnsiChar): TImage;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadImage';
function LoadImage(const FileName: PAnsiChar): TImage;
begin
  Result := Lib_LoadImage(FileName);
end;

function Lib_LoadImageRaw(const FileName: PAnsiChar; Width, Height: Integer; Format: TPixelFormat; HeaderSize: Integer): TImage;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadImageRaw';
function LoadImageRaw(const FileName: PAnsiChar; Width, Height: Integer; Format: TPixelFormat; HeaderSize: Integer): TImage;
begin
  Result := Lib_LoadImageRaw(FileName, Width, Height, Format, HeaderSize);
end;

function Lib_LoadImageAnim(const FileName: PAnsiChar; Frames: PInteger): TImage;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadImageAnim';
function LoadImageAnim(const FileName: PAnsiChar; Frames: PInteger): TImage;
begin
  Result := Lib_LoadImageAnim(FileName, Frames);
end;

function Lib_LoadImageFromMemory(const FileType: PAnsiChar; const FileData: PByte; DataSize: Integer): TImage;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadImageFromMemory';
function LoadImageFromMemory(const FileType: PAnsiChar; const FileData: PByte; DataSize: Integer): TImage;
begin
  Result := Lib_LoadImageFromMemory(FileType, FileData, DataSize);
end;

function Lib_LoadImageFromTexture(Texture: TTexture2D): TImage;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadImageFromTexture';
function LoadImageFromTexture(Texture: TTexture2D): TImage;
begin
  Result := Lib_LoadImageFromTexture(Texture);
end;

function Lib_LoadImageFromScreen(): TImage;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadImageFromScreen';
function LoadImageFromScreen(): TImage;
begin
  Result := Lib_LoadImageFromScreen();
end;

function Lib_IsImageReady(Image: TImage): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsImageReady';
function IsImageReady(Image: TImage): Boolean;
begin
  Result := Lib_IsImageReady(Image);
end;

procedure Lib_UnloadImage(Image: TImage);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadImage';
procedure UnloadImage(Image: TImage);
begin
  Lib_UnloadImage(Image);
end;

function Lib_ExportImage(Image: TImage; const FileName: PAnsiChar): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ExportImage';
function ExportImage(Image: TImage; const FileName: PAnsiChar): Boolean;
begin
  Result := Lib_ExportImage(Image, FileName);
end;

function Lib_ExportImageAsCode(Image: TImage; const FileName: PAnsiChar): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ExportImageAsCode';
function ExportImageAsCode(Image: TImage; const FileName: PAnsiChar): Boolean;
begin
  Result := Lib_ExportImageAsCode(Image, FileName);
end;

// Image generation functions

function Lib_GenImageColor(Width, Height: Integer; Color: TColor): TImage;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenImageColor';
function GenImageColor(Width, Height: Integer; Color: TColor): TImage;
begin
  Result := Lib_GenImageColor(Width, Height, Color);
end;

function Lib_GenImageGradientV(Width, Height: Integer; Top, Bottom: TColor): TImage;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenImageGradientV';
function GenImageGradientV(Width, Height: Integer; Top, Bottom: TColor): TImage;
begin
  Result := Lib_GenImageGradientV(Width, Height, Top, Bottom);
end;

function Lib_GenImageGradientH(Width, Height: Integer; Left, Right: TColor): TImage;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenImageGradientH';
function GenImageGradientH(Width, Height: Integer; Left, Right: TColor): TImage;
begin
  Result := Lib_GenImageGradientH(Width, Height, Left, Right);
end;

function Lib_GenImageGradientRadial(Width, Height: Integer; Density: Single; Inner, Outer: TColor): TImage;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenImageGradientRadial';
function GenImageGradientRadial(Width, Height: Integer; Density: Single; Inner, Outer: TColor): TImage;
begin
  Result := Lib_GenImageGradientRadial(Width, Height, Density, Inner, Outer);
end;

function Lib_GenImageChecked(Width, Height, ChecksX, ChecksY: Integer; Col1, Col2: TColor): TImage;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenImageChecked';
function GenImageChecked(Width, Height, ChecksX, ChecksY: Integer; Col1, Col2: TColor): TImage;
begin
  Result := Lib_GenImageChecked(Width, Height, ChecksX, ChecksY, Col1, Col2);
end;

function Lib_GenImageWhiteNoise(Width, Height: Integer; Factor: Single): TImage;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenImageWhiteNoise';
function GenImageWhiteNoise(Width, Height: Integer; Factor: Single): TImage;
begin
  Result := Lib_GenImageWhiteNoise(Width, Height, Factor);
end;

function Lib_GenImagePerlinNoise(Width, Height, OffsetX, OffsetY: Integer; Scale: Single): TImage;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenImagePerlinNoise';
function GenImagePerlinNoise(Width, Height, OffsetX, OffsetY: Integer; Scale: Single): TImage;
begin
  Result := Lib_GenImagePerlinNoise(Width, Height, OffsetX, OffsetY, Scale);
end;

function Lib_GenImageCellular(Width, Height, TileSize: Integer): TImage;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenImageCellular';
function GenImageCellular(Width, Height, TileSize: Integer): TImage;
begin
  Result := Lib_GenImageCellular(Width, Height, TileSize);
end;

function Lib_GenImageText(Width, Height: Integer; const Text: PAnsiChar): TImage;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenImageText';
function GenImageText(Width, Height: Integer; const Text: PAnsiChar): TImage;
begin
  Result := Lib_GenImageText(Width, Height, Text);
end;

// Image manipulation functions

function Lib_ImageCopy(Image: TImage): TImage;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageCopy';
function ImageCopy(Image: TImage): TImage;
begin
  Result := Lib_ImageCopy(Image);
end;

function Lib_ImageFromImage(Image: TImage; Rec: TRectangle): TImage;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageFromImage';
function ImageFromImage(Image: TImage; Rec: TRectangle): TImage;
begin
  Result := Lib_ImageFromImage(Image, Rec);
end;

function Lib_ImageText(const Text: PAnsiChar; FontSize: Integer; Color: TColor): TImage;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageText';
function ImageText(const Text: PAnsiChar; FontSize: Integer; Color: TColor): TImage;
begin
  Result := Lib_ImageText(Text, FontSize, Color);
end;

function Lib_ImageTextEx(Font: TFont; const Text: PAnsiChar; FontSize, Spacing: Single; Tint: TColor): TImage;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageTextEx';
function ImageTextEx(Font: TFont; const Text: PAnsiChar; FontSize, Spacing: Single; Tint: TColor): TImage;
begin
  Result := Lib_ImageTextEx(Font, Text, FontSize, Spacing, Tint);
end;

procedure Lib_ImageFormat(Image: PImage; NewFormat: TPixelFormat);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageFormat';
procedure ImageFormat(Image: PImage; NewFormat: TPixelFormat);
begin
  Lib_ImageFormat(Image, NewFormat);
end;

procedure Lib_ImageToPOT(Image: PImage; Fill: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageToPOT';
procedure ImageToPOT(Image: PImage; Fill: TColor);
begin
  Lib_ImageToPOT(Image, Fill);
end;

procedure Lib_ImageCrop(Image: PImage; Crop: TRectangle);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageCrop';
procedure ImageCrop(Image: PImage; Crop: TRectangle);
begin
  Lib_ImageCrop(Image, Crop);
end;

procedure Lib_ImageAlphaCrop(Image: PImage; Threshold: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageAlphaCrop';
procedure ImageAlphaCrop(Image: PImage; Threshold: Single);
begin
  Lib_ImageAlphaCrop(Image, Threshold);
end;

procedure Lib_ImageAlphaClear(Image: PImage; Color: TColor; Threshold: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageAlphaClear';
procedure ImageAlphaClear(Image: PImage; Color: TColor; Threshold: Single);
begin
  Lib_ImageAlphaClear(Image, Color, Threshold);
end;

procedure Lib_ImageAlphaMask(Image: PImage; AlphaMask: TImage);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageAlphaMask';
procedure ImageAlphaMask(Image: PImage; AlphaMask: TImage);
begin
  Lib_ImageAlphaMask(Image, AlphaMask);
end;

procedure Lib_ImageAlphaPremultiply(Image: PImage);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageAlphaPremultiply';
procedure ImageAlphaPremultiply(Image: PImage);
begin
  Lib_ImageAlphaPremultiply(Image);
end;

procedure Lib_ImageBlurGaussian(Image: PImage; BlurSize: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageBlurGaussian';
procedure ImageBlurGaussian(Image: PImage; BlurSize: Integer);
begin
  Lib_ImageBlurGaussian(Image, BlurSize);
end;

procedure Lib_ImageResize(Image: PImage; NewWidth, NewHeight: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageResize';
procedure ImageResize(Image: PImage; NewWidth, NewHeight: Integer);
begin
  Lib_ImageResize(Image, NewWidth, NewHeight);
end;

procedure Lib_ImageResizeNN(Image: PImage; NewWidth, NewHeight: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageResizeNN';
procedure ImageResizeNN(Image: PImage; NewWidth, NewHeight: Integer);
begin
  Lib_ImageResizeNN(Image, NewWidth, NewHeight);
end;

procedure Lib_ImageResizeCanvas(Image: PImage; NewWidth, NewHeight, OffsetX, OffsetY: Integer; Fill: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageResizeCanvas';
procedure ImageResizeCanvas(Image: PImage; NewWidth, NewHeight, OffsetX, OffsetY: Integer; Fill: TColor);
begin
  Lib_ImageResizeCanvas(Image, NewWidth, NewHeight, OffsetX, OffsetY, Fill);
end;

procedure Lib_ImageMipmaps(Image: PImage);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageMipmaps';
procedure ImageMipmaps(Image: PImage);
begin
  Lib_ImageMipmaps(Image);
end;

procedure Lib_ImageDither(Image: PImage; RBpp, GBpp, BBpp, ABpp: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageDither';
procedure ImageDither(Image: PImage; RBpp, GBpp, BBpp, ABpp: Integer);
begin
  Lib_ImageDither(Image, RBpp, GBpp, BBpp, ABpp);
end;

procedure Lib_ImageFlipVertical(Image: PImage);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageFlipVertical';
procedure ImageFlipVertical(Image: PImage);
begin
  Lib_ImageFlipVertical(Image);
end;

procedure Lib_ImageFlipHorizontal(Image: PImage);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageFlipHorizontal';
procedure ImageFlipHorizontal(Image: PImage);
begin
  Lib_ImageFlipHorizontal(Image);
end;

procedure Lib_ImageRotateCW(Image: PImage);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageRotateCW';
procedure ImageRotateCW(Image: PImage);
begin
  Lib_ImageRotateCW(Image);
end;

procedure Lib_ImageRotateCCW(Image: PImage);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageRotateCCW';
procedure ImageRotateCCW(Image: PImage);
begin
  Lib_ImageRotateCCW(Image);
end;

procedure Lib_ImageColorTint(Image: PImage; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageColorTint';
procedure ImageColorTint(Image: PImage; Color: TColor);
begin
  Lib_ImageColorTint(Image, Color);
end;

procedure Lib_ImageColorInvert(Image: PImage);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageColorInvert';
procedure ImageColorInvert(Image: PImage);
begin
  Lib_ImageColorInvert(Image);
end;

procedure Lib_ImageColorGrayscale(Image: PImage);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageColorGrayscale';
procedure ImageColorGrayscale(Image: PImage);
begin
  Lib_ImageColorGrayscale(Image);
end;

procedure Lib_ImageColorContrast(Image: PImage; Contrast: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageColorContrast';
procedure ImageColorContrast(Image: PImage; Contrast: Single);
begin
  Lib_ImageColorContrast(Image, Contrast);
end;

procedure Lib_ImageColorBrightness(Image: PImage; Brightness: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageColorBrightness';
procedure ImageColorBrightness(Image: PImage; Brightness: Integer);
begin
  Lib_ImageColorBrightness(Image, Brightness);
end;

procedure Lib_ImageColorReplace(Image: PImage; Color, Replace: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageColorReplace';
procedure ImageColorReplace(Image: PImage; Color, Replace: TColor);
begin
  Lib_ImageColorReplace(Image, Color, Replace);
end;

function Lib_LoadImageColors(Image: TImage): PColor;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadImageColors';
function LoadImageColors(Image: TImage): PColor;
begin
  Result := Lib_LoadImageColors(Image);
end;

function Lib_LoadImagePalette(Image: TImage; MaxPaletteSize: Integer; ColorCount: PInteger): PColor;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadImagePalette';
function LoadImagePalette(Image: TImage; MaxPaletteSize: Integer; ColorCount: PInteger): PColor;
begin
  Result := Lib_LoadImagePalette(Image, MaxPaletteSize, ColorCount);
end;

procedure Lib_UnloadImageColors(Colors: PColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadImageColors';
procedure UnloadImageColors(Colors: PColor);
begin
  Lib_UnloadImageColors(Colors);
end;

procedure Lib_UnloadImagePalette(Colors: PColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadImagePalette';
procedure UnloadImagePalette(Colors: PColor);
begin
  Lib_UnloadImagePalette(Colors);
end;

function Lib_GetImageAlphaBorder(Image: TImage; Threshold: Single): TRectangle;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetImageAlphaBorder';
function GetImageAlphaBorder(Image: TImage; Threshold: Single): TRectangle;
begin
  Result := Lib_GetImageAlphaBorder(Image, Threshold);
end;

function Lib_GetImageColor(Image: TImage; X, Y: Integer): {$IFNDEF RET_TRICK}TColor{$ELSE}UInt32{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetImageColor';
function GetImageColor(Image: TImage; X, Y: Integer): TColor;
begin
  Result := TColor(Lib_GetImageColor(Image, X, Y));
end;

// Image drawing functions

procedure Lib_ImageClearBackground(Dst: PImage; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageClearBackground';
procedure ImageClearBackground(Dst: PImage; Color: TColor);
begin
  Lib_ImageClearBackground(Dst, Color);
end;

procedure Lib_ImageDrawPixel(Dst: PImage; PosX, PosY: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageDrawPixel';
procedure ImageDrawPixel(Dst: PImage; PosX, PosY: Integer; Color: TColor);
begin
  Lib_ImageDrawPixel(Dst, PosX, PosY, Color);
end;

procedure Lib_ImageDrawPixelV(Dst: PImage; Position: TVector2; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageDrawPixelV';
procedure ImageDrawPixelV(Dst: PImage; Position: TVector2; Color: TColor);
begin
  Lib_ImageDrawPixelV(Dst, Position, Color);
end;

procedure Lib_ImageDrawLine(Dst: PImage; StartPosX, StartPosY, EndPosX, EndPosY: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageDrawLine';
procedure ImageDrawLine(Dst: PImage; StartPosX, StartPosY, EndPosX, EndPosY: Integer; Color: TColor);
begin
  Lib_ImageDrawLine(Dst, StartPosX, StartPosY, EndPosX, EndPosY, Color);
end;

procedure Lib_ImageDrawLineV(Dst: PImage; Start, End_: TVector2; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageDrawLineV';
procedure ImageDrawLineV(Dst: PImage; Start, End_: TVector2; Color: TColor);
begin
  Lib_ImageDrawLineV(Dst, Start, End_, Color);
end;

procedure Lib_ImageDrawCircle(Dst: PImage; CenterX, CenterY, Radius: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageDrawCircle';
procedure ImageDrawCircle(Dst: PImage; CenterX, CenterY, Radius: Integer; Color: TColor);
begin
  Lib_ImageDrawCircle(Dst, CenterX, CenterY, Radius, Color);
end;

procedure Lib_ImageDrawCircleV(Dst: PImage; Center: TVector2; Radius: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageDrawCircleV';
procedure ImageDrawCircleV(Dst: PImage; Center: TVector2; Radius: Integer; Color: TColor);
begin
  Lib_ImageDrawCircleV(Dst, Center, Radius, Color);
end;

procedure Lib_ImageDrawCircleLines(Dst: PImage; CenterX, CenterY, Radius: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageDrawCircleLines';
procedure ImageDrawCircleLines(Dst: PImage; CenterX, CenterY, Radius: Integer; Color: TColor);
begin
  Lib_ImageDrawCircleLines(Dst, CenterX, CenterY, Radius, Color);
end;

procedure Lib_ImageDrawCircleLinesV(Dst: PImage; Center: TVector2; Radius: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageDrawCircleLinesV';
procedure ImageDrawCircleLinesV(Dst: PImage; Center: TVector2; Radius: Integer; Color: TColor);
begin
  Lib_ImageDrawCircleLinesV(Dst, Center, Radius, Color);
end;

procedure Lib_ImageDrawRectangle(Dst: PImage; PosX, PosY, Width, Height: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageDrawRectangle';
procedure ImageDrawRectangle(Dst: PImage; PosX, PosY, Width, Height: Integer; Color: TColor);
begin
  Lib_ImageDrawRectangle(Dst, PosX, PosY, Width, Height, Color);
end;

procedure Lib_ImageDrawRectangleV(Dst: PImage; Position, Size: TVector2; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageDrawRectangleV';
procedure ImageDrawRectangleV(Dst: PImage; Position, Size: TVector2; Color: TColor);
begin
  Lib_ImageDrawRectangleV(Dst, Position, Size, Color);
end;

procedure Lib_ImageDrawRectangleRec(Dst: PImage; Rec: TRectangle; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageDrawRectangleRec';
procedure ImageDrawRectangleRec(Dst: PImage; Rec: TRectangle; Color: TColor);
begin
  Lib_ImageDrawRectangleRec(Dst, Rec, Color);
end;

procedure Lib_ImageDrawRectangleLines(Dst: PImage; Rec: TRectangle; Thick: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageDrawRectangleLines';
procedure ImageDrawRectangleLines(Dst: PImage; Rec: TRectangle; Thick: Integer; Color: TColor);
begin
  Lib_ImageDrawRectangleLines(Dst, Rec, Thick, Color);
end;

procedure Lib_ImageDraw(Dst: PImage; Src: TImage; SrcRec, DstRec: TRectangle; Tint: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageDraw';
procedure ImageDraw(Dst: PImage; Src: TImage; SrcRec, DstRec: TRectangle; Tint: TColor);
begin
  Lib_ImageDraw(Dst, Src, SrcRec, DstRec, Tint);
end;

procedure Lib_ImageDrawText(Dst: PImage; const Text: PAnsiChar; PosX, PosY, FontSize: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageDrawText';
procedure ImageDrawText(Dst: PImage; const Text: PAnsiChar; PosX, PosY, FontSize: Integer; Color: TColor);
begin
  Lib_ImageDrawText(Dst, Text, PosX, PosY, FontSize, Color);
end;

procedure Lib_ImageDrawTextEx(Dst: PImage; Font: TFont; const Text: PAnsiChar; Position: TVector2; FontSize, Spacing: Single; Tint: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ImageDrawTextEx';
procedure ImageDrawTextEx(Dst: PImage; Font: TFont; const Text: PAnsiChar; Position: TVector2; FontSize, Spacing: Single; Tint: TColor);
begin
  Lib_ImageDrawTextEx(Dst, Font, Text, Position, FontSize, Spacing, Tint);
end;

// Texture loading functions

function Lib_LoadTexture(const FileName: PAnsiChar): TTexture2D;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadTexture';
function LoadTexture(const FileName: PAnsiChar): TTexture2D;
begin
  Result := Lib_LoadTexture(FileName);
end;

function Lib_LoadTextureFromImage(Image: TImage): TTexture2D;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadTextureFromImage';
function LoadTextureFromImage(Image: TImage): TTexture2D;
begin
  Result := Lib_LoadTextureFromImage(Image);
end;

function Lib_LoadTextureCubemap(Image: TImage; Layout: TCubemapLayout): TTextureCubemap;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadTextureCubemap';
function LoadTextureCubemap(Image: TImage; Layout: TCubemapLayout): TTextureCubemap;
begin
  Result := Lib_LoadTextureCubemap(Image, Layout);
end;

function Lib_LoadRenderTexture(Width, Height: Integer): TRenderTexture2D;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadRenderTexture';
function LoadRenderTexture(Width, Height: Integer): TRenderTexture2D;
begin
  Result := Lib_LoadRenderTexture(Width, Height);
end;

function Lib_IsTextureReady(Texture: TTexture2D): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsTextureReady';
function IsTextureReady(Texture: TTexture2D): Boolean;
begin
  Result := Lib_IsTextureReady(Texture);
end;

procedure Lib_UnloadTexture(Texture: TTexture2D);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadTexture';
procedure UnloadTexture(Texture: TTexture2D);
begin
  Lib_UnloadTexture(Texture);
end;

function Lib_IsRenderTextureReady(Texture: TRenderTexture2D): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsRenderTextureReady';
function IsRenderTextureReady(Texture: TRenderTexture2D): Boolean;
begin
  Result := Lib_IsRenderTextureReady(Texture);
end;

procedure Lib_UnloadRenderTexture(Target: TRenderTexture2D);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadRenderTexture';
procedure UnloadRenderTexture(Target: TRenderTexture2D);
begin
  Lib_UnloadRenderTexture(Target);
end;

procedure Lib_UpdateTexture(Texture: TTexture2D; const Pixels: Pointer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UpdateTexture';
procedure UpdateTexture(Texture: TTexture2D; const Pixels: Pointer);
begin
  Lib_UpdateTexture(Texture, Pixels);
end;

procedure Lib_UpdateTextureRec(Texture: TTexture2D; Rec: TRectangle; const Pixels: Pointer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UpdateTextureRec';
procedure UpdateTextureRec(Texture: TTexture2D; Rec: TRectangle; const Pixels: Pointer);
begin
  Lib_UpdateTextureRec(Texture, Rec, Pixels);
end;

// Texture configuration functions

procedure Lib_GenTextureMipmaps(Texture: PTexture2D);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenTextureMipmaps';
procedure GenTextureMipmaps(Texture: PTexture2D);
begin
  Lib_GenTextureMipmaps(Texture);
end;

procedure Lib_SetTextureFilter(Texture: TTexture2D; Filter: TTextureFilter);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetTextureFilter';
procedure SetTextureFilter(Texture: TTexture2D; Filter: TTextureFilter);
begin
  Lib_SetTextureFilter(Texture, Filter);
end;

procedure Lib_SetTextureWrap(Texture: TTexture2D; Wrap: TTextureWrap);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetTextureWrap';
procedure SetTextureWrap(Texture: TTexture2D; Wrap: TTextureWrap);
begin
  Lib_SetTextureWrap(Texture, Wrap);
end;

// Texture drawing functions

procedure Lib_DrawTexture(Texture: TTexture2D; PosX, PosY: Integer; Tint: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawTexture';
procedure DrawTexture(Texture: TTexture2D; PosX, PosY: Integer; Tint: TColor);
begin
  Lib_DrawTexture(Texture, PosX, PosY, Tint);
end;

procedure Lib_DrawTextureV(Texture: TTexture2D; Position: TVector2; Tint: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawTextureV';
procedure DrawTextureV(Texture: TTexture2D; Position: TVector2; Tint: TColor);
begin
  Lib_DrawTextureV(Texture, Position, Tint);
end;

procedure Lib_DrawTextureEx(Texture: TTexture2D; Position: TVector2; Rotation, Scale: Single; Tint: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawTextureEx';
procedure DrawTextureEx(Texture: TTexture2D; Position: TVector2; Rotation, Scale: Single; Tint: TColor);
begin
  Lib_DrawTextureEx(Texture, Position, Rotation, Scale, Tint);
end;

procedure Lib_DrawTextureRec(Texture: TTexture2D; Source: TRectangle; Position: TVector2; Tint: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawTextureRec';
procedure DrawTextureRec(Texture: TTexture2D; Source: TRectangle; Position: TVector2; Tint: TColor);
begin
  Lib_DrawTextureRec(Texture, Source, Position, Tint);
end;

procedure Lib_DrawTexturePro(Texture: TTexture2D; Source, Dest: TRectangle; Origin: TVector2; Rotation: Single; Tint: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawTexturePro';
procedure DrawTexturePro(Texture: TTexture2D; Source, Dest: TRectangle; Origin: TVector2; Rotation: Single; Tint: TColor);
begin
  Lib_DrawTexturePro(Texture, Source, Dest, Origin, Rotation, Tint);
end;

procedure Lib_DrawTextureNPatch(Texture: TTexture2D; NPatchInfo: TNPatchInfo; Dest: TRectangle; Origin: TVector2; Rotation: Single; Tint: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawTextureNPatch';
procedure DrawTextureNPatch(Texture: TTexture2D; NPatchInfo: TNPatchInfo; Dest: TRectangle; Origin: TVector2; Rotation: Single; Tint: TColor);
begin
  Lib_DrawTextureNPatch(Texture, NPatchInfo, Dest, Origin, Rotation, Tint);
end;

// Color/pixel related functions

function Lib_Fade(Color: TColor; Alpha: Single): {$IFNDEF RET_TRICK}TColor{$ELSE}UInt32{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Fade';
function Fade(Color: TColor; Alpha: Single): TColor;
begin
  Result := TColor(Lib_Fade(Color, Alpha));
end;

function Lib_ColorToInt(Color: TColor): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ColorToInt';
function ColorToInt(Color: TColor): Integer;
begin
  Result := Lib_ColorToInt(Color);
end;

function Lib_ColorNormalize(Color: TColor): TVector4;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ColorNormalize';
function ColorNormalize(Color: TColor): TVector4;
begin
  Result := Lib_ColorNormalize(Color);
end;

function Lib_ColorFromNormalized(Normalized: TVector4): {$IFNDEF RET_TRICK}TColor{$ELSE}UInt32{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ColorFromNormalized';
function ColorFromNormalized(Normalized: TVector4): TColor;
begin
  Result := TColor(Lib_ColorFromNormalized(Normalized));
end;

function Lib_ColorToHSV(Color: TColor): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ColorToHSV';
function ColorToHSV(Color: TColor): TVector3;
begin
  Result := Lib_ColorToHSV(Color);
end;

function Lib_ColorFromHSV(Hue, Saturation, Value: Single): {$IFNDEF RET_TRICK}TColor{$ELSE}UInt32{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ColorFromHSV';
function ColorFromHSV(Hue, Saturation, Value: Single): TColor;
begin
  Result := TColor(Lib_ColorFromHSV(Hue, Saturation, Value));
end;

function Lib_ColorTint(Color, Tint: TColor): {$IFNDEF RET_TRICK}TColor{$ELSE}UInt32{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ColorTint';
function ColorTint(Color, Tint: TColor): TColor;
begin
  Result := TColor(Lib_ColorTint(Color, Tint));
end;

function Lib_ColorBrightness(Color: TColor; Factor: Single): {$IFNDEF RET_TRICK}TColor{$ELSE}UInt32{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ColorBrightness';
function ColorBrightness(Color: TColor; Factor: Single): TColor;
begin
  Result := TColor(Lib_ColorBrightness(Color, Factor));
end;

function Lib_ColorContrast(Color: TColor; Contrast: Single): {$IFNDEF RET_TRICK}TColor{$ELSE}UInt32{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ColorContrast';
function ColorContrast(Color: TColor; Contrast: Single): TColor;
begin
  Result := TColor(Lib_ColorContrast(Color, Contrast));
end;

function Lib_ColorAlpha(Color: TColor; Alpha: Single): {$IFNDEF RET_TRICK}TColor{$ELSE}UInt32{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ColorAlpha';
function ColorAlpha(Color: TColor; Alpha: Single): TColor;
begin
  Result := TColor(Lib_ColorAlpha(Color, Alpha));
end;

function Lib_ColorAlphaBlend(Dst, Src, Tint: TColor): {$IFNDEF RET_TRICK}TColor{$ELSE}UInt32{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ColorAlphaBlend';
function ColorAlphaBlend(Dst, Src, Tint: TColor): TColor;
begin
  Result := TColor(Lib_ColorAlphaBlend(Dst, Src, Tint));
end;

function Lib_GetColor(HexValue: Cardinal): {$IFNDEF RET_TRICK}TColor{$ELSE}UInt32{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetColor';
function GetColor(HexValue: Cardinal): TColor;
begin
  Result := TColor(Lib_GetColor(HexValue));
end;

function Lib_GetPixelColor(SrcPtr: Pointer; Format: TPixelFormat): {$IFNDEF RET_TRICK}TColor{$ELSE}UInt32{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetPixelColor';
function GetPixelColor(SrcPtr: Pointer; Format: TPixelFormat): TColor;
begin
  Result := TColor(Lib_GetPixelColor(SrcPtr, Format));
end;

procedure Lib_SetPixelColor(DstPtr: Pointer; Color: TColor; Format: TPixelFormat);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetPixelColor';
procedure SetPixelColor(DstPtr: Pointer; Color: TColor; Format: TPixelFormat);
begin
  Lib_SetPixelColor(DstPtr, Color, Format);
end;

function Lib_GetPixelDataSize(Width, Height: Integer; Format: TPixelFormat): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetPixelDataSize';
function GetPixelDataSize(Width, Height: Integer; Format: TPixelFormat): Integer;
begin
  Result := Lib_GetPixelDataSize(Width, Height, Format);
end;

// Font loading/unloading functions

function Lib_GetFontDefault(): TFont;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetFontDefault';
function GetFontDefault(): TFont;
begin
  Result := Lib_GetFontDefault();
end;

function Lib_LoadFont(const FileName: PAnsiChar): TFont;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadFont';
function LoadFont(const FileName: PAnsiChar): TFont;
begin
  Result := Lib_LoadFont(FileName);
end;

function Lib_LoadFontEx(const FileName: PAnsiChar; FontSize: Integer; FontChars: PInteger; GlyphCount: Integer): TFont;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadFontEx';
function LoadFontEx(const FileName: PAnsiChar; FontSize: Integer; FontChars: PInteger; GlyphCount: Integer): TFont;
begin
  Result := Lib_LoadFontEx(FileName, FontSize, FontChars, GlyphCount)
end;

function Lib_LoadFontFromImage(Image: TImage; Key: TColor; FirstChar: Integer): TFont;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadFontFromImage';
function LoadFontFromImage(Image: TImage; Key: TColor; FirstChar: Integer): TFont;
begin
  Result := Lib_LoadFontFromImage(Image, Key, FirstChar);
end;

function Lib_LoadFontFromMemory(const FileType: PAnsiChar; const FileData: PByte; DataSize, FontSize: Integer; FontChars: PInteger; GlyphCount: Integer): TFont;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadFontFromMemory';
function LoadFontFromMemory(const FileType: PAnsiChar; const FileData: PByte; DataSize, FontSize: Integer; FontChars: PInteger; GlyphCount: Integer): TFont;
begin
  Result := Lib_LoadFontFromMemory(FileType, FileData, DataSize, FontSize, FontChars, GlyphCount);
end;

function Lib_IsFontReady(Font: TFont): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsFontReady';
function IsFontReady(Font: TFont): Boolean;
begin
  Result := Lib_IsFontReady(Font);
end;

function Lib_LoadFontData(const FileData: PByte; DataSize, FontSize: Integer; FontChars: PInteger; GlyphCount, Type_: TFontType): PGlyphInfo;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadFontData';
function LoadFontData(const FileData: PByte; DataSize, FontSize: Integer; FontChars: PInteger; GlyphCount, Type_: TFontType): PGlyphInfo;
begin
  Result := Lib_LoadFontData(FileData, DataSize, FontSize, FontChars, GlyphCount, Type_);
end;

function Lib_GenImageFontAtlas(const Chars: PGlyphInfo; Recs: PPRectangle; GlyphCount, FontSize, Padding, PackMethod: Integer): TImage;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenImageFontAtlas';
function GenImageFontAtlas(const Chars: PGlyphInfo; Recs: PPRectangle; GlyphCount, FontSize, Padding, PackMethod: Integer): TImage;
begin
  Result := Lib_GenImageFontAtlas(Chars, Recs, GlyphCount, FontSize, Padding, PackMethod);
end;

procedure Lib_UnloadFontData(Chars: PGlyphInfo; GlyphCount: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadFontData';
procedure UnloadFontData(Chars: PGlyphInfo; GlyphCount: Integer);
begin
  Lib_UnloadFontData(Chars, GlyphCount);
end;

procedure Lib_UnloadFont(Font: TFont);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadFont';
procedure UnloadFont(Font: TFont);
begin
  Lib_UnloadFont(Font);
end;

procedure Lib_ExportFontAsCode(Font: TFont; const FileName: PAnsiChar);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ExportFontAsCode';
procedure ExportFontAsCode(Font: TFont; const FileName: PAnsiChar);
begin
  Lib_ExportFontAsCode(Font, FileName);
end;

// Text drawing functions

procedure Lib_DrawFPS(PosX, PosY: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawFPS';
procedure DrawFPS(PosX, PosY: Integer);
begin
  Lib_DrawFPS(PosX, PosY);
end;

procedure Lib_DrawText(const Text: PAnsiChar; PosX, PosY, FontSize: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawText';
procedure DrawText(const Text: PAnsiChar; PosX, PosY, FontSize: Integer; Color: TColor);
begin
  Lib_DrawText(Text, PosX, PosY, FontSize, Color);
end;

procedure Lib_DrawTextEx(Font: TFont; const Text: PAnsiChar; Position: TVector2; FontSize, Spacing: Single; Tint: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawTextEx';
procedure DrawTextEx(Font: TFont; const Text: PAnsiChar; Position: TVector2; FontSize, Spacing: Single; Tint: TColor);
begin
  Lib_DrawTextEx(Font, Text, Position, FontSize, Spacing, Tint);
end;

procedure Lib_DrawTextPro(Font: TFont; const Text: PAnsiChar; Position, Origin: TVector2; Rotation, FontSize, Spacing: Single; Tint: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawTextPro';
procedure DrawTextPro(Font: TFont; const Text: PAnsiChar; Position, Origin: TVector2; Rotation, FontSize, Spacing: Single; Tint: TColor);
begin
  Lib_DrawTextPro(Font, Text, Position, Origin, Rotation, FontSize, Spacing, Tint);
end;

procedure Lib_DrawTextCodepoint(Font: TFont; Codepoint: Integer; Position: TVector2; FontSize: Single; Tint: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawTextCodepoint';
procedure DrawTextCodepoint(Font: TFont; Codepoint: Integer; Position: TVector2; FontSize: Single; Tint: TColor);
begin
  Lib_DrawTextCodepoint(Font, Codepoint, Position, FontSize, Tint);
end;

procedure Lib_DrawTextCodepoints(Font: TFont; const Codepoints: PInteger; Count: Integer; Position: TVector2; FontSize, Spacing: Single; Tint: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawTextCodepoints';
procedure DrawTextCodepoints(Font: TFont; const Codepoints: PInteger; Count: Integer; Position: TVector2; FontSize, Spacing: Single; Tint: TColor);
begin
  Lib_DrawTextCodepoints(Font, Codepoints, Count, Position, FontSize, Spacing, Tint);
end;

// Text font info functions

// Measure string width for default font
function Lib_MeasureText(const Text: PAnsiChar; FontSize: Integer): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MeasureText';
function MeasureText(const Text: PAnsiChar; FontSize: Integer): Integer;
begin
  Result := Lib_MeasureText(Text, FontSize);
end;

function Lib_MeasureTextEx(Font: TFont; const Text: PAnsiChar; FontSize, Spacing: Single): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MeasureTextEx';
function MeasureTextEx(Font: TFont; const Text: PAnsiChar; FontSize, Spacing: Single): TVector2;
begin
  Result := TVector2(Lib_MeasureTextEx(Font, Text, FontSize, Spacing));
end;

function Lib_GetGlyphIndex(Font: TFont; Codepoint: Integer): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetGlyphIndex';
function GetGlyphIndex(Font: TFont; Codepoint: Integer): Integer;
begin
  Result := Lib_GetGlyphIndex(Font, Codepoint);
end;

function Lib_GetGlyphInfo(Font: TFont; Codepoint: Integer): TGlyphInfo;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetGlyphInfo';
function GetGlyphInfo(Font: TFont; Codepoint: Integer): TGlyphInfo;
begin
  Result := Lib_GetGlyphInfo(Font, Codepoint);
end;

function Lib_GetGlyphAtlasRec(Font: TFont; Codepoint: Integer): TRectangle;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetGlyphAtlasRec';
function GetGlyphAtlasRec(Font: TFont; Codepoint: Integer): TRectangle;
begin
  Result := Lib_GetGlyphAtlasRec(Font, Codepoint);
end;

// Text codepoints management functions (unicode characters)

function Lib_LoadUTF8(const Codepoints: PInteger; Length: Integer): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadUTF8';
function LoadUTF8(const Codepoints: PInteger; Length: Integer): PAnsiChar;
begin
  Result := Lib_LoadUTF8(Codepoints, Length);
end;

procedure Lib_UnloadUTF8(Text: PAnsiChar);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadUTF8';
procedure UnloadUTF8(Text: PAnsiChar);
begin
  Lib_UnloadUTF8(Text);
end;

function Lib_LoadCodepoints(const Text: PAnsiChar; Count: PInteger): PInteger;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadCodepoints';
function LoadCodepoints(const Text: PAnsiChar; Count: PInteger): PInteger;
begin
  Result := Lib_LoadCodepoints(Text, Count);
end;

procedure Lib_UnloadCodepoints(Codepoints: PInteger);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadCodepoints';
procedure UnloadCodepoints(Codepoints: PInteger);
begin
  Lib_UnloadCodepoints(Codepoints);
end;

function Lib_GetCodepointCount(const Text: PAnsiChar): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetCodepointCount';
function GetCodepointCount(const Text: PAnsiChar): Integer;
begin
  Result := Lib_GetCodepointCount(Text);
end;

function Lib_GetCodepoint(const Text: PAnsiChar; CodepointSize: PInteger): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetCodepoint';
function GetCodepoint(const Text: PAnsiChar; CodepointSize: PInteger): Integer;
begin
  Result := Lib_GetCodepoint(Text, CodepointSize);
end;

function Lib_GetCodepointNext(const Text: PAnsiChar; CodepointSize: PInteger): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetCodepointNext';
function GetCodepointNext(const Text: PAnsiChar; CodepointSize: PInteger): Integer;
begin
  Result := Lib_GetCodepointNext(Text, CodepointSize);
end;

function Lib_GetCodepointPrevious(const Text: PAnsiChar; CodepointSize: PInteger): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetCodepointPrevious';
function GetCodepointPrevious(const Text: PAnsiChar; CodepointSize: PInteger): Integer;
begin
  Result := Lib_GetCodepointPrevious(Text, CodepointSize);
end;

function Lib_CodepointToUTF8(Codepoint: Integer; Utf8Size: PInteger): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CodepointToUTF8';
function CodepointToUTF8(Codepoint: Integer; Utf8Size: PInteger): PAnsiChar;
begin
  Result := Lib_CodepointToUTF8(Codepoint, Utf8Size);
end;

// Text strings management functions (no UTF-8 strings, only byte chars)

function Lib_TextCopy(Dst: PAnsiChar; const Src: PAnsiChar): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'TextCopy';
function TextCopy(Dst: PAnsiChar; const Src: PAnsiChar): Integer;
begin
  Result := Lib_TextCopy(Dst, Src);
end;

function Lib_TextIsEqual(const Text1, Text2: PAnsiChar): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'TextIsEqual';
function TextIsEqual(const Text1, Text2: PAnsiChar): Boolean;
begin
  Result := Lib_TextIsEqual(Text1, Text2);
end;

function Lib_TextLength(const Text: PAnsiChar): Cardinal;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'TextLength';
function TextLength(const Text: PAnsiChar): Cardinal;
begin
  Result := Lib_TextLength(Text);
end;

function TextFormat(const Text: PAnsiChar): PAnsiChar;
  cdecl varargs; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'TextFormat';

function Lib_TextSubtext(const Text: PAnsiChar; Position, Length: Integer): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'TextSubtext';
function TextSubtext(const Text: PAnsiChar; Position, Length: Integer): PAnsiChar;
begin
  Result := Lib_TextSubtext(Text, Position, Length);
end;

function Lib_TextReplace(Text: PAnsiChar; const Replace, By: PAnsiChar): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'TextReplace';
function TextReplace(Text: PAnsiChar; const Replace, By: PAnsiChar): PAnsiChar;
begin
  Result := Lib_TextReplace(Text, Replace, By);
end;

function Lib_TextInsert(const Text, Insert: PAnsiChar; Position: Integer): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'TextInsert';
function TextInsert(const Text, Insert: PAnsiChar; Position: Integer): PAnsiChar;
begin
  Result := Lib_TextInsert(Text, Insert, Position);
end;

function Lib_TextJoin(const TextList: PPAnsiChar; Count: Integer; const Delimiter: PAnsiChar): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'TextJoin';
function TextJoin(const TextList: PPAnsiChar; Count: Integer; const Delimiter: PAnsiChar): PAnsiChar;
begin
  Result := Lib_TextJoin(TextList, Count, Delimiter);
end;

function Lib_TextSplit(const Text: PAnsiChar; Delimiter: Char; Count: PInteger): PPAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'TextSplit';
function TextSplit(const Text: PAnsiChar; Delimiter: Char; Count: PInteger): PPAnsiChar;
begin
  Result := Lib_TextSplit(Text, Delimiter, Count);
end;

procedure Lib_TextAppend(Text: PAnsiChar; const Append: PAnsiChar; Position: PInteger);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'TextAppend';
procedure TextAppend(Text: PAnsiChar; const Append: PAnsiChar; Position: PInteger);
begin
  Lib_TextAppend(Text, Append, Position);
end;

function Lib_TextFindIndex(const Text, Find: PAnsiChar): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'TextFindIndex';
function TextFindIndex(const Text, Find: PAnsiChar): Integer;
begin
  Result := Lib_TextFindIndex(Text, Find);
end;

function Lib_TextToUpper(const Text: PAnsiChar): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'TextToUpper';
function TextToUpper(const Text: PAnsiChar): PAnsiChar;
begin
  Result := Lib_TextToUpper(Text);
end;

function Lib_TextToLower(const Text: PAnsiChar): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'TextToLower';
function TextToLower(const Text: PAnsiChar): PAnsiChar;
begin
  Result := Lib_TextToLower(Text);
end;

function Lib_TextToPascal(const Text: PAnsiChar): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'TextToPascal';
function TextToPascal(const Text: PAnsiChar): PAnsiChar;
begin
  Result := Lib_TextToPascal(Text);
end;

function Lib_TextToInteger(const Text: PAnsiChar): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'TextToInteger';
function TextToInteger(const Text: PAnsiChar): Integer;
begin
  Result := Lib_TextToInteger(Text);
end;

// Basic geometric 3D shapes drawing functions

procedure Lib_DrawLine3D(StartPos, EndPos: TVector3; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawLine3D';
procedure DrawLine3D(StartPos, EndPos: TVector3; Color: TColor);
begin
  Lib_DrawLine3D(StartPos, EndPos, Color);
end;

procedure Lib_DrawPoint3D(Position: TVector3; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawPoint3D';
procedure DrawPoint3D(Position: TVector3; Color: TColor);
begin
  Lib_DrawPoint3D(Position, Color);
end;

procedure Lib_DrawCircle3D(Center: TVector3; Radius: Single; RotationAxis: TVector3; RotationAngle: Single; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawCircle3D';
procedure DrawCircle3D(Center: TVector3; Radius: Single; RotationAxis: TVector3; RotationAngle: Single; Color: TColor);
begin
  Lib_DrawCircle3D(Center, Radius, RotationAxis, RotationAngle, Color);
end;

procedure Lib_DrawTriangle3D(V1, V2, V3: TVector3; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawTriangle3D';
procedure DrawTriangle3D(V1, V2, V3: TVector3; Color: TColor);
begin
  Lib_DrawTriangle3D(V1, V2, V3, Color);
end;

procedure Lib_DrawTriangleStrip3D(Points: PVector3; PointCount: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawTriangleStrip3D';
procedure DrawTriangleStrip3D(Points: PVector3; PointCount: Integer; Color: TColor);
begin
  Lib_DrawTriangleStrip3D(Points, PointCount, Color);
end;

procedure Lib_DrawCube(Position: TVector3; Width, Height, Length: Single; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawCube';
procedure DrawCube(Position: TVector3; Width, Height, Length: Single; Color: TColor);
begin
  Lib_DrawCube(Position, Width, Height, Length, Color);
end;

procedure Lib_DrawCubeV(Position, Size: TVector3; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawCubeV';
procedure DrawCubeV(Position, Size: TVector3; Color: TColor);
begin
  Lib_DrawCubeV(Position, Size, Color);
end;

procedure Lib_DrawCubeWires(Position: TVector3; Width, Height, Length: Single; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawCubeWires';
procedure DrawCubeWires(Position: TVector3; Width, Height, Length: Single; Color: TColor);
begin
  Lib_DrawCubeWires(Position, Width, Height, Length, Color);
end;

procedure Lib_DrawCubeWiresV(Position, Size: TVector3; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawCubeWiresV';
procedure DrawCubeWiresV(Position, Size: TVector3; Color: TColor);
begin
  Lib_DrawCubeWiresV(Position, Size, Color);
end;

procedure Lib_DrawSphere(CenterPos: TVector3; Radius: Single; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawSphere';
procedure DrawSphere(CenterPos: TVector3; Radius: Single; Color: TColor);
begin
  Lib_DrawSphere(CenterPos, Radius, Color);
end;

procedure Lib_DrawSphereEx(CenterPos: TVector3; Radius: Single; Rings, Slices: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawSphereEx';
procedure DrawSphereEx(CenterPos: TVector3; Radius: Single; Rings, Slices: Integer; Color: TColor);
begin
  Lib_DrawSphereEx(CenterPos, Radius, Rings, Slices, Color);
end;

procedure Lib_DrawSphereWires(CenterPos: TVector3; Radius: Single; Rings, Slices: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawSphereWires';
procedure DrawSphereWires(CenterPos: TVector3; Radius: Single; Rings, Slices: Integer; Color: TColor);
begin
  Lib_DrawSphereWires(CenterPos, Radius, Rings, Slices, Color);
end;

procedure Lib_DrawCylinder(Position: TVector3; RadiusTop, RadiusBottom, Height: Single; Slices: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawCylinder';
procedure DrawCylinder(Position: TVector3; RadiusTop, RadiusBottom, Height: Single; Slices: Integer; Color: TColor);
begin
  Lib_DrawCylinder(Position, RadiusTop, RadiusBottom, Height, Slices, Color);
end;

procedure Lib_DrawCylinderEx(StartPos, EndPos: TVector3; StartRadius, EndRadius: Single; Sides: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawCylinderEx';
procedure DrawCylinderEx(StartPos, EndPos: TVector3; StartRadius, EndRadius: Single; Sides: Integer; Color: TColor);
begin
  Lib_DrawCylinderEx(StartPos, EndPos, StartRadius, EndRadius, Sides, Color);
end;

procedure Lib_DrawCylinderWires(Position: TVector3; RadiusTop, RadiusBottom, Height: Single; Slices: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawCylinderWires';
procedure DrawCylinderWires(Position: TVector3; RadiusTop, RadiusBottom, Height: Single; Slices: Integer; Color: TColor);
begin
  Lib_DrawCylinderWires(Position, RadiusTop, RadiusBottom, Height, Slices, Color);
end;

procedure Lib_DrawCylinderWiresEx(StartPos, EndPos: TVector3; StartRadius, EndRadius: Single; Sides: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawCylinderWiresEx';
procedure DrawCylinderWiresEx(StartPos, EndPos: TVector3; StartRadius, EndRadius: Single; Sides: Integer; Color: TColor);
begin
  Lib_DrawCylinderWiresEx(StartPos, EndPos, StartRadius, EndRadius, Sides, Color);
end;

procedure Lib_DrawCapsule(StartPos, EndPos: TVector3; Radius: Single; Slices, Rings: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawCapsule';
procedure DrawCapsule(StartPos, EndPos: TVector3; Radius: Single; Slices, Rings: Integer; Color: TColor);
begin
  Lib_DrawCapsule(StartPos, EndPos, Radius, Slices, Rings, Color);
end;

procedure Lib_DrawCapsuleWires(StartPos, EndPos: TVector3; Radius: Single; Slices, Rings: Integer; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawCapsuleWires';
procedure DrawCapsuleWires(StartPos, EndPos: TVector3; Radius: Single; Slices, Rings: Integer; Color: TColor);
begin
  Lib_DrawCapsuleWires(StartPos, EndPos, Radius, Slices, Rings, Color);
end;


procedure Lib_DrawPlane(CenterPos: TVector3; Size: TVector2; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawPlane';
procedure DrawPlane(CenterPos: TVector3; Size: TVector2; Color: TColor);
begin
  Lib_DrawPlane(CenterPos, Size, Color);
end;

procedure Lib_DrawRay(Ray: TRay; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawRay';
procedure DrawRay(Ray: TRay; Color: TColor);
begin
  Lib_DrawRay(Ray, Color);
end;

procedure Lib_DrawGrid(Slices: Integer; Spacing: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawGrid';
procedure DrawGrid(Slices: Integer; Spacing: Single);
begin
  Lib_DrawGrid(Slices, Spacing);
end;

// Model management functions

function Lib_LoadModel(const FileName: PAnsiChar): TModel;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadModel';
function LoadModel(const FileName: PAnsiChar): TModel;
begin
  Result := Lib_LoadModel(FileName);
end;

function Lib_LoadModelFromMesh(Mesh: TMesh): TModel;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadModelFromMesh';
function LoadModelFromMesh(Mesh: TMesh): TModel;
begin
  Result := Lib_LoadModelFromMesh(Mesh);
end;

function Lib_IsModelReady(Model: TModel): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsModelReady';
function IsModelReady(Model: TModel): Boolean;
begin
  Result := Lib_IsModelReady(Model);
end;

procedure Lib_UnloadModel(Model: TModel);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadModel';
procedure UnloadModel(Model: TModel);
begin
  Lib_UnloadModel(Model);
end;

function Lib_GetModelBoundingBox(Model: TModel): TBoundingBox;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetModelBoundingBox';
function GetModelBoundingBox(Model: TModel): TBoundingBox;
begin
  Result := Lib_GetModelBoundingBox(Model);
end;

//Model drawing functions

procedure Lib_DrawModel(Model: TModel; Position: TVector3; Scale: Single; Tint: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawModel';
procedure DrawModel(Model: TModel; Position: TVector3; Scale: Single; Tint: TColor);
begin
  Lib_DrawModel(Model, Position, Scale, Tint);
end;

procedure Lib_DrawModelEx(Model: TModel; Position, RotationAxis: TVector3; RotationAngle: Single; Scale: TVector3; Tint: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawModelEx';
procedure DrawModelEx(Model: TModel; Position, RotationAxis: TVector3; RotationAngle: Single; Scale: TVector3; Tint: TColor);
begin
  Lib_DrawModelEx(Model, Position, RotationAxis, RotationAngle, Scale, Tint);
end;

procedure Lib_DrawModelWires(Model: TModel; Position: TVector3; Scale: Single; Tint: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawModelWires';
procedure DrawModelWires(Model: TModel; Position: TVector3; Scale: Single; Tint: TColor);
begin
  Lib_DrawModelWires(Model, Position, Scale, Tint);
end;

procedure Lib_DrawModelWiresEx(Model: TModel; Position, RotationAxis: TVector3; RotationAngle: Single; Scale: TVector3; Tint: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawModelWiresEx';
procedure DrawModelWiresEx(Model: TModel; Position, RotationAxis: TVector3; RotationAngle: Single; Scale: TVector3; Tint: TColor);
begin
  Lib_DrawModelWiresEx(Model, Position, RotationAxis, RotationAngle, Scale, Tint);
end;

procedure Lib_DrawBoundingBox(Box: TBoundingBox; Color: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawBoundingBox';
procedure DrawBoundingBox(Box: TBoundingBox; Color: TColor);
begin
  Lib_DrawBoundingBox(Box, Color);
end;

procedure Lib_DrawBillboard(Camera: TCamera; Texture: TTexture2D; Position: TVector3; Size: Single; Tint: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawBillboard';
procedure DrawBillboard(Camera: TCamera; Texture: TTexture2D; Position: TVector3; Size: Single; Tint: TColor);
begin
  Lib_DrawBillboard(Camera, Texture, Position, Size, Tint);
end;

procedure Lib_DrawBillboardRec(Camera: TCamera; Texture: TTexture2D; Source: TRectangle; Position: TVector3; Size: TVector2; Tint: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawBillboardRec';
procedure DrawBillboardRec(Camera: TCamera; Texture: TTexture2D; Source: TRectangle; Position: TVector3; Size: TVector2; Tint: TColor);
begin
  Lib_DrawBillboardRec(Camera, Texture, Source, Position, Size, Tint);
end;

procedure Lib_DrawBillboardPro(Camera: TCamera; Texture: TTexture2D; Source: TRectangle; Position, Up: TVector3; Size, Origin: TVector2; Rotation: Single; Tint: TColor);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawBillboardPro';
procedure DrawBillboardPro(Camera: TCamera; Texture: TTexture2D; Source: TRectangle; Position, Up: TVector3; Size, Origin: TVector2; Rotation: Single; Tint: TColor);
begin
  Lib_DrawBillboardPro(Camera, Texture, Source, Position, Up, Size, Origin, Rotation, Tint);
end;

// Mesh management functions

procedure Lib_UploadMesh(Mesh: PMesh; Dynamic_: Boolean);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UploadMesh';
procedure UploadMesh(Mesh: PMesh; Dynamic_: Boolean);
begin
  Lib_UploadMesh(Mesh, Dynamic_);
end;

procedure Lib_UpdateMeshBuffer(Mesh: TMesh; Index: Integer; const Data: Pointer; DataSize, Offset: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UpdateMeshBuffer';
procedure UpdateMeshBuffer(Mesh: TMesh; Index: Integer; const Data: Pointer; DataSize, Offset: Integer);
begin
  Lib_UpdateMeshBuffer(Mesh, Index, Data, DataSize, Offset);
end;

procedure Lib_UnloadMesh(Mesh: TMesh);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadMesh';
procedure UnloadMesh(Mesh: TMesh);
begin
  Lib_UnloadMesh(Mesh);
end;

procedure Lib_DrawMesh(Mesh: TMesh; Material: TMaterial; Transform: TMatrix);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawMesh';
procedure DrawMesh(Mesh: TMesh; Material: TMaterial; Transform: TMatrix);
begin
  Lib_DrawMesh(Mesh, Material, Transform);
end;

procedure Lib_DrawMeshInstanced(Mesh: TMesh; Material: TMaterial; const Transforms: PMatrix; Instances: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DrawMeshInstanced';
procedure DrawMeshInstanced(Mesh: TMesh; Material: TMaterial; const Transforms: PMatrix; Instances: Integer);
begin
  Lib_DrawMeshInstanced(Mesh, Material, Transforms, Instances);
end;

function Lib_ExportMesh(Mesh: TMesh; const FileName: PAnsiChar): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ExportMesh';
function ExportMesh(Mesh: TMesh; const FileName: PAnsiChar): Boolean;
begin
  Result := Lib_ExportMesh(Mesh, FileName);
end;

function Lib_GetMeshBoundingBox(Mesh: TMesh): TBoundingBox;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetMeshBoundingBox';
function GetMeshBoundingBox(Mesh: TMesh): TBoundingBox;
begin
  Result := Lib_GetMeshBoundingBox(Mesh);
end;

procedure Lib_GenMeshTangents(Mesh: PMesh);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenMeshTangents';
procedure GenMeshTangents(Mesh: PMesh);
begin
  Lib_GenMeshTangents(Mesh);
end;

// Mesh generation functions

function Lib_GenMeshPoly(Sides: Integer; Radius: Single): TMesh;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenMeshPoly';
function GenMeshPoly(Sides: Integer; Radius: Single): TMesh;
begin
  Result := Lib_GenMeshPoly(Sides, Radius);
end;

function Lib_GenMeshPlane(Width, Length: Single; ResX, ResZ: Integer): TMesh;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenMeshPlane';
function GenMeshPlane(Width, Length: Single; ResX, ResZ: Integer): TMesh;
begin
  Result := Lib_GenMeshPlane(Width, Length, ResX, ResZ);
end;

function Lib_GenMeshCube(Width, Height, Length: Single): TMesh;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenMeshCube';
function GenMeshCube(Width, Height, Length: Single): TMesh;
begin
  Result := Lib_GenMeshCube(Width, Height, Length);
end;

function Lib_GenMeshSphere(Radius: Single; Rings, Slices: Integer): TMesh;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenMeshSphere';
function GenMeshSphere(Radius: Single; Rings, Slices: Integer): TMesh;
begin
  Result := Lib_GenMeshSphere(Radius, Rings, Slices);
end;

function Lib_GenMeshHemiSphere(Radius: Single; Rings, Slices: Integer): TMesh;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenMeshHemiSphere';
function GenMeshHemiSphere(Radius: Single; Rings, Slices: Integer): TMesh;
begin
  Result := Lib_GenMeshHemiSphere(Radius, Rings, Slices);
end;

function Lib_GenMeshCylinder(Radius, Height: Single; Slices: Integer): TMesh;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenMeshCylinder';
function GenMeshCylinder(Radius, Height: Single; Slices: Integer): TMesh;
begin
  Result := Lib_GenMeshCylinder(Radius, Height, Slices);
end;

function Lib_GenMeshCone(Radius, Height: Single; Slices: Integer): TMesh;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenMeshCone';
function GenMeshCone(Radius, Height: Single; Slices: Integer): TMesh;
begin
  Result := Lib_GenMeshCone(Radius, Height, Slices);
end;

function Lib_GenMeshTorus(Radius, Size: Single; RadSeg, Sides: Integer): TMesh;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenMeshTorus';
function GenMeshTorus(Radius, Size: Single; RadSeg, Sides: Integer): TMesh;
begin
  Result := Lib_GenMeshTorus(Radius, Size, RadSeg, Sides);
end;

function Lib_GenMeshKnot(Radius, Size: Single; RadSeg, Sides: Integer): TMesh;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenMeshKnot';
function GenMeshKnot(Radius, Size: Single; RadSeg, Sides: Integer): TMesh;
begin
  Result := Lib_GenMeshKnot(Radius, Size, RadSeg, Sides);
end;

function Lib_GenMeshHeightmap(Heightmap: TImage; Size: TVector3): TMesh;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenMeshHeightmap';
function GenMeshHeightmap(Heightmap: TImage; Size: TVector3): TMesh;
begin
  Result := Lib_GenMeshHeightmap(Heightmap, Size);
end;

function Lib_GenMeshCubicmap(Cubicmap: TImage; CubeSize: TVector3): TMesh;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GenMeshCubicmap';
function GenMeshCubicmap(Cubicmap: TImage; CubeSize: TVector3): TMesh;
begin
  Result := Lib_GenMeshCubicmap(Cubicmap, CubeSize);
end;

// Material loading/unloading functions

function Lib_LoadMaterials(const FileName: PAnsiChar; MaterialCount: PInteger): PMaterial;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadMaterials';
function LoadMaterials(const FileName: PAnsiChar; MaterialCount: PInteger): PMaterial;
begin
  Result := Lib_LoadMaterials(FileName, MaterialCount);
end;

function Lib_LoadMaterialDefault(): TMaterial;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadMaterialDefault';
function LoadMaterialDefault(): TMaterial;
begin
  Result := Lib_LoadMaterialDefault();
end;

function Lib_IsMaterialReady(Material: TMaterial): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsMaterialReady';
function IsMaterialReady(Material: TMaterial): Boolean;
begin
  Result := Lib_IsMaterialReady(Material);
end;

procedure Lib_UnloadMaterial(Material: TMaterial);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadMaterial';
procedure UnloadMaterial(Material: TMaterial);
begin
  Lib_UnloadMaterial(Material);
end;

procedure Lib_SetMaterialTexture(Material: PMaterial; MapType: TMaterialMapIndex; Texture: TTexture2D);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetMaterialTexture';
procedure SetMaterialTexture(Material: PMaterial; MapType: TMaterialMapIndex; Texture: TTexture2D);
begin
  Lib_SetMaterialTexture(Material, MapType, Texture);
end;

procedure Lib_SetModelMeshMaterial(Model: PModel; MeshId, MaterialId: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetModelMeshMaterial';
procedure SetModelMeshMaterial(Model: PModel; MeshId, MaterialId: Integer);
begin
  Lib_SetModelMeshMaterial(Model, MeshId, MaterialId);
end;

// Model animations loading/unloading functions

// Load model animations from file
function Lib_LoadModelAnimations(const FileName: PAnsiChar; AnimCount: PCardinal): PModelAnimation;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadModelAnimations';
function LoadModelAnimations(const FileName: PAnsiChar; AnimCount: PCardinal): PModelAnimation;
begin
  Result := Lib_LoadModelAnimations(FileName, AnimCount);
end;

procedure Lib_UpdateModelAnimation(Model: TModel; Anim: TModelAnimation; Frame: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UpdateModelAnimation';
procedure UpdateModelAnimation(Model: TModel; Anim: TModelAnimation; Frame: Integer);
begin
  Lib_UpdateModelAnimation(Model, Anim, Frame);
end;

procedure Lib_UnloadModelAnimation(Anim: TModelAnimation);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadModelAnimation';
procedure UnloadModelAnimation(Anim: TModelAnimation);
begin
  Lib_UnloadModelAnimation(Anim);
end;

procedure Lib_UnloadModelAnimations(Animations: PModelAnimation; Count: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadModelAnimations';
procedure UnloadModelAnimations(Animations: PModelAnimation; Count: Cardinal);
begin
  Lib_UnloadModelAnimations(Animations, Count);
end;

function Lib_IsModelAnimationValid(Model: TModel; Anim: TModelAnimation): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsModelAnimationValid';
function IsModelAnimationValid(Model: TModel; Anim: TModelAnimation): Boolean;
begin
  Result := Lib_IsModelAnimationValid(Model, Anim);
end;

// Model animations loading/unloading functions

function Lib_CheckCollisionSpheres(Center1: TVector3; Radius1: Single; Center2: TVector3; Radius2: Single): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CheckCollisionSpheres';
function CheckCollisionSpheres(Center1: TVector3; Radius1: Single; Center2: TVector3; Radius2: Single): Boolean;
begin
  Result := Lib_CheckCollisionSpheres(Center1, Radius1, Center2, Radius2);
end;

function Lib_CheckCollisionBoxes(Box1, Box2: TBoundingBox): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CheckCollisionBoxes';
function CheckCollisionBoxes(Box1, Box2: TBoundingBox): Boolean;
begin
  Result := Lib_CheckCollisionBoxes(Box1, Box2);
end;

function Lib_CheckCollisionBoxSphere(Box: TBoundingBox; Center: TVector3; Radius: Single): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CheckCollisionBoxSphere';
function CheckCollisionBoxSphere(Box: TBoundingBox; Center: TVector3; Radius: Single): Boolean;
begin
  Result := Lib_CheckCollisionBoxSphere(Box, Center, Radius);
end;

function Lib_GetRayCollisionSphere(Ray: TRay; Center: TVector3; Radius: Single): TRayCollision;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetRayCollisionSphere';
function GetRayCollisionSphere(Ray: TRay; Center: TVector3; Radius: Single): TRayCollision;
begin
  Result := Lib_GetRayCollisionSphere(Ray, Center, Radius);
end;

function Lib_GetRayCollisionBox(Ray: TRay; Box: TBoundingBox): TRayCollision;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetRayCollisionBox';
function GetRayCollisionBox(Ray: TRay; Box: TBoundingBox): TRayCollision;
begin
  Result := Lib_GetRayCollisionBox(Ray, Box);
end;

function Lib_GetRayCollisionMesh(Ray: TRay; Mesh: TMesh; Transform: TMatrix): TRayCollision;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetRayCollisionMesh';
function GetRayCollisionMesh(Ray: TRay; Mesh: TMesh; Transform: TMatrix): TRayCollision;
begin
  Result := Lib_GetRayCollisionMesh(Ray, Mesh, Transform);
end;

function Lib_GetRayCollisionTriangle(Ray: TRay; P1, P2, P3: TVector3): TRayCollision;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetRayCollisionTriangle';
function GetRayCollisionTriangle(Ray: TRay; P1, P2, P3: TVector3): TRayCollision;
begin
  Result := Lib_GetRayCollisionTriangle(Ray, P1, P2, P3);
end;

function Lib_GetRayCollisionQuad(Ray: TRay; P1, P2, P3, P4: TVector3): TRayCollision;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetRayCollisionQuad';
function GetRayCollisionQuad(Ray: TRay; P1, P2, P3, P4: TVector3): TRayCollision;
begin
  Result := Lib_GetRayCollisionQuad(Ray, P1, P2, P3, P4);
end;

// Audio device management functions

procedure Lib_InitAudioDevice();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'InitAudioDevice';
procedure InitAudioDevice();
begin
  Lib_InitAudioDevice();
end;

procedure Lib_CloseAudioDevice();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'CloseAudioDevice';
procedure CloseAudioDevice();
begin
  Lib_CloseAudioDevice();
end;

function Lib_IsAudioDeviceReady(): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsAudioDeviceReady';
function IsAudioDeviceReady(): Boolean;
begin
  Result := Lib_IsAudioDeviceReady();
end;

procedure Lib_SetMasterVolume(Volume: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetMasterVolume';
procedure SetMasterVolume(Volume: Single);
begin
  Lib_SetMasterVolume(Volume);
end;

// Wave/Sound loading/unloading functions

function Lib_LoadWave(const FileName: PAnsiChar): TWave;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadWave';
function LoadWave(const FileName: PAnsiChar): TWave;
begin
  Result := Lib_LoadWave(FileName);
end;

function Lib_LoadWaveFromMemory(const FileType: PAnsiChar; const FileData: PByte; DataSize: Integer): TWave;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadWaveFromMemory';
function LoadWaveFromMemory(const FileType: PAnsiChar; const FileData: PByte; DataSize: Integer): TWave;
begin
  Result := Lib_LoadWaveFromMemory(FileType, FileData, DataSize);
end;

function Lib_IsWaveReady(Wave: TWave): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsWaveReady';
function IsWaveReady(Wave: TWave): Boolean;
begin
  Result := Lib_IsWaveReady(Wave);
end;

function Lib_LoadSound(const FileName: PAnsiChar): TSound;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadSound';
function LoadSound(const FileName: PAnsiChar): TSound;
begin
  Result := Lib_LoadSound(FileName);
end;

function Lib_LoadSoundFromWave(Wave: TWave): TSound;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadSoundFromWave';
function LoadSoundFromWave(Wave: TWave): TSound;
begin
  Result := Lib_LoadSoundFromWave(Wave);
end;

function Lib_IsSoundReady(Sound: TSound): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsSoundReady';
function IsSoundReady(Sound: TSound): Boolean;
begin
  Result := Lib_IsSoundReady(Sound);
end;

procedure Lib_UpdateSound(Sound: TSound; const Data: Pointer; SampleCount: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UpdateSound';
procedure UpdateSound(Sound: TSound; const Data: Pointer; SampleCount: Integer);
begin
  Lib_UpdateSound(Sound, Data, SampleCount);
end;

procedure Lib_UnloadWave(Wave: TWave);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadWave';
procedure UnloadWave(Wave: TWave);
begin
  Lib_UnloadWave(Wave);
end;

procedure Lib_UnloadSound(Sound: TSound);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadSound';
procedure UnloadSound(Sound: TSound);
begin
  Lib_UnloadSound(Sound);
end;

function Lib_ExportWave(Wave: TWave; const FileName: PAnsiChar): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ExportWave';
function ExportWave(Wave: TWave; const FileName: PAnsiChar): Boolean;
begin
  Result := Lib_ExportWave(Wave, FileName);
end;

function Lib_ExportWaveAsCode(Wave: TWave; const FileName: PAnsiChar): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ExportWaveAsCode';
function ExportWaveAsCode(Wave: TWave; const FileName: PAnsiChar): Boolean;
begin
  Result := Lib_ExportWaveAsCode(Wave, FileName);
end;

// Wave/Sound management functions

// Play a sound
procedure Lib_PlaySound(Sound: TSound);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'PlaySound';
procedure PlaySound(Sound: TSound);
begin
  Lib_PlaySound(Sound);
end;

procedure Lib_StopSound(Sound: TSound);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'StopSound';
procedure StopSound(Sound: TSound);
begin
  Lib_StopSound(Sound);
end;

procedure Lib_PauseSound(Sound: TSound);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'PauseSound';
procedure PauseSound(Sound: TSound);
begin
  Lib_PauseSound(Sound);
end;

procedure Lib_ResumeSound(Sound: TSound);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ResumeSound';
procedure ResumeSound(Sound: TSound);
begin
  Lib_ResumeSound(Sound);
end;

function Lib_IsSoundPlaying(Sound: TSound): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsSoundPlaying';
function IsSoundPlaying(Sound: TSound): Boolean;
begin
  Result := Lib_IsSoundPlaying(Sound);
end;

procedure Lib_SetSoundVolume(Sound: TSound; Volume: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetSoundVolume';
procedure SetSoundVolume(Sound: TSound; Volume: Single);
begin
  Lib_SetSoundVolume(Sound, Volume);
end;

procedure Lib_SetSoundPitch(Sound: TSound; Pitch: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetSoundPitch';
procedure SetSoundPitch(Sound: TSound; Pitch: Single);
begin
  Lib_SetSoundPitch(Sound, Pitch);
end;

procedure Lib_SetSoundPan(Sound: TSound; Pan: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetSoundPan';
procedure SetSoundPan(Sound: TSound; Pan: Single);
begin
  Lib_SetSoundPan(Sound, Pan);
end;

function Lib_WaveCopy(Wave: TWave): TWave;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'WaveCopy';
function WaveCopy(Wave: TWave): TWave;
begin
  Result := Lib_WaveCopy(Wave);
end;

procedure Lib_WaveCrop(Wave: PWave; InitSample, FinalSample: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'WaveCrop';
procedure WaveCrop(Wave: PWave; InitSample, FinalSample: Integer);
begin
  Lib_WaveCrop(Wave, InitSample, FinalSample);
end;

procedure Lib_WaveFormat(Wave: PWave; SampleRate, SampleSize, Channels: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'WaveFormat';
procedure WaveFormat(Wave: PWave; SampleRate, SampleSize, Channels: Integer);
begin
  Lib_WaveFormat(Wave, SampleRate, SampleSize, Channels);
end;

function Lib_LoadWaveSamples(Wave: TWave): PSingle;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadWaveSamples';
function LoadWaveSamples(Wave: TWave): PSingle;
begin
  Result := Lib_LoadWaveSamples(Wave);
end;

procedure Lib_UnloadWaveSamples(Samples: PSingle);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadWaveSamples';
procedure UnloadWaveSamples(Samples: PSingle);
begin
  Lib_UnloadWaveSamples(Samples);
end;

// Music management functions

function Lib_LoadMusicStream(const FileName: PAnsiChar): TMusic;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadMusicStream';
function LoadMusicStream(const FileName: PAnsiChar): TMusic;
begin
  Result := Lib_LoadMusicStream(FileName);
end;

function Lib_LoadMusicStreamFromMemory(const FileType: PAnsiChar; const Data: PByte; DataSize: Integer): TMusic;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadMusicStreamFromMemory';
function LoadMusicStreamFromMemory(const FileType: PAnsiChar; const Data: PByte; DataSize: Integer): TMusic;
begin
  Result := Lib_LoadMusicStreamFromMemory(FileType, Data, DataSize);
end;

function Lib_IsMusicReady(Music: TMusic): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsMusicReady';
function IsMusicReady(Music: TMusic): Boolean;
begin
  Result := Lib_IsMusicReady(Music);
end;

procedure Lib_UnloadMusicStream(Music: TMusic);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadMusicStream';
procedure UnloadMusicStream(Music: TMusic);
begin
  Lib_UnloadMusicStream(Music);
end;

procedure Lib_PlayMusicStream(Music: TMusic);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'PlayMusicStream';
procedure PlayMusicStream(Music: TMusic);
begin
  Lib_PlayMusicStream(Music);
end;

function Lib_IsMusicStreamPlaying(Music: TMusic): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsMusicStreamPlaying';
function IsMusicStreamPlaying(Music: TMusic): Boolean;
begin
  Result := Lib_IsMusicStreamPlaying(Music);
end;

procedure Lib_UpdateMusicStream(Music: TMusic);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UpdateMusicStream';
procedure UpdateMusicStream(Music: TMusic);
begin
  Lib_UpdateMusicStream(Music);
end;

procedure Lib_StopMusicStream(Music: TMusic);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'StopMusicStream';
procedure StopMusicStream(Music: TMusic);
begin
  Lib_StopMusicStream(Music);
end;

procedure Lib_PauseMusicStream(Music: TMusic);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'PauseMusicStream';
procedure PauseMusicStream(Music: TMusic);
begin
  Lib_PauseMusicStream(Music);
end;

procedure Lib_ResumeMusicStream(Music: TMusic);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ResumeMusicStream';
procedure ResumeMusicStream(Music: TMusic);
begin
  Lib_ResumeMusicStream(Music);
end;

procedure Lib_SeekMusicStream(Music: TMusic; Position: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SeekMusicStream';
procedure SeekMusicStream(Music: TMusic; Position: Single);
begin
  Lib_SeekMusicStream(Music, Position);
end;

procedure Lib_SetMusicVolume(Music: TMusic; Volume: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetMusicVolume';
procedure SetMusicVolume(Music: TMusic; Volume: Single);
begin
  Lib_SetMusicVolume(Music, Volume);
end;

procedure Lib_SetMusicPitch(Music: TMusic; Pitch: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetMusicPitch';
procedure SetMusicPitch(Music: TMusic; Pitch: Single);
begin
  Lib_SetMusicPitch(Music, Pitch);
end;

procedure Lib_SetMusicPan(Music: TMusic; Pan: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetMusicPan';
procedure SetMusicPan(Music: TMusic; Pan: Single);
begin
  Lib_SetMusicPan(Music, Pan);
end;

function Lib_GetMusicTimeLength(Music: TMusic): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetMusicTimeLength';
function GetMusicTimeLength(Music: TMusic): Single;
begin
  Result := Lib_GetMusicTimeLength(Music);
end;

function Lib_GetMusicTimePlayed(Music: TMusic): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'GetMusicTimePlayed';
function GetMusicTimePlayed(Music: TMusic): Single;
begin
  Result := Lib_GetMusicTimePlayed(Music);
end;

// AudioStream management functions

function Lib_LoadAudioStream(SampleRate, SampleSize, Channels: Cardinal): TAudioStream;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'LoadAudioStream';
function LoadAudioStream(SampleRate, SampleSize, Channels: Cardinal): TAudioStream;
begin
  Result := Lib_LoadAudioStream(SampleRate, SampleSize, Channels);
end;

function Lib_IsAudioStreamReady(Stream: TAudioStream): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsAudioStreamReady';
function IsAudioStreamReady(Stream: TAudioStream): Boolean;
begin
  Result := Lib_IsAudioStreamReady(Stream);
end;

procedure Lib_UnloadAudioStream(Stream: TAudioStream);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UnloadAudioStream';
procedure UnloadAudioStream(Stream: TAudioStream);
begin
  Lib_UnloadAudioStream(Stream);
end;

procedure Lib_UpdateAudioStream(Stream: TAudioStream; const Data: Pointer; FrameCount: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'UpdateAudioStream';
procedure UpdateAudioStream(Stream: TAudioStream; const Data: Pointer; FrameCount: Integer);
begin
  Lib_UpdateAudioStream(Stream, Data, FrameCount);
end;

function Lib_IsAudioStreamProcessed(Stream: TAudioStream): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsAudioStreamProcessed';
function IsAudioStreamProcessed(Stream: TAudioStream): Boolean;
begin
  Result := Lib_IsAudioStreamProcessed(Stream);
end;

procedure Lib_PlayAudioStream(Stream: TAudioStream);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'PlayAudioStream';
procedure PlayAudioStream(Stream: TAudioStream);
begin
  Lib_PlayAudioStream(Stream);
end;

procedure Lib_PauseAudioStream(Stream: TAudioStream);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'PauseAudioStream';
procedure PauseAudioStream(Stream: TAudioStream);
begin
  Lib_PauseAudioStream(Stream);
end;

procedure Lib_ResumeAudioStream(Stream: TAudioStream);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'ResumeAudioStream';
procedure ResumeAudioStream(Stream: TAudioStream);
begin
  Lib_ResumeAudioStream(Stream);
end;

function Lib_IsAudioStreamPlaying(Stream: TAudioStream): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'IsAudioStreamPlaying';
function IsAudioStreamPlaying(Stream: TAudioStream): Boolean;
begin
  Result := Lib_IsAudioStreamPlaying(Stream);
end;

procedure Lib_StopAudioStream(Stream: TAudioStream);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'StopAudioStream';
procedure StopAudioStream(Stream: TAudioStream);
begin
  Lib_StopAudioStream(Stream);
end;

procedure Lib_SetAudioStreamVolume(Stream: TAudioStream; Volume: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetAudioStreamVolume';
procedure SetAudioStreamVolume(Stream: TAudioStream; Volume: Single);
begin
  Lib_SetAudioStreamVolume(Stream, Volume);
end;

procedure Lib_SetAudioStreamPitch(Stream: TAudioStream; Pitch: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetAudioStreamPitch';
procedure SetAudioStreamPitch(Stream: TAudioStream; Pitch: Single);
begin
  Lib_SetAudioStreamPitch(Stream, Pitch);
end;

procedure Lib_SetAudioStreamPan(Stream: TAudioStream; Pan: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetAudioStreamPan';
procedure SetAudioStreamPan(Stream: TAudioStream; Pan: Single);
begin
  Lib_SetAudioStreamPan(Stream, Pan);
end;

procedure Lib_SetAudioStreamBufferSizeDefault(Size: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetAudioStreamBufferSizeDefault';
procedure SetAudioStreamBufferSizeDefault(Size: Integer);
begin
  Lib_SetAudioStreamBufferSizeDefault(Size);
end;

procedure Lib_SetAudioStreamCallback(Stream: TAudioStream; Callback: TAudioCallback);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'SetAudioStreamCallback';
procedure SetAudioStreamCallback(Stream: TAudioStream; Callback: TAudioCallback);
begin
  Lib_SetAudioStreamCallback(Stream, Callback);
end;

procedure Lib_AttachAudioStreamProcessor(Stream: TAudioStream; Processor: TAudioCallback);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'AttachAudioStreamProcessor';
procedure AttachAudioStreamProcessor(Stream: TAudioStream; Processor: TAudioCallback);
begin
  Lib_AttachAudioStreamProcessor(Stream, Processor);
end;

procedure Lib_DetachAudioStreamProcessor(Stream: TAudioStream; Processor: TAudioCallback);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DetachAudioStreamProcessor';
procedure DetachAudioStreamProcessor(Stream: TAudioStream; Processor: TAudioCallback);
begin
  Lib_DetachAudioStreamProcessor(Stream, Processor);
end;

procedure Lib_AttachAudioMixedProcessor(Processor: TAudioCallback);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'AttachAudioMixedProcessor';
procedure AttachAudioMixedProcessor(Processor: TAudioCallback);
begin
  Lib_AttachAudioMixedProcessor(Processor);
end;

procedure Lib_DetachAudioMixedProcessor(Processor: TAudioCallback);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'DetachAudioMixedProcessor';
procedure DetachAudioMixedProcessor(Processor: TAudioCallback);
begin
  Lib_DetachAudioMixedProcessor(Processor);
end;

{ TVector2 }

constructor TVector2.Create(X, Y: Single);
begin
  Self.X := X;
  Self.Y := Y;
end;

{ TVector3 }

constructor TVector3.Create(X, Y, Z: Single);
begin
  Self.X := X;
  Self.Y := Y;
  Self.Z := Z;
end;

{ TVector4 }

constructor TVector4.Create(X, Y, Z, W: Single);
begin
  Self.X := X;
  Self.Y := Y;
  Self.Z := Z;
  Self.W := W;
end;

{ TColor }

constructor TColor.Create(R, G, B, A: Byte);
begin
  Self.R := R;
  Self.G := G;
  Self.B := B;
  Self.A := A;
end;

{ TRectangle }

constructor TRectangle.Create(X, Y, Width, Height: Single);
begin
  Self.X := X;
  Self.Y := Y;
  Self.Width := Width;
  Self.Height := Height;
end;

{ TBoundingBox }

constructor TBoundingBox.Create(Min, Max: TVector3);
begin
  Self.Min := Min;
  Self.Max := Max;
end;

{ TCamera3D }

constructor TCamera3D.Create(Position, Target, Up: TVector3; Fovy: Single; Projection: TCameraProjection);
begin
  Self.Position := Position;
  Self.Target := Target;
  Self.Up := Up;
  Self.Fovy := Fovy;
  Self.Projection := Projection;
end;

{ TCamera2D }

constructor TCamera2D.Create(Offset, Target: TVector2; Rotation, Zoom: Single);
begin
  Self.Offset := Offset;
  Self.Target := Target;
  Self.Rotation := Rotation;
  Self.Zoom := Zoom;
end;

{ TTransform }

constructor TTransform.Create(Translation: TVector3; Rotation: TQuaternion; Scale: TVector3);
begin
  Self.Translation := Translation;
  Self.Rotation := Rotation;
  Self.Scale := Scale;
end;

{ TImage }

constructor TImage.Create(Data: Pointer; Width, Height: Integer; Mipmaps: Integer; Format: TPixelFormat);
begin
  Self.Data := Data;
  Self.Width := Width;
  Self.Height := Height;
  Self.Mipmaps := Mipmaps;
  Self.Format := Format;
end;

{ TTexture }

constructor TTexture.Create(Id: Cardinal; Width, Height: Integer; Mipmaps: Integer; Format: TPixelFormat);
begin
  Self.Id := Id;
  Self.Width := Width;
  Self.Height := Height;
  Self.Mipmaps := Mipmaps;
  Self.Format := Format;
end;

{ TNPatchInfo }

constructor TNPatchInfo.Create(Source: TRectangle; Left, Top, Right, Bottom: Integer; Layout: TNPatchLayout);
begin
  Self.Source := Source;
  Self.Left := Left;
  Self.Top := Top;
  Self.Right := Right;
  Self.Bottom := Bottom;
  Self.Layout := Layout;
end;

initialization
  {$IFDEF FPC}
  SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);
  {$ELSE}
  FSetExceptMask(femALLEXCEPT);
  {$ENDIF}

end.
