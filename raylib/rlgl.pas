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
//  Original files: rlgl.h
//
//  Translator: @Turborium
//
//  Headers licensed under an unmodified MIT license, that allows static linking with closed source software
//
//  Copyright (c) 2022-2023 Turborium (https://github.com/turborium/TurboRaylib)
// -------------------------------------------------------------------------------------------------------------------

unit rlgl;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}
{$ALIGN 8}
{$MINENUMSIZE 4}

interface

{$IFNDEF INDEPNDENT_RLGL}
uses
  raylib;
{$ENDIF}

{$INCLUDE raylib.inc}

const
  RLGL_VERSION = 4.5;

{$IF not Declared(LibName)}
const
  LibName = {$IFDEF MSWINDOWS}'raylib.dll'{$IFEND}{$IFDEF DARWIN}'libraylib.dylib'{$IFEND}{$IFDEF LINUX}'libraylib.so'{$IFEND};
{$ENDIF}

//----------------------------------------------------------------------------------
// Defines and Macros
//----------------------------------------------------------------------------------

{$IFNDEF CPUARM}
  {$DEFINE DESKTOP_OPENGL}
{$ELSE}
  {$IF (not Defined(IOS)) And (not Defined(ANDROID))}
    {$DEFINE DESKTOP_OPENGL}
  {$ENDIF}
{$ENDIF}

// Default internal render batch elements limits
const
  // This is the maximum amount of elements (quads) per batch
  {$IFDEF DESKTOP_OPENGL}
  RL_DEFAULT_BATCH_BUFFER_ELEMENTS   = 8192;
  {$ELSE}
  RL_DEFAULT_BATCH_BUFFER_ELEMENTS   = 2048;
  {$ENDIF}
  // Default number of batch buffers (multi-buffering)
  RL_DEFAULT_BATCH_BUFFERS           = 1;
  // Default number of batch draw calls (by state changes: mode, texture)
  RL_DEFAULT_BATCH_DRAWCALLS         = 256;
  // Maximum number of textures units that can be activated on batch drawing (SetShaderValueTexture())
  RL_DEFAULT_BATCH_MAX_TEXTURE_UNITS = 4;
  // Maximum size of Matrix stack
  RL_MAX_MATRIX_STACK_SIZE           = 32;
  // Maximum number of shader locations supported
  RL_MAX_SHADER_LOCATIONS            = 32;
  // Default near cull distance
  RL_CULL_DISTANCE_NEAR              = 0.01;
  // Default far cull distance
  RL_CULL_DISTANCE_FAR               = 1000.0;

  // Texture parameters (equivalent to OpenGL defines)
  RL_TEXTURE_WRAP_S                    = $2802; // GL_TEXTURE_WRAP_S
  RL_TEXTURE_WRAP_T                    = $2803; // GL_TEXTURE_WRAP_T
  RL_TEXTURE_MAG_FILTER                = $2800; // GL_TEXTURE_MAG_FILTER
  RL_TEXTURE_MIN_FILTER                = $2801; // GL_TEXTURE_MIN_FILTER
  RL_TEXTURE_FILTER_NEAREST            = $2600; // GL_NEAREST
  RL_TEXTURE_FILTER_LINEAR             = $2601; // GL_LINEAR
  RL_TEXTURE_FILTER_MIP_NEAREST        = $2700; // GL_NEAREST_MIPMAP_NEAREST
  RL_TEXTURE_FILTER_NEAREST_MIP_LINEAR = $2702; // GL_NEAREST_MIPMAP_LINEAR
  RL_TEXTURE_FILTER_LINEAR_MIP_NEAREST = $2701; // GL_LINEAR_MIPMAP_NEAREST
  RL_TEXTURE_FILTER_MIP_LINEAR         = $2703; // GL_LINEAR_MIPMAP_LINEAR
  RL_TEXTURE_FILTER_ANISOTROPIC        = $3000; // Anisotropic filter (custom identifier)
  RL_TEXTURE_MIPMAP_BIAS_RATIO         = $4000; // Texture mipmap bias, percentage ratio (custom identifier)

  RL_TEXTURE_WRAP_REPEAT               = $2901; // GL_REPEAT
  RL_TEXTURE_WRAP_CLAMP                = $812F; // GL_CLAMP_TO_EDGE
  RL_TEXTURE_WRAP_MIRROR_REPEAT        = $8370; // GL_MIRRORED_REPEAT
  RL_TEXTURE_WRAP_MIRROR_CLAMP         = $8742; // GL_MIRROR_CLAMP_EXT

// Matrix modes (equivalent to OpenGL)
type
  PRlMatrixMode = ^TRlMatrixMode;
  TRlMatrixMode = Integer;
const
  RL_MODELVIEW  = TRlMatrixMode($1700); // GL_MODELVIEW
  RL_PROJECTION = TRlMatrixMode($1701); // GL_PROJECTION
  RL_TEXTURE    = TRlMatrixMode($1702); // GL_TEXTURE

// Primitive assembly draw modes
type
  PRlDrawMode = ^TRlDrawMode;
  TRlDrawMode = Integer;
const
  RL_LINES     = TRlDrawMode($0001); // GL_LINES
  RL_TRIANGLES = TRlDrawMode($0004); // GL_TRIANGLES
  RL_QUADS     = TRlDrawMode($0007); // GL_QUADS

  // GL equivalent data types
  RL_UNSIGNED_BYTE                     = $1401; // GL_UNSIGNED_BYTE
  RL_FLOAT                             = $1406; // GL_FLOAT

  // GL buffer usage hint
  RL_STREAM_DRAW                       = $88E0; // GL_STREAM_DRAW
  RL_STREAM_READ                       = $88E1; // GL_STREAM_READ
  RL_STREAM_COPY                       = $88E2; // GL_STREAM_COPY
  RL_STATIC_DRAW                       = $88E4; // GL_STATIC_DRAW
  RL_STATIC_READ                       = $88E5; // GL_STATIC_READ
  RL_STATIC_COPY                       = $88E6; // GL_STATIC_COPY
  RL_DYNAMIC_DRAW                      = $88E8; // GL_DYNAMIC_DRAW
  RL_DYNAMIC_READ                      = $88E9; // GL_DYNAMIC_READ
  RL_DYNAMIC_COPY                      = $88EA; // GL_DYNAMIC_COPY

  // GL Shader type
  RL_FRAGMENT_SHADER                   = $8B30; // GL_FRAGMENT_SHADER
  RL_VERTEX_SHADER                     = $8B31; // GL_VERTEX_SHADER
  RL_COMPUTE_SHADER                    = $91B9; // GL_COMPUTE_SHADER

  // GL blending factors
  RL_ZERO                              = 0;     // GL_ZERO
  RL_ONE                               = 1;     // GL_ONE
  RL_SRC_COLOR                         = $0300; // GL_SRC_COLOR
  RL_ONE_MINUS_SRC_COLOR               = $0301; // GL_ONE_MINUS_SRC_COLOR
  RL_SRC_ALPHA                         = $0302; // GL_SRC_ALPHA
  RL_ONE_MINUS_SRC_ALPHA               = $0303; // GL_ONE_MINUS_SRC_ALPHA
  RL_DST_ALPHA                         = $0304; // GL_DST_ALPHA
  RL_ONE_MINUS_DST_ALPHA               = $0305; // GL_ONE_MINUS_DST_ALPHA
  RL_DST_COLOR                         = $0306; // GL_DST_COLOR
  RL_ONE_MINUS_DST_COLOR               = $0307; // GL_ONE_MINUS_DST_COLOR
  RL_SRC_ALPHA_SATURATE                = $0308; // GL_SRC_ALPHA_SATURATE
  RL_CONSTANT_COLOR                    = $8001; // GL_CONSTANT_COLOR
  RL_ONE_MINUS_CONSTANT_COLOR          = $8002; // GL_ONE_MINUS_CONSTANT_COLOR
  RL_CONSTANT_ALPHA                    = $8003; // GL_CONSTANT_ALPHA
  RL_ONE_MINUS_CONSTANT_ALPHA          = $8004; // GL_ONE_MINUS_CONSTANT_ALPHA

  // GL blending functions/equations
  RL_FUNC_ADD                          = $8006; // GL_FUNC_ADD
  RL_MIN                               = $8007; // GL_MIN
  RL_MAX                               = $8008; // GL_MAX
  RL_FUNC_SUBTRACT                     = $800A; // GL_FUNC_SUBTRACT
  RL_FUNC_REVERSE_SUBTRACT             = $800B; // GL_FUNC_REVERSE_SUBTRACT
  RL_BLEND_EQUATION                    = $8009; // GL_BLEND_EQUATION
  RL_BLEND_EQUATION_RGB                = $8009; // GL_BLEND_EQUATION_RGB   // (Same as BLEND_EQUATION)
  RL_BLEND_EQUATION_ALPHA              = $883D; // GL_BLEND_EQUATION_ALPHA
  RL_BLEND_DST_RGB                     = $80C8; // GL_BLEND_DST_RGB
  RL_BLEND_SRC_RGB                     = $80C9; // GL_BLEND_SRC_RGB
  RL_BLEND_DST_ALPHA                   = $80CA; // GL_BLEND_DST_ALPHA
  RL_BLEND_SRC_ALPHA                   = $80CB; // GL_BLEND_SRC_ALPHA
  RL_BLEND_COLOR                       = $8005; // GL_BLEND_COLOR

//----------------------------------------------------------------------------------
// Types and Structures Definition
//----------------------------------------------------------------------------------

// Matrix, 4x4 components, column major, OpenGL style, right handed
{$IF not Declared(TMatrix)}
type
  PRlMatrix = ^TRlMatrix;
  TRlMatrix = record
    M0, M4, M8, M12: Single;  // Matrix first row (4 components)
    M1, M5, M9, M13: Single;  // Matrix second row (4 components)
    M2, M6, M10, M14: Single; // Matrix third row (4 components)
    M3, M7, M11, M15: Single; // Matrix fourth row (4 components)
  end;
{$ELSE}
type
  TRlMatrix = raylib.TMatrix;
{$ENDIF}

