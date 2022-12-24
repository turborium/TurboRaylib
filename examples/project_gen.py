def make_lpi_file(project_name, osx_lib_name, libs):
	text_libs = ''
	if 'reasings' in libs:
		text_libs += '\n      <Unit>\n        <Filename Value="../../../raylib/extras/reasings.pas"/>\n        <IsPartOfProject Value="True"/>\n      </Unit>'
	if 'rlights' in libs:
		text_libs += '\n      <Unit>\n        <Filename Value="rlights.pas"/>\n        <IsPartOfProject Value="True"/>\n      </Unit>'
	text_units = ''
	if 'reasings' in libs:
		text_units += ';../../../raylib/extras'
	return f"""
<?xml version="1.0" encoding="UTF-8"?>
<CONFIG>
  <ProjectOptions>
    <Version Value="12"/>
    <General>
      <Flags>
        <MainUnitHasCreateFormStatements Value="False"/>
        <MainUnitHasTitleStatement Value="False"/>
        <MainUnitHasScaledStatement Value="False"/>
      </Flags>
      <SessionStorage Value="InProjectDir"/>
      <Title Value="{project_name}"/>
      <UseAppBundle Value="False"/>
      <ResourceType Value="res"/>
    </General>
    <BuildModes>
      <Item Name="Default" Default="True"/>
    </BuildModes>
    <PublishOptions>
      <Version Value="2"/>
      <UseFileFilters Value="True"/>
    </PublishOptions>
    <RunParams>
      <FormatVersion Value="2"/>
    </RunParams>
    <Units>
      <Unit>
        <Filename Value="{project_name}.lpr"/>
        <IsPartOfProject Value="True"/>
      </Unit>
      <Unit>
        <Filename Value="{project_name}_src.pas"/>
        <IsPartOfProject Value="True"/>
      </Unit>
      <Unit>
        <Filename Value="../../../raylib/raylib.pas"/>
        <IsPartOfProject Value="True"/>
      </Unit>
      <Unit>
        <Filename Value="../../../raylib/raymath.pas"/>
        <IsPartOfProject Value="True"/>
      </Unit>
      <Unit>
        <Filename Value="../../../raylib/rlgl.pas"/>
        <IsPartOfProject Value="True"/>
      </Unit>{text_libs}
    </Units>
  </ProjectOptions>
  <CompilerOptions>
    <Version Value="11"/>
    <SearchPaths>
      <IncludeFiles Value="$(ProjOutDir)"/>
      <OtherUnitFiles Value="../../../raylib{text_units}"/>
      <UnitOutputDirectory Value="lib/$(TargetCPU)-$(TargetOS)"/>
    </SearchPaths>
    <Conditionals Value="// libs
if TargetOS = &apos;darwin&apos; then
begin
  LinkerOptions += &apos; ../../output/osx/{osx_lib_name} -rpath @executable_path/&apos;;
  OutputDir := &apos;../../output/osx/&apos;;
end;
if TargetOS = &apos;win64&apos; then
begin
  OutputDir := &apos;../../output/win64/&apos;;
end;
if TargetOS = &apos;win32&apos; then
begin
  OutputDir := &apos;../../output/win32/&apos;;
end;"/>
    <Linking>
      <Debugging>
        <DebugInfoType Value="dsDwarf2Set"/>
      </Debugging>
      <Options>
        <PassLinkerOptions Value="True"/>
      </Options>
    </Linking>
  </CompilerOptions>
  <Debugging>
    <Exceptions>
      <Item>
        <Name Value="EAbort"/>
      </Item>
      <Item>
        <Name Value="ECodetoolError"/>
      </Item>
      <Item>
        <Name Value="EFOpenError"/>
      </Item>
    </Exceptions>
  </Debugging>
</CONFIG>
""".split('\n', 1)[1]

