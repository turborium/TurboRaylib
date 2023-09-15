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
//  Original files: raymath.h
//
//  Translator: @Turborium
//
//  Headers licensed under an unmodified MIT license, that allows static linking with closed source software
//
//  Copyright (c) 2022-2023 Turborium (https://github.com/turborium/TurboRaylib)
// -------------------------------------------------------------------------------------------------------------------

unit raymath;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}
{$ALIGN 8}
{$MINENUMSIZE 4}

interface

{$IFNDEF INDEPNDENT_RAYMATH}
uses
  raylib;
{$ENDIF}

{$INCLUDE raylib.inc}

const
  RAYMATH_VERSION = 1.5;

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
// Defines and Macros
//----------------------------------------------------------------------------------

const
  PI = System.Pi;
  EPSILON = 0.000001;
  DEG2RAD = (PI / 180.0);
  RAD2DEG = (180.0 / PI);

//----------------------------------------------------------------------------------
// Types and Structures Definition
//----------------------------------------------------------------------------------

type
  {$IF not Declared(TVector2)}
  PVector2 = ^TVector2;
  TVector2 = record
    X: Single; // Vector x component
    Y: Single; // Vector y component
  end;
  {$ELSE}
  PVector2 = raylib.PVector2;
  TVector2 = raylib.TVector2;
  {$ENDIF}

  {$IF not Declared(TVector3)}
  PVector3 = ^TVector3;
  TVector3 = record
    X: Single; // Vector x component
    Y: Single; // Vector y component
    Z: Single; // Vector z component
  end;
  {$ELSE}
  PVector3 = raylib.PVector3;
  TVector3 = raylib.TVector3;
  {$ENDIF}

  {$IF not Declared(TVector4)}
  PVector4 = ^TVector4;
  TVector4 = record
    X: Single; // Vector x component
    Y: Single; // Vector y component
    Z: Single; // Vector z component
    W: Single; // Vector w component
  end;
  {$ELSE}
  PVector4 = raylib.PVector4;
  TVector4 = raylib.TVector4;
  {$ENDIF}

  {$IF not Declared(TQuaternion)}
  PQuaternion = ^TQuaternion;
  TQuaternion = TVector4;
  {$ELSE}
  PQuaternion = raylib.PQuaternion;
  TQuaternion = raylib.TQuaternion;
  {$ENDIF}

  {$IF not Declared(TMatrix)}
  PMatrix = ^TMatrix;
  TMatrix = record
    M0, M4, M8, M12: Single;  // Matrix first row (4 components)
    M1, M5, M9, M13: Single;  // Matrix first row (4 components)
    M2, M6, M10, M14: Single; // Matrix first row (4 components)
    M3, M7, M11, M15: Single; // Matrix first row (4 components)
  end;
  {$ELSE}
  PMatrix = raylib.PMatrix;
  TMatrix = raylib.TMatrix;
  {$ENDIF}

  PFloat3 = ^TFloat3;
  TFloat3 = record
    V: array[0..3] of Single;
  end;

  PFloat16 = ^TFloat16;
  TFloat16 = record
    V: array[0..15] of Single;
  end;

//----------------------------------------------------------------------------------
// Module Functions Definition - Utils math
//----------------------------------------------------------------------------------

// Clamp float value
function Clamp(Value, Min, Max: Single): Single;
// Calculate linear interpolation between two floats
function Lerp(Start, End_, Amount: Single): Single;
// Normalize input value within input range
function Normalize(Value, Start, End_: Single): Single;
// Remap input value within input range to output range
function Remap(Value, InputStart, InputEnd, OutputStart, OutputEnd: Single): Single;
// Wrap input value from min to max
function Wrap(Value, Min, Max: Single): Single;
// Check whether two given floats are almost equal
function FloatEquals(X, Y: Single): Integer;

//----------------------------------------------------------------------------------
// Module Functions Definition - Vector2 math
//----------------------------------------------------------------------------------

// Vector with components value 0.0f
function Vector2Zero(): TVector2;
// Vector with components value 1.0f
function Vector2One(): TVector2;
// Add two vectors (v1 + v2)
function Vector2Add(V1, V2: TVector2): TVector2;
// Add vector and float value
function Vector2AddValue(V: TVector2; Add: Single): TVector2;
// Subtract two vectors (v1 - v2)
function Vector2Subtract(V1, V2: TVector2): TVector2;
// Subtract vector by float value
function Vector2SubtractValue(V: TVector2; Sub: Single): TVector2;
// Calculate vector length
function Vector2Length(V: TVector2): Single;
// Calculate vector square length
function Vector2LengthSqr(V: TVector2): Single;
// Calculate two vectors dot product
function Vector2DotProduct(V1, V2: TVector2): Single;
// Calculate distance between two vectors
function Vector2Distance(V1, V2: TVector2): Single;
// Calculate square distance between two vectors
function Vector2DistanceSqr(V1, V2: TVector2): Single;
// Calculate angle from two vectors
// NOTE: Angle is calculated from origin point (0, 0)
function Vector2Angle(V1, V2: TVector2): Single;
// Calculate angle defined by a two vectors line
// NOTE: Parameters need to be normalized
// Current implementation should be aligned with glm::angle
function Vector2LineAngle(Start, End_: TVector2): Single;
// Scale vector (multiply by value)
function Vector2Scale(V: TVector2; Scale: Single): TVector2;
// Multiply vector by vector
function Vector2Multiply(V1, V2: TVector2): TVector2;
// Negate vector
function Vector2Negate(V: TVector2): TVector2;
// Divide vector by vector
function Vector2Divide(V1, V2: TVector2): TVector2;
// Normalize provided vector
function Vector2Normalize(V: TVector2): TVector2;
// Transforms a Vector2 by a given Matrix
function Vector2Transform(V: TVector2; Mat: TMatrix): TVector2;
// Calculate linear interpolation between two vectors
function Vector2Lerp(V1, V2: TVector2; Amount: Single): TVector2;
// Calculate reflected vector to normal
function Vector2Reflect(V, Normal: TVector2): TVector2;
// Rotate vector by angle
function Vector2Rotate(V: TVector2; Angle: Single): TVector2;
// Move Vector towards target
function Vector2MoveTowards(V, Target: TVector2; MaxDistance: Single): TVector2;
// Invert the given vector
function Vector2Invert(V: TVector2): TVector2;
// Clamp the components of the vector between
// min and max values specified by the given vectors
function Vector2Clamp(V, Min, Max: TVector2): TVector2;
// Clamp the magnitude of the vector between two min and max values
function Vector2ClampValue(V, Min, Max: TVector2): TVector2;
// Check whether two given vectors are almost equal
function Vector2Equals(P, Q: TVector2): TVector2;