// Dynamic vertex buffers (position + texcoords + colors + indices arrays)
type
  PRlVertexBuffer = ^TRlVertexBuffer;
  TRlVertexBuffer = record
    ElementCount: Integer;          // Number of elements in the buffer (QUADS)
    Vertices: PSingle;              // Vertex position (XYZ - 3 components per vertex) (shader-location = 0)
    Texcoords: PSingle;             // Vertex texture coordinates (UV - 2 components per vertex) (shader-location = 1)
    Colors: PByte;                  // Vertex colors (RGBA - 4 components per vertex) (shader-location = 3)
    {$IFDEF DESKTOP_OPENGL}
    Indices: PCardinal;             // Vertex indices (in case vertex data comes indexed) (6 indices per quad)
    {$ELSE}
    Indices: PWord;                 // Vertex indices (in case vertex data comes indexed) (6 indices per quad)
    {$ENDIF}
    VaoId: Cardinal;                // OpenGL Vertex Array Object id
    VboId: array[0..3] of Cardinal; // OpenGL Vertex Buffer Objects id (4 types of vertex data)
  end;

// Draw call type
// NOTE: Only texture changes register a new draw, other state-change-related elements are not
// used at this moment (vaoId, shaderId, matrices), raylib just forces a batch draw call if any
// of those state-change happens (this is done in core module)
type
  PRlDrawCall = ^TRlDrawCall;
  TRlDrawCall = record
    Mode: Integer;            // Drawing mode: LINES, TRIANGLES, QUADS
    VertexCount: Integer;     // Number of vertex of the draw
    VertexAlignment: Integer; // Number of vertex required for index alignment (LINES, TRIANGLES)
    TextureId: Cardinal;      // Texture id to be used on the draw -> Use to create new draw call if changes
  end;

// rlRenderBatch type
type
  PRlRenderBatch = ^TRlRenderBatch;
  TRlRenderBatch = record
    BufferCount: Integer;          // Number of vertex buffers (multi-buffering support)
    CurrentBuffer: Integer;        // Current buffer tracking in case of multi-buffering
    VertexBuffer: PRlVertexBuffer; // Dynamic buffer(s) for vertex data
    Draws: PRlDrawCall;            // Draw calls array, depends on textureId
    DrawCounter: Integer;          // Draw calls counter
    CurrentDepth: Single;          // Current depth value for next draw
  end;

// OpenGL version
type
  PRlGlVersion = ^TRlGlVersion;
  TRlGlVersion = Integer;
const
  OPENGL_11 = TRlGlVersion(1);
  OPENGL_21 = TRlGlVersion(2);
  OPENGL_33 = TRlGlVersion(3);
  OPENGL_43 = TRlGlVersion(4);
  OPENGL_ES_20 = TRlGlVersion(5);

// Trace log level
// NOTE: Organized by priority level
type
  PRlTraceLogLevel = ^TRlTraceLogLevel;
  TRlTraceLogLevel = Integer;
const
  RL_LOG_ALL     = TRlTraceLogLevel(0); // Display all logs
  RL_LOG_TRACE   = TRlTraceLogLevel(1); // Trace logging, intended for internal use only
  RL_LOG_DEBUG   = TRlTraceLogLevel(2); // Debug logging, used for internal debugging, it should be disabled on release builds
  RL_LOG_INFO    = TRlTraceLogLevel(3); // Info logging, used for program execution info
  RL_LOG_WARNING = TRlTraceLogLevel(4); // Warning logging, used on recoverable failures
  RL_LOG_ERROR   = TRlTraceLogLevel(5); // Error logging, used on unrecoverable failures
  RL_LOG_FATAL   = TRlTraceLogLevel(6); // Fatal logging, used to abort program: exit(EXIT_FAILURE)
  RL_LOG_NONE    = TRlTraceLogLevel(7); // Disable logging

// Texture formats
// NOTE: Support depends on OpenGL version
type
  PRlPixelFormat = ^TRlPixelFormat;
  TRlPixelFormat = Integer;
const
  RL_PIXELFORMAT_UNCOMPRESSED_GRAYSCALE    = TRlPixelFormat(1);  // 8 bit per pixel (no alpha)
  RL_PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA   = TRlPixelFormat(2);  // 8*2 bpp (2 channels)
  RL_PIXELFORMAT_UNCOMPRESSED_R5G6B5       = TRlPixelFormat(3);  // 16 bpp
  RL_PIXELFORMAT_UNCOMPRESSED_R8G8B8       = TRlPixelFormat(4);  // 24 bpp
  RL_PIXELFORMAT_UNCOMPRESSED_R5G5B5A1     = TRlPixelFormat(5);  // 16 bpp (1 bit alpha)
  RL_PIXELFORMAT_UNCOMPRESSED_R4G4B4A4     = TRlPixelFormat(6);  // 16 bpp (4 bit alpha)
  RL_PIXELFORMAT_UNCOMPRESSED_R8G8B8A8     = TRlPixelFormat(7);  // 32 bpp
  RL_PIXELFORMAT_UNCOMPRESSED_R32          = TRlPixelFormat(8);  // 32 bpp (1 channel - float)
  RL_PIXELFORMAT_UNCOMPRESSED_R32G32B32    = TRlPixelFormat(9);  // 32*3 bpp (3 channels - float)
  RL_PIXELFORMAT_UNCOMPRESSED_R32G32B32A32 = TRlPixelFormat(10); // 32*4 bpp (4 channels - float)
  RL_PIXELFORMAT_COMPRESSED_DXT1_RGB       = TRlPixelFormat(11); // 4 bpp (no alpha)
  RL_PIXELFORMAT_COMPRESSED_DXT1_RGBA      = TRlPixelFormat(12); // 4 bpp (1 bit alpha)
  RL_PIXELFORMAT_COMPRESSED_DXT3_RGBA      = TRlPixelFormat(13); // 8 bpp
  RL_PIXELFORMAT_COMPRESSED_DXT5_RGBA      = TRlPixelFormat(14); // 8 bpp
  RL_PIXELFORMAT_COMPRESSED_ETC1_RGB       = TRlPixelFormat(15); // 4 bpp
  RL_PIXELFORMAT_COMPRESSED_ETC2_RGB       = TRlPixelFormat(16); // 4 bpp
  RL_PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA  = TRlPixelFormat(17); // 8 bpp
  RL_PIXELFORMAT_COMPRESSED_PVRT_RGB       = TRlPixelFormat(18); // 4 bpp
  RL_PIXELFORMAT_COMPRESSED_PVRT_RGBA      = TRlPixelFormat(19); // 4 bpp
  RL_PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA  = TRlPixelFormat(20); // 8 bpp
  RL_PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA  = TRlPixelFormat(21); // 2 bpp

// Texture parameters: filter mode
// NOTE 1: Filtering considers mipmaps if available in the texture
// NOTE 2: Filter is accordingly set for minification and magnification
type
  PRlTextureFilter = ^TRlTextureFilter;
  TRlTextureFilter = Integer;
const
  RL_TEXTURE_FILTER_POINT           = TRlTextureFilter(0); // No filter, just pixel approximation
  RL_TEXTURE_FILTER_BILINEAR        = TRlTextureFilter(1); // Linear filtering
  RL_TEXTURE_FILTER_TRILINEAR       = TRlTextureFilter(2); // Trilinear filtering (linear with mipmaps)
  RL_TEXTURE_FILTER_ANISOTROPIC_4X  = TRlTextureFilter(3); // Anisotropic filtering 4x
  RL_TEXTURE_FILTER_ANISOTROPIC_8X  = TRlTextureFilter(4); // Anisotropic filtering 8x
  RL_TEXTURE_FILTER_ANISOTROPIC_16X = TRlTextureFilter(5); // Anisotropic filtering 16x

// Color blending modes (pre-defined)
type
  PRlBlendMode = ^TRlBlendMode;
  TRlBlendMode = Integer;
const
  RL_BLEND_ALPHA           = TRlBlendMode(0); // Blend textures considering alpha (default)
  RL_BLEND_ADDITIVE        = TRlBlendMode(1); // Blend textures adding colors
  RL_BLEND_MULTIPLIED      = TRlBlendMode(2); // Blend textures multiplying colors
  RL_BLEND_ADD_COLORS      = TRlBlendMode(3); // Blend textures adding colors (alternative)
  RL_BLEND_SUBTRACT_COLORS = TRlBlendMode(4); // Blend textures subtracting colors (alternative)
  RL_BLEND_ALPHA_PREMUL    = TRlBlendMode(5); // Blend premultiplied textures considering alpha
  RL_BLEND_CUSTOM          = TRlBlendMode(6); // Blend textures using custom src/dst factors (use rlSetBlendFactors())
  RL_BLEND_CUSTOM_SEPARATE = TRlBlendMode(7); // Blend textures using custom src/dst factors (use rlSetBlendFactorsSeparate())

// Shader location point type
type
  PRlShaderLocationIndex = ^TRlShaderLocationIndex;
  TRlShaderLocationIndex = Integer;