def make_dproj_file(project_name, index, libs):
	text_libs = ''
	if 'reasings' in libs:
		text_libs += '\n        <DCCReference Include="..\..\..\\raylib\extras\\reasings.pas"/>'
	if 'rlights' in libs:
		text_libs += '\n        <DCCReference Include="rlights.pas"/>'
	return f"""
<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
    <PropertyGroup>
        <Base>True</Base>
        <AppType>Console</AppType>
        <Config Condition="'$(Config)'==''">Debug</Config>
        <FrameworkType>None</FrameworkType>
        <MainSource>{project_name}.dpr</MainSource>
        <Platform Condition="'$(Platform)'==''">Win32</Platform>
        <ProjectGuid>{{F3AF60F8-DA40-4963-B747-{index:012d}}}</ProjectGuid>
        <ProjectVersion>19.4</ProjectVersion>
        <TargetedPlatforms>3</TargetedPlatforms>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Config)'=='Base' or '$(Base)'!=''">
        <Base>true</Base>
    </PropertyGroup>
    <PropertyGroup Condition="('$(Platform)'=='Win32' and '$(Base)'=='true') or '$(Base_Win32)'!=''">
        <Base_Win32>true</Base_Win32>
        <CfgParent>Base</CfgParent>
        <Base>true</Base>
    </PropertyGroup>
    <PropertyGroup Condition="('$(Platform)'=='Win64' and '$(Base)'=='true') or '$(Base_Win64)'!=''">
        <Base_Win64>true</Base_Win64>
        <CfgParent>Base</CfgParent>
        <Base>true</Base>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Config)'=='Debug' or '$(Cfg_1)'!=''">
        <Cfg_1>true</Cfg_1>
        <CfgParent>Base</CfgParent>
        <Base>true</Base>
    </PropertyGroup>
    <PropertyGroup Condition="('$(Platform)'=='Win32' and '$(Cfg_1)'=='true') or '$(Cfg_1_Win32)'!=''">
        <Cfg_1_Win32>true</Cfg_1_Win32>
        <CfgParent>Cfg_1</CfgParent>
        <Cfg_1>true</Cfg_1>
        <Base>true</Base>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Config)'=='Release' or '$(Cfg_2)'!=''">
        <Cfg_2>true</Cfg_2>
        <CfgParent>Base</CfgParent>
        <Base>true</Base>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Base)'!=''">
        <SanitizedProjectName>{project_name}</SanitizedProjectName>
        <DCC_DcuOutput>.\$(Platform)\$(Config)</DCC_DcuOutput>
        <DCC_ExeOutput>.\$(Platform)\$(Config)</DCC_ExeOutput>
        <DCC_Namespace>System;Xml;Data;Datasnap;Web;Soap;$(DCC_Namespace)</DCC_Namespace>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Base_Win32)'!=''">
        <AppDPIAwarenessMode>none</AppDPIAwarenessMode>
        <BT_BuildType>Debug</BT_BuildType>
        <DCC_ConsoleTarget>true</DCC_ConsoleTarget>
        <DCC_ExeOutput>..\..\output\win32\</DCC_ExeOutput>
        <DCC_Namespace>Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Bde;$(DCC_Namespace)</DCC_Namespace>
        <DCC_UsePackage>vclwinx;DataSnapServer;fmx;emshosting;vclie;DbxCommonDriver;bindengine;IndyIPCommon;VCLRESTComponents;DBXMSSQLDriver;FireDACCommonODBC;emsclient;FireDACCommonDriver;appanalytics;IndyProtocols;vclx;IndyIPClient;dbxcds;vcledge;bindcompvclwinx;FmxTeeUI;EsVclComponents;emsedge;bindcompfmx;DBXFirebirdDriver;inetdb;ibmonitor;FireDACSqliteDriver;DbxClientDriver;FireDACASADriver;Tee;soapmidas;vclactnband;TeeUI;fmxFireDAC;dbexpress;FireDACInfxDriver;DBXMySQLDriver;VclSmp;inet;DataSnapCommon;vcltouch;fmxase;DBXOdbcDriver;dbrtl;FireDACDBXDriver;FireDACOracleDriver;fmxdae;TeeDB;FireDACMSAccDriver;CustomIPTransport;FireDACMSSQLDriver;DataSnapIndy10ServerTransport;DataSnapConnectors;vcldsnap;DBXInterBaseDriver;FireDACMongoDBDriver;IndySystem;FireDACTDataDriver;vcldb;ibxbindings;vclFireDAC;bindcomp;FireDACCommon;DataSnapServerMidas;FireDACODBCDriver;emsserverresource;IndyCore;RESTBackendComponents;bindcompdbx;rtl;FireDACMySQLDriver;FireDACADSDriver;RESTComponents;DBXSqliteDriver;vcl;IndyIPServer;dsnapxml;dsnapcon;DataSnapClient;DataSnapProviderClient;adortl;DBXSybaseASEDriver;DBXDb2Driver;vclimg;DataSnapFireDAC;emsclientfiredac;FireDACPgDriver;FireDAC;FireDACDSDriver;inetdbxpress;xmlrtl;tethering;ibxpress;bindcompvcl;dsnap;CloudService;DBXSybaseASADriver;DBXOracleDriver;FireDACDb2Driver;DBXInformixDriver;vclib;fmxobj;bindcompvclsmp;FMXTee;DataSnapNativeClient;DatasnapConnectorsFreePascal;soaprtl;soapserver;FireDACIBDriver;$(DCC_UsePackage)</DCC_UsePackage>
        <Manifest_File>(None)</Manifest_File>
        <VerInfo_Keys>CompanyName=;FileDescription=$(MSBuildProjectName);FileVersion=1.0.0.0;InternalName=;LegalCopyright=;LegalTrademarks=;OriginalFilename=;ProgramID=com.embarcadero.$(MSBuildProjectName);ProductName=$(MSBuildProjectName);ProductVersion=1.0.0.0;Comments=</VerInfo_Keys>
        <VerInfo_Locale>1033</VerInfo_Locale>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Base_Win64)'!=''">
        <AppDPIAwarenessMode>none</AppDPIAwarenessMode>
        <BT_BuildType>Debug</BT_BuildType>
        <DCC_ConsoleTarget>true</DCC_ConsoleTarget>
        <DCC_ExeOutput>..\..\output\win64\</DCC_ExeOutput>
        <DCC_Namespace>Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;$(DCC_Namespace)</DCC_Namespace>
        <DCC_UsePackage>vclwinx;DataSnapServer;fmx;emshosting;vclie;DbxCommonDriver;bindengine;IndyIPCommon;VCLRESTComponents;DBXMSSQLDriver;FireDACCommonODBC;emsclient;FireDACCommonDriver;appanalytics;IndyProtocols;vclx;IndyIPClient;dbxcds;vcledge;bindcompvclwinx;FmxTeeUI;EsVclComponents;emsedge;bindcompfmx;DBXFirebirdDriver;inetdb;ibmonitor;FireDACSqliteDriver;DbxClientDriver;FireDACASADriver;Tee;soapmidas;vclactnband;TeeUI;fmxFireDAC;dbexpress;FireDACInfxDriver;DBXMySQLDriver;VclSmp;inet;DataSnapCommon;vcltouch;fmxase;DBXOdbcDriver;dbrtl;FireDACDBXDriver;FireDACOracleDriver;fmxdae;TeeDB;FireDACMSAccDriver;CustomIPTransport;FireDACMSSQLDriver;DataSnapIndy10ServerTransport;DataSnapConnectors;vcldsnap;DBXInterBaseDriver;FireDACMongoDBDriver;IndySystem;FireDACTDataDriver;vcldb;ibxbindings;vclFireDAC;bindcomp;FireDACCommon;DataSnapServerMidas;FireDACODBCDriver;emsserverresource;IndyCore;RESTBackendComponents;bindcompdbx;rtl;FireDACMySQLDriver;FireDACADSDriver;RESTComponents;DBXSqliteDriver;vcl;IndyIPServer;dsnapxml;dsnapcon;DataSnapClient;DataSnapProviderClient;adortl;DBXSybaseASEDriver;DBXDb2Driver;vclimg;DataSnapFireDAC;emsclientfiredac;FireDACPgDriver;FireDAC;FireDACDSDriver;inetdbxpress;xmlrtl;tethering;ibxpress;bindcompvcl;dsnap;CloudService;DBXSybaseASADriver;DBXOracleDriver;FireDACDb2Driver;DBXInformixDriver;vclib;fmxobj;bindcompvclsmp;FMXTee;DataSnapNativeClient;DatasnapConnectorsFreePascal;soaprtl;soapserver;FireDACIBDriver;$(DCC_UsePackage)</DCC_UsePackage>
        <Manifest_File>(None)</Manifest_File>
        <VerInfo_Keys>CompanyName=;FileDescription=$(MSBuildProjectName);FileVersion=1.0.0.0;InternalName=;LegalCopyright=;LegalTrademarks=;OriginalFilename=;ProgramID=com.embarcadero.$(MSBuildProjectName);ProductName=$(MSBuildProjectName);ProductVersion=1.0.0.0;Comments=</VerInfo_Keys>
        <VerInfo_Locale>1033</VerInfo_Locale>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Cfg_1)'!=''">
        <DCC_DebugDCUs>true</DCC_DebugDCUs>
        <DCC_DebugInfoInExe>true</DCC_DebugInfoInExe>
        <DCC_Define>DEBUG;$(DCC_Define)</DCC_Define>
        <DCC_GenerateStackFrames>true</DCC_GenerateStackFrames>
        <DCC_IntegerOverflowCheck>true</DCC_IntegerOverflowCheck>
        <DCC_Optimize>false</DCC_Optimize>
        <DCC_RangeChecking>true</DCC_RangeChecking>
        <DCC_RemoteDebug>true</DCC_RemoteDebug>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Cfg_1_Win32)'!=''">
        <AppDPIAwarenessMode>none</AppDPIAwarenessMode>
        <DCC_RemoteDebug>false</DCC_RemoteDebug>
    </PropertyGroup>
    <PropertyGroup Condition="'$(Cfg_2)'!=''">
        <DCC_DebugInformation>0</DCC_DebugInformation>
        <DCC_Define>RELEASE;$(DCC_Define)</DCC_Define>
        <DCC_LocalDebugSymbols>false</DCC_LocalDebugSymbols>
        <DCC_SymbolReferenceInfo>0</DCC_SymbolReferenceInfo>
    </PropertyGroup>
    <ItemGroup>
        <DelphiCompile Include="$(MainSource)">
            <MainSource>MainSource</MainSource>
        </DelphiCompile>
        <DCCReference Include="..\..\..\\raylib\\raylib.pas"/>
        <DCCReference Include="..\..\..\\raylib\\raymath.pas"/>
        <DCCReference Include="..\..\..\\raylib\\rlgl.pas"/>{text_libs}
        <DCCReference Include="{project_name}_src.pas"/>
        <BuildConfiguration Include="Base">
            <Key>Base</Key>
        </BuildConfiguration>
        <BuildConfiguration Include="Debug">
            <Key>Cfg_1</Key>
            <CfgParent>Base</CfgParent>
        </BuildConfiguration>
        <BuildConfiguration Include="Release">
            <Key>Cfg_2</Key>
            <CfgParent>Base</CfgParent>
        </BuildConfiguration>
    </ItemGroup>
    <ProjectExtensions>
        <Borland.Personality>Delphi.Personality.12</Borland.Personality>
        <Borland.ProjectType>Application</Borland.ProjectType>
        <BorlandProject>
            <Delphi.Personality>
                <Source>
                    <Source Name="MainSource">{project_name}.dpr</Source>
                </Source>
                <Excluded_Packages/>
            </Delphi.Personality>
            <Platforms>
                <Platform value="Android">False</Platform>
                <Platform value="Android64">False</Platform>
                <Platform value="Linux64">False</Platform>
                <Platform value="OSX64">False</Platform>
                <Platform value="OSXARM64">False</Platform>
                <Platform value="Win32">True</Platform>
                <Platform value="Win64">True</Platform>
                <Platform value="iOSDevice64">False</Platform>
            </Platforms>
        </BorlandProject>
        <ProjectFileVersion>12</ProjectFileVersion>
    </ProjectExtensions>
    <Import Project="$(BDS)\Bin\CodeGear.Delphi.Targets" Condition="Exists('$(BDS)\Bin\CodeGear.Delphi.Targets')"/>
    <Import Project="$(APPDATA)\Embarcadero\$(BDSAPPDATABASEDIR)\$(PRODUCTVERSION)\\UserTools.proj" Condition="Exists('$(APPDATA)\Embarcadero\$(BDSAPPDATABASEDIR)\$(PRODUCTVERSION)\\UserTools.proj')"/>
    <Import Project="$(MSBuildProjectName).deployproj" Condition="Exists('$(MSBuildProjectName).deployproj')"/>
</Project>
""".split('\n', 1)[1]

