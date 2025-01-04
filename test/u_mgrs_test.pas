unit u_mgrs_test;

interface

uses
  TestFramework;

type
  TestMGRS = class(TTestCase)
  published
    procedure TestStrToMgrs;
    procedure TestMgrsToWgs84;
  end;

implementation

uses
  Proj4.API,
  Proj4.UTM;

{ TestMGRS }

procedure TestMGRS.TestMgrsToWgs84;
const
  CEpsilon = 1E-6;
var
  VMgrs: TMgrsCoord;
  VLon, VLat: Double;
begin
  // https://coordinates-converter.com/en/decimal/49.717372,9.195557?karte=OpenStreetMap&zoom=5

  // MGRS    : 32U NA 14097 07226
  // UTM     : 32N 514097 5507226
  // LatLong : 49.717372 9.195557

  CheckTrue(str_to_mgrs('32U NA 14097 07226', VMgrs));
  CheckTrue(mgrs_to_wgs84(VMgrs, VLon, VLat));

  CheckEquals(9.195557, VLon, CEpsilon);
  CheckEquals(49.717372, VLat, CEpsilon);

  // https://www.earthpoint.us/convert.aspx

  // MGRS    : A ZG 06193 43555
  // UPS     : A 1906193mE 1443555mN
  // LatLong : -84.9205312, -170.4308976

  CheckTrue(str_to_mgrs('A ZG 06193 43555', VMgrs));
  CheckTrue(mgrs_to_wgs84(VMgrs, VLon, VLat));

  CheckEquals(-170.4308976, VLon, CEpsilon);
  CheckEquals(-84.9205312, VLat, CEpsilon);

  // MGRS    : B AN 00000 00000
  // UPS     : B 2000000mE 2000000mN
  // LatLong : -90.0000000, 0.0000000

  CheckTrue(str_to_mgrs('B AN 00000 00000', VMgrs));
  CheckTrue(mgrs_to_wgs84(VMgrs, VLon, VLat));

  CheckEquals(0.0, VLon, CEpsilon);
  CheckEquals(-90.0, VLat, CEpsilon);
end;

procedure TestMGRS.TestStrToMgrs;
const
  CTestCount = 2;

  CTestStr: array [0..CTestCount-1] of string = (
    '33U PD 90293 19927',
    'A XG 18037 63402'
  );

  CTestMgrs: array [0..CTestCount-1] of TMgrsCoord = (
    (Zone: 33; Band: 'U'; Digraph: ('P', 'D'); X: 90293; Y: 19927),
    (Zone: 00; Band: 'A'; Digraph: ('X', 'G'); X: 18037; Y: 63402)
  );

  function IsSameMgrsCoord(const A, B: TMgrsCoord): Boolean;
  begin
    Result :=
      (A.Zone = B.Zone) and (A.Band = B.Band) and
      (A.Digraph[0] = B.Digraph[0]) and (A.Digraph[1] = B.Digraph[1]) and
      (A.X = B.X) and (A.Y = B.Y);
  end;

var
  I: Integer;
  VStr: string;
  VMgrs: TMgrsCoord;
begin
  for I := 0 to Length(CTestStr) - 1 do begin
    VStr := CTestStr[I];
    CheckTrue(str_to_mgrs(VStr, VMgrs), VStr);
    CheckTrue(IsSameMgrsCoord(VMgrs, CTestMgrs[I]))
  end;
end;

initialization
  RegisterTest(TestMGRS.Suite);

end.