const
  RL_SHADER_LOC_VERTEX_POSITION   = TRlShaderLocationIndex(0);  // Shader location: vertex attribute: position
  RL_SHADER_LOC_VERTEX_TEXCOORD01 = TRlShaderLocationIndex(1);  // Shader location: vertex attribute: texcoord01
  RL_SHADER_LOC_VERTEX_TEXCOORD02 = TRlShaderLocationIndex(2);  // Shader location: vertex attribute: texcoord02
  RL_SHADER_LOC_VERTEX_NORMAL     = TRlShaderLocationIndex(3);  // Shader location: vertex attribute: normal
  RL_SHADER_LOC_VERTEX_TANGENT    = TRlShaderLocationIndex(4);  // Shader location: vertex attribute: tangent
  RL_SHADER_LOC_VERTEX_COLOR      = TRlShaderLocationIndex(5);  // Shader location: vertex attribute: color
  RL_SHADER_LOC_MATRIX_MVP        = TRlShaderLocationIndex(6);  // Shader location: matrix uniform: model-view-projection
  RL_SHADER_LOC_MATRIX_VIEW       = TRlShaderLocationIndex(7);  // Shader location: matrix uniform: view (camera transform)
  RL_SHADER_LOC_MATRIX_PROJECTION = TRlShaderLocationIndex(8);  // Shader location: matrix uniform: projection
  RL_SHADER_LOC_MATRIX_MODEL      = TRlShaderLocationIndex(9);  // Shader location: matrix uniform: model (transform)
  RL_SHADER_LOC_MATRIX_NORMAL     = TRlShaderLocationIndex(10); // Shader location: matrix uniform: normal
  RL_SHADER_LOC_VECTOR_VIEW       = TRlShaderLocationIndex(11); // Shader location: vector uniform: view
  RL_SHADER_LOC_COLOR_DIFFUSE     = TRlShaderLocationIndex(12); // Shader location: vector uniform: diffuse color
  RL_SHADER_LOC_COLOR_SPECULAR    = TRlShaderLocationIndex(13); // Shader location: vector uniform: specular color
  RL_SHADER_LOC_COLOR_AMBIENT     = TRlShaderLocationIndex(14); // Shader location: vector uniform: ambient color
  RL_SHADER_LOC_MAP_ALBEDO        = TRlShaderLocationIndex(15); // Shader location: sampler2d texture: albedo (same as: RL_SHADER_LOC_MAP_DIFFUSE)
  RL_SHADER_LOC_MAP_METALNESS     = TRlShaderLocationIndex(16); // Shader location: sampler2d texture: metalness (same as: RL_SHADER_LOC_MAP_SPECULAR)
  RL_SHADER_LOC_MAP_NORMAL        = TRlShaderLocationIndex(17); // Shader location: sampler2d texture: normal
  RL_SHADER_LOC_MAP_ROUGHNESS     = TRlShaderLocationIndex(18); // Shader location: sampler2d texture: roughness
  RL_SHADER_LOC_MAP_OCCLUSION     = TRlShaderLocationIndex(19); // Shader location: sampler2d texture: occlusion
  RL_SHADER_LOC_MAP_EMISSION      = TRlShaderLocationIndex(20); // Shader location: sampler2d texture: emission
  RL_SHADER_LOC_MAP_HEIGHT        = TRlShaderLocationIndex(21); // Shader location: sampler2d texture: height
  RL_SHADER_LOC_MAP_CUBEMAP       = TRlShaderLocationIndex(22); // Shader location: samplerCube texture: cubemap
  RL_SHADER_LOC_MAP_IRRADIANCE    = TRlShaderLocationIndex(23); // Shader location: samplerCube texture: irradiance
  RL_SHADER_LOC_MAP_PREFILTER     = TRlShaderLocationIndex(24); // Shader location: samplerCube texture: prefilter
  RL_SHADER_LOC_MAP_BRDF          = TRlShaderLocationIndex(25); // Shader location: sampler2d texture: brdf
  RL_SHADER_LOC_MAP_DIFFUSE       = RL_SHADER_LOC_MAP_ALBEDO;
  RL_SHADER_LOC_MAP_SPECULAR      = RL_SHADER_LOC_MAP_METALNESS;

// Shader uniform data type
type
  PRlShaderUniformDataType = ^TRlShaderUniformDataType;
  TRlShaderUniformDataType = Integer;
const
  RL_SHADER_UNIFORM_FLOAT     = TRlShaderUniformDataType(0); // Shader uniform type: float
  RL_SHADER_UNIFORM_VEC2      = TRlShaderUniformDataType(1); // Shader uniform type: vec2 (2 float)
  RL_SHADER_UNIFORM_VEC3      = TRlShaderUniformDataType(2); // Shader uniform type: vec3 (3 float)
  RL_SHADER_UNIFORM_VEC4      = TRlShaderUniformDataType(3); // Shader uniform type: vec4 (4 float)
  RL_SHADER_UNIFORM_INT       = TRlShaderUniformDataType(4); // Shader uniform type: int
  RL_SHADER_UNIFORM_IVEC2     = TRlShaderUniformDataType(5); // Shader uniform type: ivec2 (2 int)
  RL_SHADER_UNIFORM_IVEC3     = TRlShaderUniformDataType(6); // Shader uniform type: ivec3 (3 int)
  RL_SHADER_UNIFORM_IVEC4     = TRlShaderUniformDataType(7); // Shader uniform type: ivec4 (4 int)
  RL_SHADER_UNIFORM_SAMPLER2D = TRlShaderUniformDataType(8); // Shader uniform type: sampler2d

// Shader attribute data types
type
  PRlShaderAttributeDataType = ^TRlShaderAttributeDataType;
  TRlShaderAttributeDataType = Integer;
const
  RL_SHADER_ATTRIB_FLOAT = TRlShaderAttributeDataType(0); // Shader attribute type: float
  RL_SHADER_ATTRIB_VEC2  = TRlShaderAttributeDataType(1); // Shader attribute type: vec2 (2 float)
  RL_SHADER_ATTRIB_VEC3  = TRlShaderAttributeDataType(2); // Shader attribute type: vec3 (3 float)
  RL_SHADER_ATTRIB_VEC4  = TRlShaderAttributeDataType(3); // Shader attribute type: vec4 (4 float)

// Framebuffer attachment type
// NOTE: By default up to 8 color channels defined, but it can be more
type
  PRlFramebufferAttachType = ^TRlFramebufferAttachType;
  TRlFramebufferAttachType = Integer;
const
  RL_ATTACHMENT_COLOR_CHANNEL0 = TRlFramebufferAttachType(0);   // Framebuffer attachment type: color 0
  RL_ATTACHMENT_COLOR_CHANNEL1 = TRlFramebufferAttachType(1);   // Framebuffer attachment type: color 1
  RL_ATTACHMENT_COLOR_CHANNEL2 = TRlFramebufferAttachType(2);   // Framebuffer attachment type: color 2
  RL_ATTACHMENT_COLOR_CHANNEL3 = TRlFramebufferAttachType(3);   // Framebuffer attachment type: color 3
  RL_ATTACHMENT_COLOR_CHANNEL4 = TRlFramebufferAttachType(4);   // Framebuffer attachment type: color 4
  RL_ATTACHMENT_COLOR_CHANNEL5 = TRlFramebufferAttachType(5);   // Framebuffer attachment type: color 5
  RL_ATTACHMENT_COLOR_CHANNEL6 = TRlFramebufferAttachType(6);   // Framebuffer attachment type: color 6
  RL_ATTACHMENT_COLOR_CHANNEL7 = TRlFramebufferAttachType(7);   // Framebuffer attachment type: color 7
  RL_ATTACHMENT_DEPTH          = TRlFramebufferAttachType(100); // Framebuffer attachment type: depth
  RL_ATTACHMENT_STENCIL        = TRlFramebufferAttachType(200); // Framebuffer attachment type: stencil

// Framebuffer texture attachment type
type
  PRlFramebufferAttachTextureType = ^TRlFramebufferAttachTextureType;
  TRlFramebufferAttachTextureType = Integer;
const
  RL_ATTACHMENT_CUBEMAP_POSITIVE_X = TRlFramebufferAttachTextureType(0);   // Framebuffer texture attachment type: cubemap, +X side
  RL_ATTACHMENT_CUBEMAP_NEGATIVE_X = TRlFramebufferAttachTextureType(1);   // Framebuffer texture attachment type: cubemap, -X side
  RL_ATTACHMENT_CUBEMAP_POSITIVE_Y = TRlFramebufferAttachTextureType(2);   // Framebuffer texture attachment type: cubemap, +Y side
  RL_ATTACHMENT_CUBEMAP_NEGATIVE_Y = TRlFramebufferAttachTextureType(3);   // Framebuffer texture attachment type: cubemap, -Y side
  RL_ATTACHMENT_CUBEMAP_POSITIVE_Z = TRlFramebufferAttachTextureType(4);   // Framebuffer texture attachment type: cubemap, +Z side
  RL_ATTACHMENT_CUBEMAP_NEGATIVE_Z = TRlFramebufferAttachTextureType(5);   // Framebuffer texture attachment type: cubemap, -Z side
  RL_ATTACHMENT_TEXTURE2D          = TRlFramebufferAttachTextureType(100); // Framebuffer texture attachment type: texture2d
  RL_ATTACHMENT_RENDERBUFFER       = TRlFramebufferAttachTextureType(200); // Framebuffer texture attachment type: renderbuffer

// Face culling mode
type
  PRlCullMode = ^TRlCullMode;
  TRlCullMode = Integer;
const
  RL_CULL_FACE_FRONT = TRlCullMode(0);
  RL_CULL_FACE_BACK = TRlCullMode(1);

//------------------------------------------------------------------------------------
// Functions Declaration - Matrix operations
//------------------------------------------------------------------------------------

// Choose the current matrix to be transformed
procedure rlMatrixMode(Mode: TRlMatrixMode);
// Push the current matrix to stack
procedure rlPushMatrix();
// Pop latest inserted matrix from stack
procedure rlPopMatrix();
// Reset current matrix to identity matrix
procedure rlLoadIdentity();
// Multiply the current matrix by a translation matrix
procedure rlTranslatef(X, Y, Z: Single);
// Multiply the current matrix by a rotation matrix
procedure rlRotatef(Angle, X, Y, Z: Single);
// Multiply the current matrix by a scaling matrix
procedure rlScalef(X, Y, Z: Single);
// Multiply the current matrix by another matrix
procedure rlMultMatrixf(const Matf: PSingle);
// rlFrustum
procedure rlFrustum(Left, Right, Bottom, Top, Znear, Zfar: Double);
// rlOrtho
procedure rlOrtho(Left, Right, Bottom, Top, Znear, Zfar: Double);
// Set the viewport area
procedure rlViewport(X, Y, Width, Height: Integer);

//------------------------------------------------------------------------------------
// Functions Declaration - Vertex level operations
//------------------------------------------------------------------------------------

// Initialize drawing mode (how to organize vertex)
procedure rlBegin(Mode: TRlDrawMode);
// Finish vertex providing
procedure rlEnd();
// Define one vertex (position) - 2 int
procedure rlVertex2i(X, Y: Integer);
// Define one vertex (position) - 2 float
procedure rlVertex2f(X, Y: Single);
// Define one vertex (position) - 3 float
procedure rlVertex3f(X, Y, Z: Single);
// Define one vertex (texture coordinate) - 2 float
procedure rlTexCoord2f(X, Y: Single);
// Define one vertex (normal) - 3 float
procedure rlNormal3f(X, Y, Z: Single);
// Define one vertex (color) - 4 byte
procedure rlColor4ub(R, G, B, A: Byte);
// Define one vertex (color) - 3 float
procedure rlColor3f(X, Y, Z: Single);
// Define one vertex (color) - 4 float
procedure rlColor4f(X, Y, Z, W: Single);

//------------------------------------------------------------------------------------
// Functions Declaration - OpenGL style functions (common to 1.1, 3.3+, ES2)
// NOTE: This functions are used to completely abstract raylib code from OpenGL layer,
// some of them are direct wrappers over OpenGL calls, some others are custom
//------------------------------------------------------------------------------------

// Vertex buffers state