def make_lpr_file(project_name, libs):
	text_libs = ''
	if 'cthreads' in libs:
		text_libs += "\n  {$IFDEF UNIX}\n  cthreads,\n  cmem,\n  {$ENDIF}"
	return f"""
program {project_name};

uses{text_libs}
  SysUtils,
  {project_name}_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
""".split('\n', 1)[1]

def make_dpr_file(project_name, libs):
	text_libs = ''
	if 'reasings' in libs:
		text_libs += "\n  reasings in '..\..\..\\raylib\extras\\reasings.pas',"
	if 'rlights' in libs:
		text_libs += "\n  rlights in 'rlights.pas',"
	return f"""
program {project_name};

{{$APPTYPE CONSOLE}}

{{$R *.res}}

uses
  SysUtils,
  raylib in '..\..\..\\raylib\\raylib.pas',
  raymath in '..\..\..\\raylib\\raymath.pas',
  rlgl in '..\..\..\\raylib\\rlgl.pas',{text_libs}
  {project_name}_src in '{project_name}_src.pas';

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
""".split('\n', 1)[1]

import os

def make_lazarus_project(params, index):
	extra_libs = []
	
	if isinstance(params, str):
		dir = params
	else:
		dir = params[0]
		extra_libs = params[1]
	
	project_name = os.path.split(os.path.normpath(dir))[-1]

	print(f'work with: "{project_name}"')
	
	
	
	# lpi
	with open(os.path.join(dir, project_name + '.lpi'), 'w') as file:
		file.write(make_lpi_file(project_name, 'libraylib.420.dylib', extra_libs))
	# lpr
	with open(os.path.join(dir, project_name + '.lpr'), 'w') as file:
		file.write(make_lpr_file(project_name, extra_libs))
	# dproj
	with open(os.path.join(dir, project_name + '.dproj'), 'w') as file:
		file.write(make_dproj_file(project_name, index, extra_libs))
	# dpr
	with open(os.path.join(dir, project_name + '.dpr'), 'w') as file:
		file.write(make_dpr_file(project_name, extra_libs))