//----------------------------------------------------------------------------------
// Module Functions Definition - Vector3 math
//----------------------------------------------------------------------------------

// Vector with components value 0.0f
function Vector3Zero(): TVector3;
// Vector with components value 1.0f
function Vector3One(): TVector3;
// Add two vectors
function Vector3Add(V1, V2: TVector3): TVector3;
// Add vector and float value
function Vector3AddValue(V: Tvector3; Add: Single): TVector3;
// Subtract two vectors
function Vector3Subtract(V1, V2: TVector3): TVector3;
// Subtract vector by float value
function Vector3SubtractValue(V: TVector3; Sub: Single): TVector3;
// Multiply vector by scalar
function Vector3Scale(A: TVector3; Scalar: Single): TVector3;
// Multiply vector by vector
function Vector3Multiply(V1, V2: TVector3): TVector3;
// Calculate two vectors cross product
function Vector3CrossProduct(V1, V2: TVector3): TVector3;
// Calculate one vector perpendicular vector
function Vector3Perpendicular(V: TVector3): TVector3;
// Calculate vector length
function Vector3Length(V: TVector3): Single;
// Calculate vector square length
function Vector3LengthSqr(V: TVector3): Single;
// Calculate two vectors dot product
function Vector3DotProduct(V1, V2: TVector3): Single;
// Calculate distance between two vectors
function Vector3Distance(V1, V2: TVector3): Single;
// Calculate square distance between two vectors
function Vector3DistanceSqr(V1, V2: TVector3): Single;
// Calculate angle between two vectors
function Vector3Angle(V1, V2: TVector3): Single;
// Negate provided vector (invert direction)
function Vector3Negate(V: TVector3): TVector3;
// Divide vector by vector
function Vector3Divide(V1, V2: TVector3): TVector3;
// Normalize provided vector
function Vector3Normalize(V: TVector3): TVector3;
// Orthonormalize provided vectors
// Makes vectors normalized and orthogonal to each other
// Gram-Schmidt function implementation
procedure Vector3OrthoNormalize(V1, V2: PVector3);
// Transforms a Vector3 by a given Matrix
function Vector3Transform(V: TVector3; Mat: TMatrix): TVector3;
// Transform a vector by quaternion rotation
function Vector3RotateByQuaternion(V: TVector3; Q: TQuaternion): TVector3;
// Rotates a vector around an axis
function Vector3RotateByAxisAngle(V: TVector3; Axis: TVector3; Angle: Single): TVector3;
// Calculate linear interpolation between two vectors
function Vector3Lerp(V1, V2: TVector3; Amount: Single): TVector3;
// Calculate reflected vector to normal
function Vector3Reflect(V, Normal: TVector3): TVector3;
// Get min value for each pair of components
function Vector3Min(V1, V2: TVector3): TVector3;
// Get max value for each pair of components
function Vector3Max(V1, V2: TVector3): TVector3;
// Compute barycenter coordinates (u, v, w) for point p with respect to triangle (a, b, c)
// NOTE: Assumes P is on the plane of the triangle
function Vector3Barycenter(P, A, B, C: TVector3): TVector3;
// Projects a Vector3 from screen space into object space
// NOTE: We are avoiding calling other raymath functions despite available
function Vector3Unproject(Source: TVector3; Projection: TMatrix; View: TMatrix): TVector3;
// Get Vector3 as float array
function Vector3ToFloatV(V: TVector3): TFloat3;
// Invert the given vector
function Vector3Invert(V: TVector3): TVector3;
// Clamp the components of the vector between
// min and max values specified by the given vectors
function Vector3Clamp(V, Min, Max: TVector3): TVector3;
// Clamp the magnitude of the vector between two values
function Vector3ClampValue(V: TVector3; Min, Max: Single): TVector3;
// Check whether two given vectors are almost equal
function Vector3Equals(P, Q: TVector3): Integer;
// Compute the direction of a refracted ray where v specifies the
// normalized direction of the incoming ray, n specifies the
// normalized normal vector of the interface of two optical media,
// and r specifies the ratio of the refractive index of the medium
// from where the ray comes to the refractive index of the medium
// on the other side of the surface
function Vector3Refract(V, N: TVector3; R: Single): TVector3;

//----------------------------------------------------------------------------------
// Module Functions Definition - Matrix math
//----------------------------------------------------------------------------------