// Enable vertex array (VAO, if supported)
function rlEnableVertexArray(VaoId: Cardinal): Boolean;
// Disable vertex array (VAO, if supported)
procedure rlDisableVertexArray();
// Enable vertex buffer (VBO)
procedure rlEnableVertexBuffer(Id: Cardinal);
// Disable vertex buffer (VBO)
procedure rlDisableVertexBuffer();
// Enable vertex buffer element (VBO element)
procedure rlEnableVertexBufferElement(Id: Cardinal);
// Disable vertex buffer element (VBO element)
procedure rlDisableVertexBufferElement();
// Enable vertex attribute index
procedure rlEnableVertexAttribute(Index: Cardinal);
// Disable vertex attribute index
procedure rlDisableVertexAttribute(Index: Cardinal);
{$IFDEF DESKTOP_OPENGL}
// Enable attribute state pointer
// procedure rlEnableStatePointer(VertexAttribType: Integer; Buffer: Pointer);
// Disable attribute state pointer
// procedure rlDisableStatePointer(VertexAttribType: Integer);
{$ENDIF}

// Textures state

// Select and active a texture slot
procedure rlActiveTextureSlot(Slot: Integer);
// Enable texture
procedure rlEnableTexture(Id: Cardinal);
// Disable texture
procedure rlDisableTexture();
// Enable texture cubemap
procedure rlEnableTextureCubemap(Id: Cardinal);
// Disable texture cubemap
procedure rlDisableTextureCubemap();
// Set texture parameters (filter, wrap)
procedure rlTextureParameters(Id: Cardinal; Param: Integer; Value: Integer);
// Set cubemap parameters (filter, wrap)
procedure rlCubemapParameters(Id: Cardinal; Param: Integer; Value: Integer);

// Shader state

// Enable shader program
procedure rlEnableShader(Id: Cardinal);
// Disable shader program
procedure rlDisableShader();

// Framebuffer state

// Enable render texture (fbo)
procedure rlEnableFramebuffer(Id: Cardinal);
// Disable render texture (fbo), return to default framebuffer
procedure rlDisableFramebuffer();
// Activate multiple draw color buffers
procedure rlActiveDrawBuffers(Count: Integer);

// General render state

// Enable color blending
procedure rlEnableColorBlend();
// Disable color blending
procedure rlDisableColorBlend();
// Enable depth test
procedure rlEnableDepthTest();
// Disable depth test
procedure rlDisableDepthTest();
// Enable depth write
procedure rlEnableDepthMask();
// Disable depth write
procedure rlDisableDepthMask();
// Enable backface culling
procedure rlEnableBackfaceCulling();
// Disable backface culling
procedure rlDisableBackfaceCulling();
// Set face culling mode
procedure rlSetCullFace(Mode: TRlCullMode);
// Enable scissor test
procedure rlEnableScissorTest();
// Disable scissor test
procedure rlDisableScissorTest();
// Scissor test
procedure rlScissor(X, Y, Width, Height: Integer);
// Enable wire mode
procedure rlEnableWireMode();
// Disable wire mode
procedure rlDisableWireMode();
// Set the line drawing width
procedure rlSetLineWidth(Width: Single);
// Get the line drawing width
function rlGetLineWidth(): Single;
// Enable line aliasing
procedure rlEnableSmoothLines();
// Disable line aliasing
procedure rlDisableSmoothLines();
// Enable stereo rendering
procedure rlEnableStereoRender();
// Disable stereo rendering
procedure rlDisableStereoRender();
// Check if stereo render is enabled
function rlIsStereoRenderEnabled(): Boolean;

// Clear color buffer with color
procedure rlClearColor(R, G, B, A: Byte);
// Clear used screen buffers (color and depth)
procedure rlClearScreenBuffers();
// Check and log OpenGL error codes
procedure rlCheckErrors();
// Set blending mode
procedure rlSetBlendMode(Mode: TRlBlendMode);
// Set blending mode factor and equation (using OpenGL factors)
procedure rlSetBlendFactors(GlSrcFactor, GlDstFactor, GlEquation: Integer);
// Set blending mode factors and equations separately (using OpenGL factors)
procedure rlSetBlendFactorsSeparate(GlSrcRGB, GlDstRGB, GlSrcAlpha, GlDstAlpha, GlEqRGB, GlEqAlpha: Integer);

//------------------------------------------------------------------------------------
// Functions Declaration - rlgl functionality
//------------------------------------------------------------------------------------

// rlgl initialization functions

// Initialize rlgl (buffers, shaders, textures, states)
procedure rlglInit(Width, Height: Integer);
// De-initialize rlgl (buffers, shaders, textures)
procedure rlglClose();
// Load OpenGL extensions (loader function required)
procedure rlLoadExtensions(Loader: Pointer);
// Get current OpenGL version
function rlGetVersion(): TRlGlVersion;
// Set current framebuffer width
procedure rlSetFramebufferWidth(Width: Integer);
// Get default framebuffer width
function rlGetFramebufferWidth(): Integer;
// Set current framebuffer height
procedure rlSetFramebufferHeight(Weight: Integer);
// Get default framebuffer height
function rlGetFramebufferHeight(): Integer;

// Get default texture id
function rlGetTextureIdDefault(): Cardinal;
// Get default shader id
function rlGetShaderIdDefault(): Cardinal;
// Get default shader locations
function rlGetShaderLocsDefault(): PInteger;

// Render batch management
// NOTE: rlgl provides a default render batch to behave like OpenGL 1.1 immediate mode
// but this render batch API is exposed in case of custom batches are required

// Load a render batch system
function rlLoadRenderBatch(NumBuffers, BufferElements: Integer): TRlRenderBatch;
// Unload render batch system
procedure rlUnloadRenderBatch(Batch: TRlRenderBatch);
// Draw render batch data (Update->Draw->Reset)
procedure rlDrawRenderBatch(Batch: PRlRenderBatch);
// Set the active render batch for rlgl (NULL for default internal)
procedure rlSetRenderBatchActive(Batch: PRlRenderBatch);
// Update and draw internal render batch
procedure rlDrawRenderBatchActive();
// Check internal buffer overflow for a given number of vertex
function rlCheckRenderBatchLimit(VCount: Integer): Boolean;
// Set current texture for render batch and check buffers limits
procedure rlSetTexture(Id: Cardinal);

//------------------------------------------------------------------------------------------------------------------------

// Vertex buffers management

// Load vertex array (vao) if supported
function rlLoadVertexArray(): Cardinal;
// Load a vertex buffer attribute
function rlLoadVertexBuffer(const Buffer: Pointer; Size: Integer; Dynamic_: Boolean): Cardinal;
// Load a new attributes element buffer
function rlLoadVertexBufferElement(const Buffer: Pointer; Size: Integer; Dynamic_: Boolean): Cardinal;
// Update GPU buffer with new data
procedure rlUpdateVertexBuffer(BufferId: Cardinal; const Data: Pointer; DataSize, Offset: Integer);
// Update vertex buffer elements with new data
procedure rlUpdateVertexBufferElements(Id: Cardinal; const Data: Pointer; DataSize, Offset: Integer);
// rlUnloadVertexArray
procedure rlUnloadVertexArray(VaoId: Cardinal);
// rlUnloadVertexBuffer
procedure rlUnloadVertexBuffer(VboId: Cardinal);
// rlSetVertexAttribute
procedure rlSetVertexAttribute(Index: Cardinal; CompSize, Type_:Integer; Normalized: Boolean; Stride: Integer; const Pointer_: Pointer);
// rlSetVertexAttributeDivisor
procedure rlSetVertexAttributeDivisor(Index: Cardinal; Divisor: Integer);
// Set vertex attribute default value
procedure rlSetVertexAttributeDefault(LocIndex: Integer; const Value: Pointer; AttribType, Count: Integer);
// rlDrawVertexArray
procedure rlDrawVertexArray(Offset, Count: Integer);
// rlDrawVertexArrayElements
procedure rlDrawVertexArrayElements(Offset, Count: Integer; const Buffer: Pointer);
// rlDrawVertexArrayInstanced
procedure rlDrawVertexArrayInstanced(Offset, Count, Instances: Integer);
// rlDrawVertexArrayElementsInstanced
procedure rlDrawVertexArrayElementsInstanced(Offset, Count: Integer; const Buffer: Pointer; Instances: Integer);

// Textures management

// Load texture in GPU
function rlLoadTexture(const Data: Pointer; Width, Height: Integer; Format: TRlPixelFormat; MipmapCount: Integer): Cardinal;
// Load depth texture/renderbuffer (to be attached to fbo)
function rlLoadTextureDepth(Width, Height: Integer; UseRenderBuffer: Boolean): Cardinal;
// Load texture cubemap
function rlLoadTextureCubemap(const Data: Pointer; Size: Integer; Format: TRlPixelFormat): Cardinal;
// Update GPU texture with new data
procedure rlUpdateTexture(Id: Cardinal; OffsetX, OffsetY, Width, Height: Integer; Format: TRlPixelFormat; Data: Pointer);
// Get OpenGL internal formats
procedure rlGetGlTextureFormats(Format: TRlPixelFormat; glInternalFormat: PInteger; glFormat: PInteger; glType: PInteger);
// Get name string for pixel format
function rlGetPixelFormatName(Format: TRlPixelFormat): PAnsiChar;
// Unload texture from GPU memory
procedure rlUnloadTexture(Id: Cardinal);
// Generate mipmap data for selected texture
procedure rlGenTextureMipmaps(Id: Cardinal; Width, Height: Integer; Format: TRlPixelFormat; Mipmaps: PInteger);
// Read texture pixel data
function rlReadTexturePixels(Id: Cardinal; Width, Height: Integer; Format: TRlPixelFormat): Pointer;
// Read screen pixel data (color buffer)
function rlReadScreenPixels(Width, Height: Integer): PByte;

// Framebuffer management (fbo)

// Load an empty framebuffer
function rlLoadFramebuffer(Width, Height: Integer): Cardinal;
// Attach texture/renderbuffer to a framebuffer
procedure rlFramebufferAttach(FboId: Cardinal; TexId: Cardinal; AttachType: TRlFramebufferAttachType; TexType: TRlFramebufferAttachTextureType; MipLevel: Integer);
// Verify framebuffer is complete
function rlFramebufferComplete(Id: Cardinal): Boolean;
// Delete framebuffer from GPU
procedure rlUnloadFramebuffer(Id: Cardinal);

// Shaders management

