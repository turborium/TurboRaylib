def make_lpi_file(project_name, osx_lib_name):
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
      </Unit>
    </Units>
  </ProjectOptions>
  <CompilerOptions>
    <Version Value="11"/>
    <SearchPaths>
      <IncludeFiles Value="$(ProjOutDir)"/>
      <OtherUnitFiles Value="../../../raylib"/>
      <UnitOutputDirectory Value="lib/$(TargetCPU)-$(TargetOS)"/>
    </SearchPaths>
    <Conditionals Value="// libs
if TargetOS = &apos;darwin&apos; then
begin
  LinkerOptions += &apos; ../../output/osx/{osx_lib_name} -rpath @executable_path/&apos;;
  OutputDir := &apos;../../output/osx/&apos;;
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

def make_lpr_file(project_name):
	return f"""
program {project_name};

uses
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

import os

def make_lazarus_project(dir):
	project_name = os.path.split(os.path.normpath(dir))[-1]

	print(f'work with: "{project_name}"')
	# lpi
	with open(os.path.join(dir, project_name + '.lpi'), 'w') as file:
		file.write(make_lpi_file(project_name, 'libraylib.420.dylib'))
	# lpr
	with open(os.path.join(dir, project_name + '.lpr'), 'w') as file:
		file.write(make_lpr_file(project_name))


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
	'core/core_loading_thread',
	'core/core_random_values',
	'core/core_scissor_test',
	'core/core_smooth_pixelperfect',
	'core/core_split_screen',
	'core/core_storage_values',
	'core/core_window_flags',
	'core/core_window_letterbox',
	'core/core_window_should_close',
	'core/core_world_screen',
]

for sample in samples:
	make_lazarus_project(sample)