// Compute matrix determinant
function MatrixDeterminant(Mat: TMatrix): Single;
// Get the trace of the matrix (sum of the values along the diagonal)
function MatrixTrace(Mat: TMatrix): Single;
// Transposes provided matrix
function MatrixTranspose(Mat: TMatrix): TMatrix;
// Invert provided matrix
function MatrixInvert(Mat: TMatrix): TMatrix;
// Get identity matrix
function MatrixIdentity(): TMatrix;
// Add two matrices
function MatrixAdd(Left, Right: TMatrix): TMatrix;
// Subtract two matrices (left - right)
function MatrixSubtract(Left, Right: TMatrix): TMatrix;
// Get two matrix multiplication
// NOTE: When multiplying matrices... the order matters!
function MatrixMultiply(Left, Right: TMatrix): TMatrix;
// Get translation matrix
function MatrixTranslate(X, Y, Z: Single): TMatrix;
// Create rotation matrix from axis and angle
// NOTE: Angle should be provided in radians
function MatrixRotate(Axis: TVector3; Angle: Single): TMatrix;
// Get x-rotation matrix
// NOTE: Angle must be provided in radians
function MatrixRotateX(Angle: Single): TMatrix;
// Get y-rotation matrix
// NOTE: Angle must be provided in radians
function MatrixRotateY(Angle: Single): TMatrix;
// Get z-rotation matrix
// NOTE: Angle must be provided in radians
function MatrixRotateZ(Angle: Single): TMatrix;
// Get xyz-rotation matrix
// NOTE: Angle must be provided in radians
function MatrixRotateXYZ(Angle: TVector3): TMatrix;
// Get zyx-rotation matrix
// NOTE: Angle must be provided in radians
function MatrixRotateZYX(Angle: TVector3): TMatrix;
// Get scaling matrix
function MatrixScale(X, Y, Z: Single): TMatrix;
// Get perspective projection matrix
function MatrixFrustum(Left, Right, Bottom, Top, Near_, Far_: Double): TMatrix;
// Get perspective projection matrix
// NOTE: Fovy angle must be provided in radians
function MatrixPerspective(Fovy, Aspect, Near_, Far_: Double): TMatrix;
// Get orthographic projection matrix
function MatrixOrtho(Left, Right, Bottom, Top, Near_, Far_: Double): TMatrix;
// Get camera look-at matrix (view matrix)
function MatrixLookAt(Eye, Target, Up: TVector3): TMatrix;
// Get float array of matrix data
function MatrixToFloatV(Mat: TMatrix): TFloat16;

//----------------------------------------------------------------------------------
// Module Functions Definition - Quaternion math
//----------------------------------------------------------------------------------

// Add two quaternions
function QuaternionAdd(Q1, Q2: TQuaternion): TQuaternion;
// Add quaternion and float value
function QuaternionAddValue(Q: TQuaternion; Add: Single): TQuaternion;
// Subtract two quaternions
function QuaternionSubtract(Q1, Q2: TQuaternion): TQuaternion;
// Subtract quaternion and float value
function QuaternionSubtractValue(Q: TQuaternion; Sub: Single): TQuaternion;
// Get identity quaternion
function QuaternionIdentity(): TQuaternion;
// Computes the length of a quaternion
function QuaternionLength(Q: TQuaternion): Single;
// Normalize provided quaternion
function QuaternionNormalize(Q: TQuaternion): TQuaternion;
// Invert provided quaternion
function QuaternionInvert(Q: TQuaternion): TQuaternion;
// Calculate two quaternion multiplication
function QuaternionMultiply(Q1, Q2: TQuaternion): TQuaternion;
// Scale quaternion by float value
function QuaternionScale(Q: TQuaternion; Mul: Single): TQuaternion;
// Divide two quaternions
function QuaternionDivide(Q1, Q2: TQuaternion): TQuaternion;
// Calculate linear interpolation between two quaternions
function QuaternionLerp(Q1, Q2: TQuaternion; Amount: Single): TQuaternion;
// Calculate slerp-optimized interpolation between two quaternions
function QuaternionNlerp(Q1, Q2: TQuaternion; Amount: Single): TQuaternion;
// Calculates spherical linear interpolation between two quaternions
function QuaternionSlerp(Q1, Q2: TQuaternion; Amount: Single): TQuaternion;
// Calculate quaternion based on the rotation from one vector to another
function QuaternionFromVector3ToVector3(From, To_: TVector3): TQuaternion;
// Get a quaternion for a given rotation matrix
function QuaternionFromMatrix(Mat: TMatrix): TQuaternion;
// Get a matrix for a given quaternion
function QuaternionToMatrix(Q: TQuaternion): TMatrix;
// Get rotation quaternion for an angle and axis
// NOTE: Angle must be provided in radians
function QuaternionFromAxisAngle(Axis: TVector3; Angle: Single): TQuaternion;
// Get the rotation angle and axis for a given quaternion
procedure QuaternionToAxisAngle(Q: TQuaternion; OutAxis: PVector3; OutAngle: PSingle);
// Get the quaternion equivalent to Euler angles
// NOTE: Rotation order is ZYX
function QuaternionFromEuler(Pitch, Yaw, Roll: Single): TQuaternion;
// Get the Euler angles equivalent to quaternion (roll, pitch, yaw)
// NOTE: Angles are returned in a Vector3 struct in radians
function QuaternionToEuler(Q: TQuaternion): TVector3;
// Transform a quaternion given a transformation matrix
function QuaternionTransform(Q: TQuaternion; Mat: TMatrix): TQuaternion;
// Check whether two given quaternions are almost equal
function QuaternionEquals(P, Q: TQuaternion): Integer;