// Load shader from code strings
function rlLoadShaderCode(VsCode, FsCode: PAnsiChar): Cardinal;
// Compile custom shader and return shader id (type: RL_VERTEX_SHADER, RL_FRAGMENT_SHADER, RL_COMPUTE_SHADER)
function rlCompileShader(ShaderCode: PAnsiChar; Type_: Integer): Cardinal;
// Load custom shader program
function rlLoadShaderProgram(VShaderId: Cardinal; FShaderId: Cardinal): Cardinal;
// Unload shader program
procedure rlUnloadShaderProgram(Id: Cardinal);
// Get shader location uniform
function rlGetLocationUniform(ShaderId: Cardinal; UniformName: PAnsiChar): Integer;
// Get shader location attribute
function rlGetLocationAttrib(ShaderId: Cardinal; AttribName: PAnsiChar): Integer;
// Set shader value uniform
procedure rlSetUniform(LocIndex: Integer; Value: Pointer; UniformType: Integer; Count: Integer);
// Set shader value matrix
procedure rlSetUniformMatrix(LocIndex: Integer; Mat: TRlMatrix);
// Set shader value sampler
procedure rlSetUniformSampler(LocIndex: Integer; TextureId: Cardinal);
// Set shader currently active (id and locations)
procedure rlSetShader(Id: Cardinal; Locs: PInteger);

// Compute shader management

// Load compute shader program
function rlLoadComputeShaderProgram(ShaderId: Cardinal): Cardinal;
// Dispatch compute shader (equivalent to *draw* for graphics pipeline)
procedure rlComputeShaderDispatch(GroupX, GroupY, groupZ: Cardinal);

// Shader buffer storage object management (ssbo)

// Load shader storage buffer object (SSBO)
function rlLoadShaderBuffer(Size: Cardinal; const Data: Pointer; UsageHint: Integer): Cardinal;
// Unload shader storage buffer object (SSBO)
procedure rlUnloadShaderBuffer(SsboId: Cardinal);
// Update SSBO buffer data
procedure rlUpdateShaderBuffer(Id: Cardinal; const Data: Pointer; DataSize: Cardinal; Offset: Cardinal);
// Bind SSBO buffer
procedure rlBindShaderBuffer(Id: Cardinal; Index: Cardinal);
// Read SSBO buffer data (GPU->CPU)
procedure rlReadShaderBuffer(Id: Cardinal; Dest: Pointer; Count: Cardinal; Offset: Cardinal);
// Copy SSBO data between buffers
procedure rlCopyShaderBuffer(DestId, SrcId: Cardinal; DestOffset, SrcOffset: Cardinal; Count: Cardinal);
// Get SSBO buffer size
function rlGetShaderBufferSize(Id: Cardinal): Cardinal;

// Buffer management

// Bind image texture
procedure rlBindImageTexture(Id: Cardinal; Index: Cardinal; Format: Cardinal; Readonly: Boolean);

// Matrix state management

// Get internal modelview matrix
function rlGetMatrixModelview(): TRlMatrix;
// Get internal projection matrix
function rlGetMatrixProjection(): TRlMatrix;
// Get internal accumulated transform matrix
function rlGetMatrixTransform(): TRlMatrix;
// Get internal projection matrix for stereo render (selected eye)
function rlGetMatrixProjectionStereo(Eye: Integer): TRlMatrix;
// Get internal view offset matrix for stereo render (selected eye)
function rlGetMatrixViewOffsetStereo(Eye: Integer): TRlMatrix;
// Set a custom projection matrix (replaces internal projection matrix)
procedure rlSetMatrixProjection(Proj: TRlMatrix);
// Set a custom modelview matrix (replaces internal modelview matrix)
procedure rlSetMatrixModelview(View: TRlMatrix);
// Set eyes projection matrices for stereo rendering
procedure rlSetMatrixProjectionStereo(Right: TRlMatrix; Left: TRlMatrix);
// Set eyes view offsets matrices for stereo rendering
procedure rlSetMatrixViewOffsetStereo(Right: TRlMatrix; Left: TRlMatrix);

// Quick and dirty cube/quad buffers load->draw->unload

// Load and draw a cube
procedure rlLoadDrawCube();
// Load and draw a quad
procedure rlLoadDrawQuad();

implementation

uses
  Math;

// Functions Declaration - Matrix operations

procedure Lib_rlMatrixMode(Mode: TRlMatrixMode);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlMatrixMode';
procedure rlMatrixMode(Mode: TRlMatrixMode);
begin
  Lib_rlMatrixMode(Mode);
end;

procedure Lib_rlPushMatrix();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlPushMatrix';
procedure rlPushMatrix();
begin
  Lib_rlPushMatrix();
end;

procedure Lib_rlPopMatrix();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlPopMatrix';
procedure rlPopMatrix();
begin
  Lib_rlPopMatrix();
end;

procedure Lib_rlLoadIdentity();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlLoadIdentity';
procedure rlLoadIdentity();
begin
  Lib_rlLoadIdentity();
end;

