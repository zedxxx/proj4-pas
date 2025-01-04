unit u_cs2cs_test;

interface

uses
  TestFramework;

type
  TestCS2CS = class(TTestCase)
  private
    procedure DoTest_3857_to_4326(const ASrc, ADest: AnsiString);
    procedure DoTest_4326_to_3857(const ASrc, ADest: AnsiString);
  protected
    procedure SetUp; override;
  published
    procedure Test_3857_to_4326_InternalDef;
    procedure Test_3857_to_4326_ExternalDef;

    procedure Test_4326_to_3857_InternalDef;
    procedure Test_4326_to_3857_ExternalDef;
  end;

implementation

uses
  SysUtils,
  Proj4.API,
  Proj4.Defines,
  Proj4.Utils;

{ TestCS2CS }

procedure TestCS2CS.SetUp;
begin
  inherited;
  init_proj4_dll('proj.dll', True, ExtractFilePath(ParamStr(0)) + 'share\proj\');
end;

procedure TestCS2CS.DoTest_3857_to_4326(const ASrc, ADest: AnsiString);
const
  CEpsilon = 1E-7;
var
  VRet: Boolean;
  VErrNo: Integer;
  VLon, VLat: Double;
begin
  // https://epsg.io/transform#s_srs=3857&t_srs=4326&x=4492308.0&y=7896475.0

  VErrNo := 0;

  VRet := projected_cs_to_geodetic_cs(
    ASrc, ADest, 4492308.0, 7896475.0, VLon, VLat, @VErrNo
  );

  CheckTrue(VRet, string(pj_strerrno(VErrNo)));

  CheckEquals(40.3550894, VLon, CEpsilon);
  CheckEquals(57.6611737, VLat, CEpsilon);
end;

procedure TestCS2CS.Test_3857_to_4326_InternalDef;
begin
  DoTest_3857_to_4326(epsg_3857, wgs_84);
end;

procedure TestCS2CS.Test_3857_to_4326_ExternalDef;
begin
  DoTest_3857_to_4326('+init=epsg:3857', '+init=epsg:4326');
end;

procedure TestCS2CS.DoTest_4326_to_3857(const ASrc, ADest: AnsiString);
const
  CEpsilon = 1E-1;
var
  VRet: Boolean;
  VErrNo: Integer;
  X, Y: Double;
begin
  // https://epsg.io/transform#s_srs=4326&t_srs=3857&x=40.3550894&y=57.6611737

  VErrNo := 0;

  VRet := geodetic_cs_to_projected_cs(
    ASrc, ADest, 40.3550894, 57.6611737, X, Y, @VErrNo
  );

  CheckTrue(VRet, string(pj_strerrno(VErrNo)));

  CheckEquals(4492308.0, X, CEpsilon);
  CheckEquals(7896475.0, Y, CEpsilon);
end;

procedure TestCS2CS.Test_4326_to_3857_InternalDef;
begin
  DoTest_4326_to_3857(wgs_84, epsg_3857);
end;

procedure TestCS2CS.Test_4326_to_3857_ExternalDef;
begin
  DoTest_4326_to_3857('+init=epsg:4326', '+init=epsg:3857');
end;

initialization
  RegisterTest(TestCS2CS.Suite);

end.