implementation

{$IF not Declared(RAYLIB_VERSION)}
{$IFDEF FPC}
uses
  Math;
{$ENDIF}
{$ENDIF}

// Module Functions Definition - Utils math

function Lib_Clamp(Value, Min, Max: Single): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Clamp';
function Clamp(Value, Min, Max: Single): Single;
begin
  Result := Lib_Clamp(Value, Min, Max);
end;

function Lib_Lerp(Start, End_, Amount: Single): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Lerp';
function Lerp(Start, End_, Amount: Single): Single;
begin
  Result := Lib_Lerp(Start, End_, Amount);
end;

function Lib_Normalize(Value, Start, End_: Single): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Normalize';
function Normalize(Value, Start, End_: Single): Single;
begin
  Result := Lib_Normalize(Value, Start, End_);
end;

function Lib_Remap(Value, InputStart, InputEnd, OutputStart, OutputEnd: Single): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Remap';
function Remap(Value, InputStart, InputEnd, OutputStart, OutputEnd: Single): Single;
begin
  Result := Lib_Remap(Value, InputStart, InputEnd, OutputStart, OutputEnd);
end;

function Lib_Wrap(Value, Min, Max: Single): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Wrap';
function Wrap(Value, Min, Max: Single): Single;
begin
  Result := Lib_Wrap(Value, Min, Max);
end;

function Lib_FloatEquals(X, Y: Single): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'FloatEquals';
function FloatEquals(X, Y: Single): Integer;
begin
  Result := Lib_FloatEquals(X, Y);
end;

// Module Functions Definition - Vector2 math

function Lib_Vector2Zero(): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2Zero';
function Vector2Zero(): TVector2;
begin
  Result := TVector2(Lib_Vector2Zero());
end;

function Lib_Vector2One(): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2One';
function Vector2One(): TVector2;
begin
  Result := TVector2(Lib_Vector2One());
end;

function Lib_Vector2Add(V1, V2: TVector2): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2Add';
function Vector2Add(V1, V2: TVector2): TVector2;
begin
  Result := TVector2(Lib_Vector2Add(V1, V2));
end;

function Lib_Vector2AddValue(V: TVector2; Add: Single): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2AddValue';
function Vector2AddValue(V: TVector2; Add: Single): TVector2;
begin
  Result := TVector2(Lib_Vector2AddValue(V, Add));
end;

function Lib_Vector2Subtract(V1, V2: TVector2): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2Subtract';
function Vector2Subtract(V1, V2: TVector2): TVector2;
begin
  Result := TVector2(Lib_Vector2Subtract(V1, V2));
end;

function Lib_Vector2SubtractValue(V: TVector2; Sub: Single): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2SubtractValue';
function Vector2SubtractValue(V: TVector2; Sub: Single): TVector2;
begin
  Result := TVector2(Lib_Vector2SubtractValue(V, Sub));
end;

function Lib_Vector2Length(V: TVector2): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2Length';
function Vector2Length(V: TVector2): Single;
begin
  Result := Lib_Vector2Length(V);
end;

function Lib_Vector2LengthSqr(V: TVector2): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2LengthSqr';
function Vector2LengthSqr(V: TVector2): Single;
begin
  Result := Lib_Vector2LengthSqr(V);
end;

function Lib_Vector2DotProduct(V1, V2: TVector2): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2DotProduct';
function Vector2DotProduct(V1, V2: TVector2): Single;
begin
  Result := Lib_Vector2DotProduct(V1, V2);
end;

function Lib_Vector2Distance(V1, V2: TVector2): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2Distance';
function Vector2Distance(V1, V2: TVector2): Single;
begin
  Result := Lib_Vector2Distance(V1, V2);
end;

function Lib_Vector2DistanceSqr(V1, V2: TVector2): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2DistanceSqr';
function Vector2DistanceSqr(V1, V2: TVector2): Single;
begin
  Result := Lib_Vector2DistanceSqr(V1, V2);
end;

function Lib_Vector2Angle(V1, V2: TVector2): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2Angle';
function Vector2Angle(V1, V2: TVector2): Single;
begin
  Result := Lib_Vector2Angle(V1, V2);
end;

function Lib_Vector2LineAngle(Start, End_: TVector2): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2LineAngle';
function Vector2LineAngle(Start, End_: TVector2): Single;
begin
  Result := Lib_Vector2LineAngle(Start, End_);
end;

function Lib_Vector2Scale(V: TVector2; Scale: Single): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2Scale';
function Vector2Scale(V: TVector2; Scale: Single): TVector2;
begin
  Result := TVector2(Lib_Vector2Scale(V, Scale));
end;

function Lib_Vector2Multiply(V1, V2: TVector2): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2Multiply';
function Vector2Multiply(V1, V2: TVector2): TVector2;
begin
  Result := TVector2(Lib_Vector2Multiply(V1, V2));
end;

function Lib_Vector2Negate(V: TVector2): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2Negate';
function Vector2Negate(V: TVector2): TVector2;
begin
  Result := TVector2(Lib_Vector2Negate(V));
end;

function Lib_Vector2Divide(V1, V2: TVector2): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2Divide';
function Vector2Divide(V1, V2: TVector2): TVector2;
begin
  Result := TVector2(Lib_Vector2Divide(V1, V2));
end;

function Lib_Vector2Normalize(V: TVector2): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2Normalize';
function Vector2Normalize(V: TVector2): TVector2;
begin
  Result := TVector2(Lib_Vector2Normalize(V));