procedure Lib_rlTranslatef(X, Y, Z: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlTranslatef';
procedure rlTranslatef(X, Y, Z: Single);
begin
  Lib_rlTranslatef(X, Y, Z);
end;

procedure Lib_rlRotatef(Angle, X, Y, Z: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlRotatef';
procedure rlRotatef(Angle, X, Y, Z: Single);
begin
  Lib_rlRotatef(Angle, X, Y, Z);
end;

procedure Lib_rlScalef(X, Y, Z: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlScalef';
procedure rlScalef(X, Y, Z: Single);
begin
  Lib_rlScalef(X, Y, Z);
end;

procedure Lib_rlMultMatrixf(const Matf: PSingle);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlMultMatrixf';
procedure rlMultMatrixf(const Matf: PSingle);
begin
  Lib_rlMultMatrixf(Matf);
end;

procedure Lib_rlFrustum(Left, Right, Bottom, Top, Znear, Zfar: Double);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlFrustum';
procedure rlFrustum(Left, Right, Bottom, Top, Znear, Zfar: Double);
begin
  Lib_rlFrustum(Left, Right, Bottom, Top, Znear, Zfar);
end;

procedure Lib_rlOrtho(Left, Right, Bottom, Top, Znear, Zfar: Double);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlOrtho';
procedure rlOrtho(Left, Right, Bottom, Top, Znear, Zfar: Double);
begin
  Lib_rlOrtho(Left, Right, Bottom, Top, Znear, Zfar);
end;

procedure Lib_rlViewport(X, Y, Width, Height: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlViewport';
procedure rlViewport(X, Y, Width, Height: Integer);
begin
  Lib_rlViewport(X, Y, Width, Height);
end;

// Functions Declaration - Vertex level operations

procedure Lib_rlBegin(Mode: TRlDrawMode);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlBegin';
procedure rlBegin(Mode: TRlDrawMode);
begin
  Lib_rlBegin(Mode);
end;

procedure Lib_rlEnd();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlEnd';
procedure rlEnd();
begin
  Lib_rlEnd();
end;

procedure Lib_rlVertex2i(X, Y: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlVertex2i';
procedure rlVertex2i(X, Y: Integer);
begin
  Lib_rlVertex2i(X, Y);
end;

procedure Lib_rlVertex2f(X, Y: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlVertex2f';
procedure rlVertex2f(X, Y: Single);
begin
  Lib_rlVertex2f(X, Y);
end;

procedure Lib_rlVertex3f(X, Y, Z: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlVertex3f';
procedure rlVertex3f(X, Y, Z: Single);
begin
  Lib_rlVertex3f(X, Y, Z);
end;

procedure Lib_rlTexCoord2f(X, Y: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlTexCoord2f';
procedure rlTexCoord2f(X, Y: Single);
begin
  Lib_rlTexCoord2f(X, Y);
end;

procedure Lib_rlNormal3f(X, Y, Z: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlNormal3f';
procedure rlNormal3f(X, Y, Z: Single);
begin
  Lib_rlNormal3f(X, Y, Z);
end;

procedure Lib_rlColor4ub(R, G, B, A: Byte);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlColor4ub';
procedure rlColor4ub(R, G, B, A: Byte);
begin
  Lib_rlColor4ub(R, G, B, A);
end;

procedure Lib_rlColor3f(X, Y, Z: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlColor3f';
procedure rlColor3f(X, Y, Z: Single);
begin
  Lib_rlColor3f(X, Y, Z);
end;

procedure Lib_rlColor4f(X, Y, Z, W: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlColor4f';
procedure rlColor4f(X, Y, Z, W: Single);
begin
  Lib_rlColor4f(X, Y, Z, W);
end;

// Vertex buffers state

function Lib_rlEnableVertexArray(VaoId: Cardinal): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlEnableVertexArray';
function rlEnableVertexArray(VaoId: Cardinal): Boolean;
begin
  Result := Lib_rlEnableVertexArray(VaoId);
end;

procedure Lib_rlDisableVertexArray();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDisableVertexArray';
procedure rlDisableVertexArray();
begin
  Lib_rlDisableVertexArray();
end;

procedure Lib_rlEnableVertexBuffer(Id: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlEnableVertexBuffer';
procedure rlEnableVertexBuffer(Id: Cardinal);
begin
  Lib_rlEnableVertexBuffer(Id);
end;

procedure Lib_rlDisableVertexBuffer();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDisableVertexBuffer';
procedure rlDisableVertexBuffer();
begin
  Lib_rlDisableVertexBuffer();
end;

procedure Lib_rlEnableVertexBufferElement(Id: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlEnableVertexBufferElement';
procedure rlEnableVertexBufferElement(Id: Cardinal);
begin
  Lib_rlEnableVertexBufferElement(Id);
end;

procedure Lib_rlDisableVertexBufferElement();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDisableVertexBufferElement';
procedure rlDisableVertexBufferElement();
begin
  Lib_rlDisableVertexBufferElement();
end;

procedure Lib_rlEnableVertexAttribute(Index: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlEnableVertexAttribute';
procedure rlEnableVertexAttribute(Index: Cardinal);
begin
  Lib_rlEnableVertexAttribute(Index);
end;

procedure Lib_rlDisableVertexAttribute(Index: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDisableVertexAttribute';
procedure rlDisableVertexAttribute(Index: Cardinal);
begin
  Lib_rlDisableVertexAttribute(Index);
end;

{$IFDEF DESKTOP_OPENGL}
//procedure Lib_rlEnableStatePointer(VertexAttribType: Integer; Buffer: Pointer);
//  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlEnableStatePointer';
//procedure rlEnableStatePointer(VertexAttribType: Integer; Buffer: Pointer);
//begin
//  Lib_rlEnableStatePointer(VertexAttribType, Buffer);
//end;
//
//procedure Lib_rlDisableStatePointer(VertexAttribType: Integer);
//  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDisableStatePointer';
//procedure rlDisableStatePointer(VertexAttribType: Integer);
//begin
//  Lib_rlDisableStatePointer(VertexAttribType);
//end;
{$ENDIF}

// Textures state

procedure Lib_rlActiveTextureSlot(Slot: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlActiveTextureSlot';
procedure rlActiveTextureSlot(Slot: Integer);
begin
  Lib_rlActiveTextureSlot(Slot);
end;

procedure Lib_rlEnableTexture(Id: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlEnableTexture';
procedure rlEnableTexture(Id: Cardinal);
begin
  Lib_rlEnableTexture(Id);
end;

procedure Lib_rlDisableTexture();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDisableTexture';
procedure rlDisableTexture();
begin
  Lib_rlDisableTexture();
end;

procedure Lib_rlEnableTextureCubemap(Id: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlEnableTextureCubemap';
procedure rlEnableTextureCubemap(Id: Cardinal);
begin
  Lib_rlEnableTextureCubemap(Id);
end;

procedure Lib_rlDisableTextureCubemap();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDisableTextureCubemap';
procedure rlDisableTextureCubemap();
begin
  Lib_rlDisableTextureCubemap();
end;

procedure Lib_rlTextureParameters(Id: Cardinal; Param: Integer; Value: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlTextureParameters';
procedure rlTextureParameters(Id: Cardinal; Param: Integer; Value: Integer);
begin
  Lib_rlTextureParameters(Id, Param, Value);
end;

procedure Lib_rlCubemapParameters(Id: Cardinal; Param: Integer; Value: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlCubemapParameters';
procedure rlCubemapParameters(Id: Cardinal; Param: Integer; Value: Integer);
begin
  Lib_rlCubemapParameters(Id, Param, Value);
end;

// Shader state

procedure Lib_rlEnableShader(Id: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlEnableShader';
procedure rlEnableShader(Id: Cardinal);
begin
  Lib_rlEnableShader(Id);
end;

procedure Lib_rlDisableShader();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDisableShader';
procedure rlDisableShader();
begin
  Lib_rlDisableShader();
end;

// Framebuffer state

procedure Lib_rlEnableFramebuffer(Id: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlEnableFramebuffer';
procedure rlEnableFramebuffer(Id: Cardinal);
begin
  Lib_rlEnableFramebuffer(Id);
end;

procedure Lib_rlDisableFramebuffer();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDisableFramebuffer';
procedure rlDisableFramebuffer();
begin
  Lib_rlDisableFramebuffer();
end;

procedure Lib_rlActiveDrawBuffers(Count: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlActiveDrawBuffers';
procedure rlActiveDrawBuffers(Count: Integer);
begin
  Lib_rlActiveDrawBuffers(Count);
end;

// General render state

procedure Lib_rlEnableColorBlend();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlEnableColorBlend';
procedure rlEnableColorBlend();
begin
  Lib_rlEnableColorBlend();
end;

procedure Lib_rlDisableColorBlend();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDisableColorBlend';
procedure rlDisableColorBlend();
begin
  Lib_rlDisableColorBlend();
end;

procedure Lib_rlEnableDepthTest();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlEnableDepthTest';
procedure rlEnableDepthTest();
begin
  Lib_rlEnableDepthTest();
end;

procedure Lib_rlDisableDepthTest();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDisableDepthTest';
procedure rlDisableDepthTest();
begin
  Lib_rlDisableDepthTest();
end;

procedure Lib_rlEnableDepthMask();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlEnableDepthMask';
procedure rlEnableDepthMask();
begin
  Lib_rlEnableDepthMask();
end;

procedure Lib_rlDisableDepthMask();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDisableDepthMask';
procedure rlDisableDepthMask();
begin
  Lib_rlDisableDepthMask();
end;

procedure Lib_rlEnableBackfaceCulling();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlEnableBackfaceCulling';
procedure rlEnableBackfaceCulling();
begin
  Lib_rlEnableBackfaceCulling();
end;

procedure Lib_rlDisableBackfaceCulling();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDisableBackfaceCulling';
procedure rlDisableBackfaceCulling();
begin
  Lib_rlDisableBackfaceCulling();
end;

procedure Lib_rlSetCullFace(Mode: TRlCullMode);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlSetCullFace';
procedure rlSetCullFace(Mode: TRlCullMode);
begin
  Lib_rlSetCullFace(Mode);
end;

procedure Lib_rlEnableScissorTest();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlEnableScissorTest';
procedure rlEnableScissorTest();
begin
  Lib_rlEnableScissorTest();
end;

procedure Lib_rlDisableScissorTest();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDisableScissorTest';
procedure rlDisableScissorTest();
begin
  Lib_rlDisableScissorTest();
end;

procedure Lib_rlScissor(X, Y, Width, Height: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlScissor';
procedure rlScissor(X, Y, Width, Height: Integer);
begin
  Lib_rlScissor(X, Y, Width, Height);
end;

procedure Lib_rlEnableWireMode();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlEnableWireMode';
procedure rlEnableWireMode();
begin
  Lib_rlEnableWireMode();
end;

procedure Lib_rlDisableWireMode();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDisableWireMode';
procedure rlDisableWireMode();
begin
  Lib_rlDisableWireMode();
end;

procedure Lib_rlSetLineWidth(Width: Single);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlSetLineWidth';
procedure rlSetLineWidth(Width: Single);
begin
  Lib_rlSetLineWidth(Width);
end;

function Lib_rlGetLineWidth(): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlGetLineWidth';
function rlGetLineWidth(): Single;
begin
  Result := Lib_rlGetLineWidth();
end;

procedure Lib_rlEnableSmoothLines();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlEnableSmoothLines';
procedure rlEnableSmoothLines();
begin
  Lib_rlEnableSmoothLines();
end;

procedure Lib_rlDisableSmoothLines();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDisableSmoothLines';
procedure rlDisableSmoothLines();
begin
  Lib_rlDisableSmoothLines();
end;

procedure Lib_rlEnableStereoRender();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlEnableStereoRender';
procedure rlEnableStereoRender();
begin
  Lib_rlEnableStereoRender();
end;

procedure Lib_rlDisableStereoRender();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDisableStereoRender';
procedure rlDisableStereoRender();
begin
  Lib_rlDisableStereoRender();
end;

function Lib_rlIsStereoRenderEnabled(): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlIsStereoRenderEnabled';
function rlIsStereoRenderEnabled(): Boolean;
begin
  Result := Lib_rlIsStereoRenderEnabled()
end;

procedure Lib_rlClearColor(R, G, B, A: Byte);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlClearColor';
procedure rlClearColor(R, G, B, A: Byte);
begin
  Lib_rlClearColor(R, G, B, A);
end;

procedure Lib_rlClearScreenBuffers();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlClearScreenBuffers';
procedure rlClearScreenBuffers();
begin
  Lib_rlClearScreenBuffers();
end;

procedure Lib_rlCheckErrors();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlCheckErrors';
procedure rlCheckErrors();
begin
  Lib_rlCheckErrors();
end;

procedure Lib_rlSetBlendMode(Mode: TRlBlendMode);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlSetBlendMode';
procedure rlSetBlendMode(Mode: TRlBlendMode);
begin
  Lib_rlSetBlendMode(Mode);
end;

procedure Lib_rlSetBlendFactors(GlSrcFactor, GlDstFactor, GlEquation: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlSetBlendFactors';
procedure rlSetBlendFactors(GlSrcFactor, GlDstFactor, GlEquation: Integer);
begin
  Lib_rlSetBlendFactors(GlSrcFactor, GlDstFactor, GlEquation);
end;

procedure Lib_rlSetBlendFactorsSeparate(GlSrcRGB, GlDstRGB, GlSrcAlpha, GlDstAlpha, GlEqRGB, GlEqAlpha: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlSetBlendFactorsSeparate';
procedure rlSetBlendFactorsSeparate(GlSrcRGB, GlDstRGB, GlSrcAlpha, GlDstAlpha, GlEqRGB, GlEqAlpha: Integer);
begin
  Lib_rlSetBlendFactorsSeparate(GlSrcRGB, GlDstRGB, GlSrcAlpha, GlDstAlpha, GlEqRGB, GlEqAlpha);
end;

// rlgl initialization functions

procedure Lib_rlglInit(Width, Height: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlglInit';
procedure rlglInit(Width, Height: Integer);
begin
  Lib_rlglInit(Width, Height);
end;

procedure Lib_rlglClose();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlglClose';
procedure rlglClose();
begin
  Lib_rlglClose();
end;

procedure Lib_rlLoadExtensions(Loader: Pointer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlLoadExtensions';
procedure rlLoadExtensions(Loader: Pointer);
begin
  Lib_rlLoadExtensions(Loader);
end;

function Lib_rlGetVersion(): TRlGlVersion;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlGetVersion';
function rlGetVersion(): TRlGlVersion;
begin
  Result := Lib_rlGetVersion();
end;

procedure Lib_rlSetFramebufferWidth(Width: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlSetFramebufferWidth';
procedure rlSetFramebufferWidth(Width: Integer);
begin
  Lib_rlSetFramebufferWidth(Width);
end;

function Lib_rlGetFramebufferWidth(): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlGetFramebufferWidth';
function rlGetFramebufferWidth(): Integer;
begin
  Result := Lib_rlGetFramebufferWidth();
end;

procedure Lib_rlSetFramebufferHeight(Weight: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlSetFramebufferHeight';
procedure rlSetFramebufferHeight(Weight: Integer);
begin
  Lib_rlSetFramebufferHeight(Weight);
end;

function Lib_rlGetFramebufferHeight(): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlGetFramebufferHeight';
function rlGetFramebufferHeight(): Integer;
begin
  Result := Lib_rlGetFramebufferHeight();
end;

function Lib_rlGetTextureIdDefault(): Cardinal;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlGetTextureIdDefault';
function rlGetTextureIdDefault(): Cardinal;
begin
  Result := Lib_rlGetTextureIdDefault();
end;

function Lib_rlGetShaderIdDefault(): Cardinal;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlGetShaderIdDefault';
function rlGetShaderIdDefault(): Cardinal;
begin
  Result := Lib_rlGetShaderIdDefault();
end;

function Lib_rlGetShaderLocsDefault(): PInteger;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlGetShaderLocsDefault';
function rlGetShaderLocsDefault(): PInteger;
begin
  Result := Lib_rlGetShaderLocsDefault();
end;

function Lib_rlLoadRenderBatch(NumBuffers, BufferElements: Integer): TRlRenderBatch;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlLoadRenderBatch';
function rlLoadRenderBatch(NumBuffers, BufferElements: Integer): TRlRenderBatch;
begin
  Result := Lib_rlLoadRenderBatch(NumBuffers, BufferElements);
end;

procedure Lib_rlUnloadRenderBatch(Batch: TRlRenderBatch);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlUnloadRenderBatch';
procedure rlUnloadRenderBatch(Batch: TRlRenderBatch);
begin
  Lib_rlUnloadRenderBatch(Batch);
end;

procedure Lib_rlDrawRenderBatch(Batch: PRlRenderBatch);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDrawRenderBatch';
procedure rlDrawRenderBatch(Batch: PRlRenderBatch);
begin
  Lib_rlDrawRenderBatch(Batch);
end;

procedure Lib_rlSetRenderBatchActive(Batch: PRlRenderBatch);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlSetRenderBatchActive';
procedure rlSetRenderBatchActive(Batch: PRlRenderBatch);
begin
  Lib_rlSetRenderBatchActive(Batch);
end;

procedure Lib_rlDrawRenderBatchActive();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDrawRenderBatchActive';
procedure rlDrawRenderBatchActive();
begin
  Lib_rlDrawRenderBatchActive();
end;

function Lib_rlCheckRenderBatchLimit(VCount: Integer): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlCheckRenderBatchLimit';
function rlCheckRenderBatchLimit(VCount: Integer): Boolean;
begin
  Result := Lib_rlCheckRenderBatchLimit(VCount);
end;

procedure Lib_rlSetTexture(Id: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlSetTexture';
procedure rlSetTexture(Id: Cardinal);
begin
  Lib_rlSetTexture(Id);
end;

// Vertex buffers management

function Lib_rlLoadVertexArray(): Cardinal;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlLoadVertexArray';
function rlLoadVertexArray(): Cardinal;
begin
  Result := Lib_rlLoadVertexArray();
end;

function Lib_rlLoadVertexBuffer(const Buffer: Pointer; Size: Integer; Dynamic_: Boolean): Cardinal;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlLoadVertexBuffer';
function rlLoadVertexBuffer(const Buffer: Pointer; Size: Integer; Dynamic_: Boolean): Cardinal;
begin
  Result := Lib_rlLoadVertexBuffer(Buffer, Size, Dynamic_);
end;

function Lib_rlLoadVertexBufferElement(const Buffer: Pointer; Size: Integer; Dynamic_: Boolean): Cardinal;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlLoadVertexBufferElement';
function rlLoadVertexBufferElement(const Buffer: Pointer; Size: Integer; Dynamic_: Boolean): Cardinal;
begin
  Result := Lib_rlLoadVertexBufferElement(Buffer, Size, Dynamic_);
end;

procedure Lib_rlUpdateVertexBuffer(BufferId: Cardinal; const Data: Pointer; DataSize, Offset: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlUpdateVertexBuffer';
procedure rlUpdateVertexBuffer(BufferId: Cardinal; const Data: Pointer; DataSize, Offset: Integer);
begin
  Lib_rlUpdateVertexBuffer(BufferId, Data, DataSize, Offset);
end;

procedure Lib_rlUpdateVertexBufferElements(Id: Cardinal; const Data: Pointer; DataSize, Offset: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlUpdateVertexBufferElements';
procedure rlUpdateVertexBufferElements(Id: Cardinal; const Data: Pointer; DataSize, Offset: Integer);
begin
  Lib_rlUpdateVertexBufferElements(Id, Data, DataSize, Offset);
end;

procedure Lib_rlUnloadVertexArray(VaoId: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlUnloadVertexArray';
procedure rlUnloadVertexArray(VaoId: Cardinal);
begin
  Lib_rlUnloadVertexArray(VaoId);
end;

procedure Lib_rlUnloadVertexBuffer(VboId: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlUnloadVertexBuffer';
procedure rlUnloadVertexBuffer(VboId: Cardinal);
begin
  Lib_rlUnloadVertexBuffer(VboId);
end;

procedure Lib_rlSetVertexAttribute(Index: Cardinal; CompSize, Type_:Integer; Normalized: Boolean; Stride: Integer; const Pointer_: Pointer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlSetVertexAttribute';
procedure rlSetVertexAttribute(Index: Cardinal; CompSize, Type_:Integer; Normalized: Boolean; Stride: Integer; const Pointer_: Pointer);
begin
  Lib_rlSetVertexAttribute(Index, CompSize, Type_, Normalized, Stride, Pointer_);
end;

procedure Lib_rlSetVertexAttributeDivisor(Index: Cardinal; Divisor: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlSetVertexAttributeDivisor';
procedure rlSetVertexAttributeDivisor(Index: Cardinal; Divisor: Integer);
begin
  Lib_rlSetVertexAttributeDivisor(Index, Divisor);
end;

procedure Lib_rlSetVertexAttributeDefault(LocIndex: Integer; const Value: Pointer; AttribType, Count: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlSetVertexAttributeDefault';
procedure rlSetVertexAttributeDefault(LocIndex: Integer; const Value: Pointer; AttribType, Count: Integer);
begin
  Lib_rlSetVertexAttributeDefault(LocIndex, Value, AttribType, Count);
end;

procedure Lib_rlDrawVertexArray(Offset, Count: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDrawVertexArray';
procedure rlDrawVertexArray(Offset, Count: Integer);
begin
  Lib_rlDrawVertexArray(Offset, Count);
end;

procedure Lib_rlDrawVertexArrayElements(Offset, Count: Integer; const Buffer: Pointer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDrawVertexArrayElements';
procedure rlDrawVertexArrayElements(Offset, Count: Integer; const Buffer: Pointer);
begin
  Lib_rlDrawVertexArrayElements(Offset, Count, Buffer);
end;

procedure Lib_rlDrawVertexArrayInstanced(Offset, Count, Instances: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDrawVertexArrayInstanced';
procedure rlDrawVertexArrayInstanced(Offset, Count, Instances: Integer);
begin
  Lib_rlDrawVertexArrayInstanced(Offset, Count, Instances);
end;

procedure Lib_rlDrawVertexArrayElementsInstanced(Offset, Count: Integer; const Buffer: Pointer; Instances: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlDrawVertexArrayElementsInstanced';
procedure rlDrawVertexArrayElementsInstanced(Offset, Count: Integer; const Buffer: Pointer; Instances: Integer);
begin
  Lib_rlDrawVertexArrayElementsInstanced(Offset, Count, Buffer, Instances);
end;

// Textures management

function Lib_rlLoadTexture(const Data: Pointer; Width, Height: Integer; Format: TRlPixelFormat; MipmapCount: Integer): Cardinal;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlLoadTexture';
function rlLoadTexture(const Data: Pointer; Width, Height: Integer; Format: TRlPixelFormat; MipmapCount: Integer): Cardinal;
begin
  Result := Lib_rlLoadTexture(Data, Width, Height, Format, MipmapCount);
end;

function Lib_rlLoadTextureDepth(Width, Height: Integer; UseRenderBuffer: Boolean): Cardinal;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlLoadTextureDepth';
function rlLoadTextureDepth(Width, Height: Integer; UseRenderBuffer: Boolean): Cardinal;
begin
  Result := Lib_rlLoadTextureDepth(Width, Height, UseRenderBuffer);
end;

function Lib_rlLoadTextureCubemap(const Data: Pointer; Size: Integer; Format: TRlPixelFormat): Cardinal;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlLoadTextureCubemap';
function rlLoadTextureCubemap(const Data: Pointer; Size: Integer; Format: TRlPixelFormat): Cardinal;
begin
  Result := Lib_rlLoadTextureCubemap(Data, Size, Format);
end;

procedure Lib_rlUpdateTexture(Id: Cardinal; OffsetX, OffsetY, Width, Height: Integer; Format: TRlPixelFormat; Data: Pointer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlUpdateTexture';
procedure rlUpdateTexture(Id: Cardinal; OffsetX, OffsetY, Width, Height: Integer; Format: TRlPixelFormat; Data: Pointer);
begin
  Lib_rlUpdateTexture(Id, OffsetX, OffsetY, Width, Height, Format, Data);
end;

procedure Lib_rlGetGlTextureFormats(Format: TRlPixelFormat; glInternalFormat: PInteger; glFormat: PInteger; glType: PInteger);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlGetGlTextureFormats';
procedure rlGetGlTextureFormats(Format: TRlPixelFormat; glInternalFormat: PInteger; glFormat: PInteger; glType: PInteger);
begin
  Lib_rlGetGlTextureFormats(Format, glInternalFormat, glFormat, glType);
end;

function Lib_rlGetPixelFormatName(Format: TRlPixelFormat): PAnsiChar;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlGetPixelFormatName';
function rlGetPixelFormatName(Format: TRlPixelFormat): PAnsiChar;
begin
  Result := Lib_rlGetPixelFormatName(Format);
end;

procedure Lib_rlUnloadTexture(Id: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlUnloadTexture';
procedure rlUnloadTexture(Id: Cardinal);
begin
  Lib_rlUnloadTexture(Id);
end;

procedure Lib_rlGenTextureMipmaps(Id: Cardinal; Width, Height: Integer; Format: TRlPixelFormat; Mipmaps: PInteger);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlGenTextureMipmaps';
procedure rlGenTextureMipmaps(Id: Cardinal; Width, Height: Integer; Format: TRlPixelFormat; Mipmaps: PInteger);
begin
  Lib_rlGenTextureMipmaps(Id, Width, Height, Format, Mipmaps);
end;

function Lib_rlReadTexturePixels(Id: Cardinal; Width, Height: Integer; Format: TRlPixelFormat): Pointer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlReadTexturePixels';
function rlReadTexturePixels(Id: Cardinal; Width, Height: Integer; Format: TRlPixelFormat): Pointer;
begin
  Result := Lib_rlReadTexturePixels(Id, Width, Height, Format);
end;

function Lib_rlReadScreenPixels(Width, Height: Integer): PByte;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlReadScreenPixels';
function rlReadScreenPixels(Width, Height: Integer): PByte;
begin
  Result := Lib_rlReadScreenPixels(Width, Height);
end;

// Framebuffer management (fbo)

function Lib_rlLoadFramebuffer(Width, Height: Integer): Cardinal;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlLoadFramebuffer';
function rlLoadFramebuffer(Width, Height: Integer): Cardinal;
begin
  Result := Lib_rlLoadFramebuffer(Width, Height);
end;

procedure Lib_rlFramebufferAttach(FboId: Cardinal; TexId: Cardinal; AttachType: TRlFramebufferAttachType; TexType: TRlFramebufferAttachTextureType; MipLevel: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlFramebufferAttach';
procedure rlFramebufferAttach(FboId: Cardinal; TexId: Cardinal; AttachType: TRlFramebufferAttachType; TexType: TRlFramebufferAttachTextureType; MipLevel: Integer);
begin
  Lib_rlFramebufferAttach(FboId, TexId, AttachType, TexType, MipLevel);
end;

function Lib_rlFramebufferComplete(Id: Cardinal): Boolean;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlFramebufferComplete';
function rlFramebufferComplete(Id: Cardinal): Boolean;
begin
  Result := Lib_rlFramebufferComplete(Id);
end;

procedure Lib_rlUnloadFramebuffer(Id: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlUnloadFramebuffer';
procedure rlUnloadFramebuffer(Id: Cardinal);
begin
  Lib_rlUnloadFramebuffer(Id);
end;

// Shaders management

function Lib_rlLoadShaderCode(VsCode, FsCode: PAnsiChar): Cardinal;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlLoadShaderCode';
function rlLoadShaderCode(VsCode, FsCode: PAnsiChar): Cardinal;
begin
  Result := Lib_rlLoadShaderCode(VsCode, FsCode);
end;

function Lib_rlCompileShader(ShaderCode: PAnsiChar; Type_: Integer): Cardinal;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlCompileShader';
function rlCompileShader(ShaderCode: PAnsiChar; Type_: Integer): Cardinal;
begin
  Result := Lib_rlCompileShader(ShaderCode, Type_);
end;

function Lib_rlLoadShaderProgram(VShaderId: Cardinal; FShaderId: Cardinal): Cardinal;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlLoadShaderProgram';
function rlLoadShaderProgram(VShaderId: Cardinal; FShaderId: Cardinal): Cardinal;
begin
  Result :=  Lib_rlLoadShaderProgram(VShaderId, FShaderId);
end;

procedure Lib_rlUnloadShaderProgram(Id: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlUnloadShaderProgram';
procedure rlUnloadShaderProgram(Id: Cardinal);
begin
  Lib_rlUnloadShaderProgram(Id);
end;

function Lib_rlGetLocationUniform(ShaderId: Cardinal; UniformName: PAnsiChar): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlGetLocationUniform';
function rlGetLocationUniform(ShaderId: Cardinal; UniformName: PAnsiChar): Integer;
begin
  Result := Lib_rlGetLocationUniform(ShaderId, UniformName);
end;

function Lib_rlGetLocationAttrib(ShaderId: Cardinal; AttribName: PAnsiChar): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlGetLocationAttrib';
function rlGetLocationAttrib(ShaderId: Cardinal; AttribName: PAnsiChar): Integer;
begin
  Result := Lib_rlGetLocationAttrib(ShaderId, AttribName);
end;

procedure Lib_rlSetUniform(LocIndex: Integer; Value: Pointer; UniformType: Integer; Count: Integer);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlSetUniform';
procedure rlSetUniform(LocIndex: Integer; Value: Pointer; UniformType: Integer; Count: Integer);
begin
  Lib_rlSetUniform(LocIndex, Value, UniformType, Count);
end;

procedure Lib_rlSetUniformMatrix(LocIndex: Integer; Mat: TRlMatrix);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlSetUniformMatrix';
procedure rlSetUniformMatrix(LocIndex: Integer; Mat: TRlMatrix);
begin
   Lib_rlSetUniformMatrix(LocIndex, Mat);
end;

procedure Lib_rlSetUniformSampler(LocIndex: Integer; TextureId: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlSetUniformSampler';
procedure rlSetUniformSampler(LocIndex: Integer; TextureId: Cardinal);
begin
  Lib_rlSetUniformSampler(LocIndex, TextureId);
end;

procedure Lib_rlSetShader(Id: Cardinal; Locs: PInteger);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlSetShader';
procedure rlSetShader(Id: Cardinal; Locs: PInteger);
begin
  Lib_rlSetShader(Id, Locs);
end;

// Compute shader management

function Lib_rlLoadComputeShaderProgram(ShaderId: Cardinal): Cardinal;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlLoadComputeShaderProgram';
function rlLoadComputeShaderProgram(ShaderId: Cardinal): Cardinal;
begin
  Result := Lib_rlLoadComputeShaderProgram(ShaderId);
end;

procedure Lib_rlComputeShaderDispatch(GroupX, GroupY, groupZ: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlComputeShaderDispatch';
procedure rlComputeShaderDispatch(GroupX, GroupY, groupZ: Cardinal);
begin
  Lib_rlComputeShaderDispatch(GroupX, GroupY, groupZ);
end;

// Shader buffer storage object management (ssbo)

function Lib_rlLoadShaderBuffer(Size: Cardinal; const Data: Pointer; UsageHint: Integer): Cardinal;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlLoadShaderBuffer';
function rlLoadShaderBuffer(Size: Cardinal; const Data: Pointer; UsageHint: Integer): Cardinal;
begin
  Result := Lib_rlLoadShaderBuffer(Size, Data, UsageHint);
end;

procedure Lib_rlUnloadShaderBuffer(SsboId: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlUnloadShaderBuffer';
procedure rlUnloadShaderBuffer(SsboId: Cardinal);
begin
  Lib_rlUnloadShaderBuffer(SsboId);
end;

procedure Lib_rlUpdateShaderBuffer(Id: Cardinal; const Data: Pointer; DataSize: Cardinal; Offset: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlUpdateShaderBuffer';
procedure rlUpdateShaderBuffer(Id: Cardinal; const Data: Pointer; DataSize: Cardinal; Offset: Cardinal);
begin
  Lib_rlUpdateShaderBuffer(Id, Data, DataSize, Offset);
end;

procedure Lib_rlBindShaderBuffer(Id: Cardinal; Index: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlBindShaderBuffer';
procedure rlBindShaderBuffer(Id: Cardinal; Index: Cardinal);
begin
  Lib_rlBindShaderBuffer(Id, Index);
end;

procedure Lib_rlReadShaderBuffer(Id: Cardinal; Dest: Pointer; Count: Cardinal; Offset: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlReadShaderBuffer';
procedure rlReadShaderBuffer(Id: Cardinal; Dest: Pointer; Count: Cardinal; Offset: Cardinal);
begin
  Lib_rlReadShaderBuffer(Id, Dest, Count, Offset);
end;

procedure Lib_rlCopyShaderBuffer(DestId, SrcId: Cardinal; DestOffset, SrcOffset: Cardinal; Count: Cardinal);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlCopyShaderBuffer';
procedure rlCopyShaderBuffer(DestId, SrcId: Cardinal; DestOffset, SrcOffset: Cardinal; Count: Cardinal);
begin
  Lib_rlCopyShaderBuffer(DestId, SrcId, DestOffset, SrcOffset, Count);
end;

function Lib_rlGetShaderBufferSize(Id: Cardinal): Cardinal;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlGetShaderBufferSize';
function rlGetShaderBufferSize(Id: Cardinal): Cardinal;
begin
  Result := Lib_rlGetShaderBufferSize(Id);
end;

// Buffer management

procedure Lib_rlBindImageTexture(Id: Cardinal; Index: Cardinal; Format: Cardinal; Readonly: Boolean);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlBindImageTexture';
procedure rlBindImageTexture(Id: Cardinal; Index: Cardinal; Format: Cardinal; Readonly: Boolean);
begin
  Lib_rlBindImageTexture(Id, Index, Format, Readonly);
end;

// Matrix state management

function Lib_rlGetMatrixModelview(): TRlMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlGetMatrixModelview';
function rlGetMatrixModelview(): TRlMatrix;
begin
  Result := Lib_rlGetMatrixModelview();
end;

function Lib_rlGetMatrixProjection(): TRlMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlGetMatrixProjection';
function rlGetMatrixProjection(): TRlMatrix;
begin
  Result := Lib_rlGetMatrixProjection();
end;

function Lib_rlGetMatrixTransform(): TRlMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlGetMatrixTransform';
function rlGetMatrixTransform(): TRlMatrix;
begin
  Result := Lib_rlGetMatrixTransform();
end;

function Lib_rlGetMatrixProjectionStereo(Eye: Integer): TRlMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlGetMatrixProjectionStereo';
function rlGetMatrixProjectionStereo(Eye: Integer): TRlMatrix;
begin
  Result := Lib_rlGetMatrixProjectionStereo(Eye);
end;

function Lib_rlGetMatrixViewOffsetStereo(Eye: Integer): TRlMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlGetMatrixViewOffsetStereo';
function rlGetMatrixViewOffsetStereo(Eye: Integer): TRlMatrix;
begin
  Result := Lib_rlGetMatrixViewOffsetStereo(Eye);
end;

procedure Lib_rlSetMatrixProjection(Proj: TRlMatrix);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlSetMatrixProjection';
procedure rlSetMatrixProjection(Proj: TRlMatrix);
begin
  Lib_rlSetMatrixProjection(Proj);
end;

procedure Lib_rlSetMatrixModelview(View: TRlMatrix);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlSetMatrixModelview';
procedure rlSetMatrixModelview(View: TRlMatrix);
begin
  Lib_rlSetMatrixModelview(View);
end;

procedure Lib_rlSetMatrixProjectionStereo(Right: TRlMatrix; Left: TRlMatrix);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlSetMatrixProjectionStereo';
procedure rlSetMatrixProjectionStereo(Right: TRlMatrix; Left: TRlMatrix);
begin
  Lib_rlSetMatrixProjectionStereo(Right, Left);
end;

procedure Lib_rlSetMatrixViewOffsetStereo(Right: TRlMatrix; Left: TRlMatrix);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlSetMatrixViewOffsetStereo';
procedure rlSetMatrixViewOffsetStereo(Right: TRlMatrix; Left: TRlMatrix);
begin
  Lib_rlSetMatrixViewOffsetStereo(Right, Left);
end;

// Quick and dirty cube/quad buffers load->draw->unload

procedure Lib_rlLoadDrawCube();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlLoadDrawCube';
procedure rlLoadDrawCube();
begin
  Lib_rlLoadDrawCube();
end;

procedure Lib_rlLoadDrawQuad();
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'rlLoadDrawQuad';
procedure rlLoadDrawQuad();
begin
  Lib_rlLoadDrawQuad();
end;

initialization
  {$IF not Declared(RAYLIB_VERSION)}
  {$IFDEF FPC}
  SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);
  {$ELSE}
  FSetExceptMask(femALLEXCEPT);
  {$ENDIF}
  {$ENDIF}

end.