samples = [
	# core
	'core/core_2d_camera',
	'core/core_2d_camera_mouse_zoom',
	'core/core_2d_camera_platformer',
	'core/core_3d_camera_first_person',
	'core/core_3d_camera_free',
	'core/core_3d_camera_mode',
	'core/core_3d_picking',
	'core/core_basic_screen_manager',
	'core/core_basic_window',
	'core/core_custom_frame_control',
	'core/core_custom_logging',
	'core/core_drop_files',
	'core/core_input_keys',
	'core/core_input_mouse',
	'core/core_input_mouse_wheel',
	['core/core_loading_thread', ['cthreads']],
	'core/core_random_values',
	'core/core_scissor_test',
	'core/core_smooth_pixelperfect',
	'core/core_split_screen',
	'core/core_storage_values',
	'core/core_window_flags',
	'core/core_window_letterbox',
	'core/core_window_should_close',
	'core/core_world_screen',
	#audio
	'audio/audio_module_playing',
	'audio/audio_multichannel_sound',
	'audio/audio_music_stream',
	'audio/audio_raw_stream',
	'audio/audio_sound_loading',
	# models
	'models/models_animation',
	'models/models_billboard',
	'models/models_box_collisions',
	'models/models_cubicmap',
	'models/models_first_person_maze',
	'models/models_geometric_shapes',
	'models/models_heightmap',
	'models/models_loading',
	'models/models_loading_gltf',
	'models/models_loading_m3d',
	'models/models_loading_vox',
	'models/models_mesh_generation',
	'models/models_mesh_picking',
	'models/models_orthographic_projection',
	'models/models_rlgl_solar_system',
	'models/models_waving_cubes',
	'models/models_yaw_pitch_roll',
	# shaders
	['shaders/shaders_basic_lighting', ['rlights']],
	'shaders/shaders_custom_uniform',
	'shaders/shaders_eratosthenes',
	['shaders/shaders_fog', ['rlights']],
	'shaders/shaders_julia_set',
	['shaders/shaders_mesh_instancing', ['rlights']],
	'shaders/shaders_model_shader',
	'shaders/shaders_palette_switch',
	'shaders/shaders_postprocessing',
	'shaders/shaders_raymarching',
	'shaders/shaders_shapes_textures',
	'shaders/shaders_simple_mask',
	'shaders/shaders_texture_drawing',
	'shaders/shaders_texture_outline',
	'shaders/shaders_texture_waves',
	# shapes
	'shapes/shapes_basic_shapes',	
	'shapes/shapes_bouncing_ball',
	'shapes/shapes_collision_area',	
	'shapes/shapes_colors_palette',	
	'shapes/shapes_draw_ring',	
	['shapes/shapes_easings_ball_anim', ['reasings']],	
	['shapes/shapes_easings_box_anim', ['reasings']],	
	['shapes/shapes_easings_rectangle_array', ['reasings']],
	'shapes/shapes_following_eyes',	
	'shapes/shapes_lines_bezier',	
	'shapes/shapes_logo_raylib',	
	'shapes/shapes_logo_raylib_anim',	
	'shapes/shapes_rectangle_scaling',	
	'shapes/shapes_top_down_lights',
	# text
	'text/text_font_filters',
	'text/text_font_loading',
	'text/text_font_sdf',
	'text/text_font_spritefont',
	'text/text_format_text',
	'text/text_input_box',
	'text/text_raylib_fonts',
	'text/text_rectangle_bounds',
	'text/text_writing_anim',
]

for index, sample in enumerate(samples):
	make_lazarus_project(sample, index + 1)
	
	
	