end;

function Lib_Vector2Transform(V: TVector2; Mat: TMatrix): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2Transform';
function Vector2Transform(V: TVector2; Mat: TMatrix): TVector2;
begin
  Result := TVector2(Lib_Vector2Transform(V, Mat));
end;

function Lib_Vector2Lerp(V1, V2: TVector2; Amount: Single): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2Lerp';
function Vector2Lerp(V1, V2: TVector2; Amount: Single): TVector2;
begin
  Result := TVector2(Lib_Vector2Lerp(V1, V2, Amount));
end;

function Lib_Vector2Reflect(V, Normal: TVector2): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2Reflect';
function Vector2Reflect(V, Normal: TVector2): TVector2;
begin
  Result := TVector2(Lib_Vector2Reflect(V, Normal));
end;

function Lib_Vector2Rotate(V: TVector2; Angle: Single): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2Rotate';
function Vector2Rotate(V: TVector2; Angle: Single): TVector2;
begin
  Result := TVector2(Lib_Vector2Rotate(V, Angle));
end;

function Lib_Vector2MoveTowards(V, Target: TVector2; MaxDistance: Single): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2MoveTowards';
function Vector2MoveTowards(V, Target: TVector2; MaxDistance: Single): TVector2;
begin
  Result := TVector2(Lib_Vector2MoveTowards(V, Target, MaxDistance));
end;

function Lib_Vector2Invert(V: TVector2): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2Invert';
function Vector2Invert(V: TVector2): TVector2;
begin
  Result := TVector2(Lib_Vector2Invert(V));
end;

function Lib_Vector2Clamp(V, Min, Max: TVector2): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2Clamp';
function Vector2Clamp(V, Min, Max: TVector2): TVector2;
begin
  Result := TVector2(Lib_Vector2Clamp(V, Min, Max));
end;

function Lib_Vector2ClampValue(V, Min, Max: TVector2): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2ClampValue';
function Vector2ClampValue(V, Min, Max: TVector2): TVector2;
begin
  Result := TVector2(Lib_Vector2ClampValue(V, Min, Max));
end;

function Lib_Vector2Equals(P, Q: TVector2): {$IFNDEF RET_TRICK}TVector2{$ELSE}UInt64{$ENDIF};
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector2Equals';
function Vector2Equals(P, Q: TVector2): TVector2;
begin
  Result := TVector2(Lib_Vector2Equals(P, Q));
end;

// Module Functions Definition - Vector3 math

function Lib_Vector3Zero(): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Zero';
function Vector3Zero(): TVector3;
begin
  Result := Lib_Vector3Zero();
end;

function Lib_Vector3One(): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3One';
function Vector3One(): TVector3;
begin
  Result := Lib_Vector3One();
end;

function Lib_Vector3Add(V1, V2: TVector3): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Add';
function Vector3Add(V1, V2: TVector3): TVector3;
begin
  Result := Lib_Vector3Add(V1, V2);
end;

function Lib_Vector3AddValue(V: Tvector3; Add: Single): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3AddValue';
function Vector3AddValue(V: Tvector3; Add: Single): TVector3;
begin
  Result := Lib_Vector3AddValue(V, Add);
end;

function Lib_Vector3Subtract(V1, V2: TVector3): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Subtract';
function Vector3Subtract(V1, V2: TVector3): TVector3;
begin
  Result := Lib_Vector3Subtract(V1, V2);
end;

function Lib_Vector3SubtractValue(V: TVector3; Sub: Single): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3SubtractValue';
function Vector3SubtractValue(V: TVector3; Sub: Single): TVector3;
begin
  Result := Lib_Vector3SubtractValue(V, Sub);
end;

function Lib_Vector3Scale(A: TVector3; Scalar: Single): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Scale';
function Vector3Scale(A: TVector3; Scalar: Single): TVector3;
begin
  Result := Lib_Vector3Scale(A, Scalar);
end;

function Lib_Vector3Multiply(V1, V2: TVector3): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Multiply';
function Vector3Multiply(V1, V2: TVector3): TVector3;
begin
  Result := Lib_Vector3Multiply(V1, V2);
end;

function Lib_Vector3CrossProduct(V1, V2: TVector3): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3CrossProduct';
function Vector3CrossProduct(V1, V2: TVector3): TVector3;
begin
  Result := Lib_Vector3CrossProduct(V1, V2);
end;

function Lib_Vector3Perpendicular(V: TVector3): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Perpendicular';
function Vector3Perpendicular(V: TVector3): TVector3;
begin
  Result := Lib_Vector3Perpendicular(V);
end;

function Lib_Vector3Length(V: TVector3): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Length';
function Vector3Length(V: TVector3): Single;
begin
  Result := Lib_Vector3Length(V);
end;

function Lib_Vector3LengthSqr(V: TVector3): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3LengthSqr';
function Vector3LengthSqr(V: TVector3): Single;
begin
  Result := Lib_Vector3LengthSqr(V);
end;

function Lib_Vector3DotProduct(V1, V2: TVector3): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3DotProduct';
function Vector3DotProduct(V1, V2: TVector3): Single;
begin
  Result := Lib_Vector3DotProduct(V1, V2);
end;

function Lib_Vector3Distance(V1, V2: TVector3): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Distance';
function Vector3Distance(V1, V2: TVector3): Single;
begin
  Result := Lib_Vector3Distance(V1, V2);
end;

