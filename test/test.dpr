program test;

{$WARN DUPLICATE_CTOR_DTOR OFF}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  Proj4.API in '..\Proj4.API.pas',
  Proj4.Defines in '..\Proj4.Defines.pas',
  Proj4.GaussKruger in '..\Proj4.GaussKruger.pas',
  Proj4.Utils in '..\Proj4.Utils.pas',
  Proj4.UTM in '..\Proj4.UTM.pas',
  u_cs2cs_test in 'u_cs2cs_test.pas',
  u_mgrs_test in 'u_mgrs_test.pas';

begin
  Application.Initialize;
  if IsConsole then begin
    TextTestRunner.RunRegisteredTests;
  end else begin
    GUITestRunner.RunRegisteredTests;
  end;
end.