function Lib_Vector3DistanceSqr(V1, V2: TVector3): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3DistanceSqr';
function Vector3DistanceSqr(V1, V2: TVector3): Single;
begin
  Result := Lib_Vector3DistanceSqr(V1, V2);
end;

function Lib_Vector3Angle(V1, V2: TVector3): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Angle';
function Vector3Angle(V1, V2: TVector3): Single;
begin
  Result := Lib_Vector3Angle(V1, V2);
end;

function Lib_Vector3Negate(V: TVector3): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Negate';
function Vector3Negate(V: TVector3): TVector3;
begin
  Result := Lib_Vector3Negate(V);
end;

function Lib_Vector3Divide(V1, V2: TVector3): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Divide';
function Vector3Divide(V1, V2: TVector3): TVector3;
begin
  Result := Lib_Vector3Divide(V1, V2);
end;

function Lib_Vector3Normalize(V: TVector3): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Normalize';
function Vector3Normalize(V: TVector3): TVector3;
begin
  Result := Lib_Vector3Normalize(V);
end;

procedure Lib_Vector3OrthoNormalize(V1, V2: PVector3);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3OrthoNormalize';
procedure Vector3OrthoNormalize(V1, V2: PVector3);
begin
  Lib_Vector3OrthoNormalize(V1, V2);
end;

function Lib_Vector3Transform(V: TVector3; Mat: TMatrix): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Transform';
function Vector3Transform(V: TVector3; Mat: TMatrix): TVector3;
begin
  Result := Lib_Vector3Transform(V, Mat);
end;

function Lib_Vector3RotateByQuaternion(V: TVector3; Q: TQuaternion): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3RotateByQuaternion';
function Vector3RotateByQuaternion(V: TVector3; Q: TQuaternion): TVector3;
begin
  Result := Lib_Vector3RotateByQuaternion(V, Q);
end;

function Lib_Vector3RotateByAxisAngle(V: TVector3; Axis: TVector3; Angle: Single): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3RotateByAxisAngle';
function Vector3RotateByAxisAngle(V: TVector3; Axis: TVector3; Angle: Single): TVector3;
begin
  Result := Lib_Vector3RotateByAxisAngle(V, Axis, Angle);
end;

function Lib_Vector3Lerp(V1, V2: TVector3; Amount: Single): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Lerp';
function Vector3Lerp(V1, V2: TVector3; Amount: Single): TVector3;
begin
  Result := Lib_Vector3Lerp(V1, V2, Amount);
end;

function Lib_Vector3Reflect(V, Normal: TVector3): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Reflect';
function Vector3Reflect(V, Normal: TVector3): TVector3;
begin
  Result := Lib_Vector3Reflect(V, Normal);
end;

function Lib_Vector3Min(V1, V2: TVector3): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Min';
function Vector3Min(V1, V2: TVector3): TVector3;
begin
  Result := Lib_Vector3Min(V1, V2);
end;

function Lib_Vector3Max(V1, V2: TVector3): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Max';
function Vector3Max(V1, V2: TVector3): TVector3;
begin
  Result := Lib_Vector3Max(V1, V2);
end;

function Lib_Vector3Barycenter(P, A, B, C: TVector3): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Barycenter';
function Vector3Barycenter(P, A, B, C: TVector3): TVector3;
begin
  Result := Lib_Vector3Barycenter(P, A, B, C);
end;

function Lib_Vector3Unproject(Source: TVector3; Projection: TMatrix; View: TMatrix): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Unproject';
function Vector3Unproject(Source: TVector3; Projection: TMatrix; View: TMatrix): TVector3;
begin
  Result := Lib_Vector3Unproject(Source, Projection, View);
end;

function Lib_Vector3ToFloatV(V: TVector3): TFloat3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3ToFloatV';
function Vector3ToFloatV(V: TVector3): TFloat3;
begin
  Result := Lib_Vector3ToFloatV(V);
end;

function Lib_Vector3Invert(V: TVector3): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Invert';
function Vector3Invert(V: TVector3): TVector3;
begin
  Result := Lib_Vector3Invert(V);
end;

function Lib_Vector3Clamp(V, Min, Max: TVector3): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Clamp';
function Vector3Clamp(V, Min, Max: TVector3): TVector3;
begin
  Result := Lib_Vector3Clamp(V, Min, Max);
end;

function Lib_Vector3ClampValue(V: TVector3; Min, Max: Single): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3ClampValue';
function Vector3ClampValue(V: TVector3; Min, Max: Single): TVector3;
begin
  Result := Lib_Vector3ClampValue(V, Min, Max);
end;

function Lib_Vector3Equals(P, Q: TVector3): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Equals';
function Vector3Equals(P, Q: TVector3): Integer;
begin
  Result := Lib_Vector3Equals(P, Q);
end;

function Lib_Vector3Refract(V, N: TVector3; R: Single): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'Vector3Refract';
function Vector3Refract(V, N: TVector3; R: Single): TVector3;
begin
  Result := Lib_Vector3Refract(V, N, R);
end;

// Module Functions Definition - Matrix math

function Lib_MatrixDeterminant(Mat: TMatrix): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixDeterminant';
function MatrixDeterminant(Mat: TMatrix): Single;
begin
  Result := Lib_MatrixDeterminant(Mat);
end;

function Lib_MatrixTrace(Mat: TMatrix): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixTrace';
function MatrixTrace(Mat: TMatrix): Single;
begin
  Result := Lib_MatrixTrace(Mat);
end;

function Lib_MatrixTranspose(Mat: TMatrix): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixTranspose';
function MatrixTranspose(Mat: TMatrix): TMatrix;
begin
  Result := Lib_MatrixTranspose(Mat);
end;

function Lib_MatrixInvert(Mat: TMatrix): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixInvert';
function MatrixInvert(Mat: TMatrix): TMatrix;
begin
  Result := Lib_MatrixInvert(Mat);
end;

function Lib_MatrixIdentity(): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixIdentity';
function MatrixIdentity(): TMatrix;
begin
  Result := Lib_MatrixIdentity();
end;

function Lib_MatrixAdd(Left, Right: TMatrix): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixAdd';
function MatrixAdd(Left, Right: TMatrix): TMatrix;
begin
  Result := Lib_MatrixAdd(Left, Right);
end;

function Lib_MatrixSubtract(Left, Right: TMatrix): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixSubtract';
function MatrixSubtract(Left, Right: TMatrix): TMatrix;
begin
  Result := Lib_MatrixSubtract(Left, Right);
end;

function Lib_MatrixMultiply(Left, Right: TMatrix): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixMultiply';
function MatrixMultiply(Left, Right: TMatrix): TMatrix;
begin
  Result := Lib_MatrixMultiply(Left, Right);
end;

function Lib_MatrixTranslate(X, Y, Z: Single): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixTranslate';
function MatrixTranslate(X, Y, Z: Single): TMatrix;
begin
  Result := Lib_MatrixTranslate(X, Y, Z);
end;

function Lib_MatrixRotate(Axis: TVector3; Angle: Single): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixRotate';
function MatrixRotate(Axis: TVector3; Angle: Single): TMatrix;
begin
  Result := Lib_MatrixRotate(Axis, Angle);
end;

function Lib_MatrixRotateX(Angle: Single): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixRotateX';
function MatrixRotateX(Angle: Single): TMatrix;
begin
  Result := Lib_MatrixRotateX(Angle);
end;

function Lib_MatrixRotateY(Angle: Single): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixRotateY';
function MatrixRotateY(Angle: Single): TMatrix;
begin
  Result := Lib_MatrixRotateY(Angle);
end;

function Lib_MatrixRotateZ(Angle: Single): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixRotateZ';
function MatrixRotateZ(Angle: Single): TMatrix;
begin
  Result := Lib_MatrixRotateZ(Angle);
end;

function Lib_MatrixRotateXYZ(Angle: TVector3): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixRotateXYZ';
function MatrixRotateXYZ(Angle: TVector3): TMatrix;
begin
  Result := Lib_MatrixRotateXYZ(Angle);
end;

function Lib_MatrixRotateZYX(Angle: TVector3): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixRotateZYX';
function MatrixRotateZYX(Angle: TVector3): TMatrix;
begin
  Result := Lib_MatrixRotateZYX(Angle);
end;

function Lib_MatrixScale(X, Y, Z: Single): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixScale';
function MatrixScale(X, Y, Z: Single): TMatrix;
begin
  Result := Lib_MatrixScale(X, Y, Z);
end;

function Lib_MatrixFrustum(Left, Right, Bottom, Top, Near_, Far_: Double): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixFrustum';
function MatrixFrustum(Left, Right, Bottom, Top, Near_, Far_: Double): TMatrix;
begin
  Result := Lib_MatrixFrustum(Left, Right, Bottom, Top, Near_, Far_);
end;

function Lib_MatrixPerspective(Fovy, Aspect, Near_, Far_: Double): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixPerspective';
function MatrixPerspective(Fovy, Aspect, Near_, Far_: Double): TMatrix;
begin
  Result := Lib_MatrixPerspective(Fovy, Aspect, Near_, Far_);
end;

function Lib_MatrixOrtho(Left, Right, Bottom, Top, Near_, Far_: Double): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixOrtho';
function MatrixOrtho(Left, Right, Bottom, Top, Near_, Far_: Double): TMatrix;
begin
  Result := Lib_MatrixOrtho(Left, Right, Bottom, Top, Near_, Far_);
end;

function Lib_MatrixLookAt(Eye, Target, Up: TVector3): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixLookAt';
function MatrixLookAt(Eye, Target, Up: TVector3): TMatrix;
begin
  Result := Lib_MatrixLookAt(Eye, Target, Up);
end;

function Lib_MatrixToFloatV(Mat: TMatrix): TFloat16;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'MatrixToFloatV';
function MatrixToFloatV(Mat: TMatrix): TFloat16;
begin
  Result := Lib_MatrixToFloatV(Mat);
end;

// Module Functions Definition - Quaternion math

function Lib_QuaternionAdd(Q1, Q2: TQuaternion): TQuaternion;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionAdd';
function QuaternionAdd(Q1, Q2: TQuaternion): TQuaternion;
begin
  Result := Lib_QuaternionAdd(Q1, Q2);
end;

function Lib_QuaternionAddValue(Q: TQuaternion; Add: Single): TQuaternion;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionAddValue';
function QuaternionAddValue(Q: TQuaternion; Add: Single): TQuaternion;
begin
  Result := Lib_QuaternionAddValue(Q, Add);
end;

function Lib_QuaternionSubtract(Q1, Q2: TQuaternion): TQuaternion;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionSubtract';
function QuaternionSubtract(Q1, Q2: TQuaternion): TQuaternion;
begin
  Result := Lib_QuaternionSubtract(Q1, Q2);
end;

function Lib_QuaternionSubtractValue(Q: TQuaternion; Sub: Single): TQuaternion;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionSubtractValue';
function QuaternionSubtractValue(Q: TQuaternion; Sub: Single): TQuaternion;
begin
  Result := Lib_QuaternionSubtractValue(Q, Sub);
end;

function Lib_QuaternionIdentity(): TQuaternion;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionIdentity';
function QuaternionIdentity(): TQuaternion;
begin
  Result := Lib_QuaternionIdentity();
end;

function Lib_QuaternionLength(Q: TQuaternion): Single;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionLength';
function QuaternionLength(Q: TQuaternion): Single;
begin
  Result := Lib_QuaternionLength(Q);
end;

function Lib_QuaternionNormalize(Q: TQuaternion): TQuaternion;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionNormalize';
function QuaternionNormalize(Q: TQuaternion): TQuaternion;
begin
  Result := Lib_QuaternionNormalize(Q);
end;

function Lib_QuaternionInvert(Q: TQuaternion): TQuaternion;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionInvert';
function QuaternionInvert(Q: TQuaternion): TQuaternion;
begin
  Result := Lib_QuaternionInvert(Q);
end;

function Lib_QuaternionMultiply(Q1, Q2: TQuaternion): TQuaternion;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionMultiply';
function QuaternionMultiply(Q1, Q2: TQuaternion): TQuaternion;
begin
  Result := Lib_QuaternionMultiply(Q1, Q2);
end;

function Lib_QuaternionScale(Q: TQuaternion; Mul: Single): TQuaternion;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionScale';
function QuaternionScale(Q: TQuaternion; Mul: Single): TQuaternion;
begin
  Result := Lib_QuaternionScale(Q, Mul);
end;

function Lib_QuaternionDivide(Q1, Q2: TQuaternion): TQuaternion;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionDivide';
function QuaternionDivide(Q1, Q2: TQuaternion): TQuaternion;
begin
  Result := Lib_QuaternionDivide(Q1, Q2);
end;

function Lib_QuaternionLerp(Q1, Q2: TQuaternion; Amount: Single): TQuaternion;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionLerp';
function QuaternionLerp(Q1, Q2: TQuaternion; Amount: Single): TQuaternion;
begin
  Result := Lib_QuaternionLerp(Q1, Q2, Amount);
end;

function Lib_QuaternionNlerp(Q1, Q2: TQuaternion; Amount: Single): TQuaternion;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionNlerp';
function QuaternionNlerp(Q1, Q2: TQuaternion; Amount: Single): TQuaternion;
begin
  Result := Lib_QuaternionNlerp(Q1, Q2, Amount);
end;

function Lib_QuaternionSlerp(Q1, Q2: TQuaternion; Amount: Single): TQuaternion;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionSlerp';
function QuaternionSlerp(Q1, Q2: TQuaternion; Amount: Single): TQuaternion;
begin
  Result := Lib_QuaternionSlerp(Q1, Q2, Amount);
end;

function Lib_QuaternionFromVector3ToVector3(From, To_: TVector3): TQuaternion;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionFromVector3ToVector3';
function QuaternionFromVector3ToVector3(From, To_: TVector3): TQuaternion;
begin
  Result := Lib_QuaternionFromVector3ToVector3(From, To_);
end;

function Lib_QuaternionFromMatrix(Mat: TMatrix): TQuaternion;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionFromMatrix';
function QuaternionFromMatrix(Mat: TMatrix): TQuaternion;
begin
  Result := Lib_QuaternionFromMatrix(Mat);
end;

function Lib_QuaternionToMatrix(Q: TQuaternion): TMatrix;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionToMatrix';
function QuaternionToMatrix(Q: TQuaternion): TMatrix;
begin
  Result := Lib_QuaternionToMatrix(Q);
end;

function Lib_QuaternionFromAxisAngle(Axis: TVector3; Angle: Single): TQuaternion;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionFromAxisAngle';
function QuaternionFromAxisAngle(Axis: TVector3; Angle: Single): TQuaternion;
begin
  Result := Lib_QuaternionFromAxisAngle(Axis, Angle);
end;

procedure Lib_QuaternionToAxisAngle(Q: TQuaternion; OutAxis: PVector3; OutAngle: PSingle);
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionToAxisAngle';
procedure QuaternionToAxisAngle(Q: TQuaternion; OutAxis: PVector3; OutAngle: PSingle);
begin
  Lib_QuaternionToAxisAngle(Q, OutAxis, OutAngle);
end;

function Lib_QuaternionFromEuler(Pitch, Yaw, Roll: Single): TQuaternion;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionFromEuler';
function QuaternionFromEuler(Pitch, Yaw, Roll: Single): TQuaternion;
begin
  Result := Lib_QuaternionFromEuler(Pitch, Yaw, Roll);
end;

function Lib_QuaternionToEuler(Q: TQuaternion): TVector3;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionToEuler';
function QuaternionToEuler(Q: TQuaternion): TVector3;
begin
  Result := Lib_QuaternionToEuler(Q);
end;

function Lib_QuaternionTransform(Q: TQuaternion; Mat: TMatrix): TQuaternion;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionTransform';
function QuaternionTransform(Q: TQuaternion; Mat: TMatrix): TQuaternion;
begin
  Result := Lib_QuaternionTransform(Q, Mat);
end;

function Lib_QuaternionEquals(P, Q: TQuaternion): Integer;
  cdecl; external {$IFNDEF RAY_STATIC}LibName{$ENDIF} name 'QuaternionEquals';
function QuaternionEquals(P, Q: TQuaternion): Integer;
begin
  Result := Lib_QuaternionEquals(P, Q);
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

