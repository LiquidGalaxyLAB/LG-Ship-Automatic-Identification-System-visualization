class VesselFull {
  int mmsi;
  DateTime msgtime;
  double? courseOverGround;
  double? latitude;
  double? longitude;
  int? navigationalStatus;
  double? rateOfTurn;
  double? speedOverGround;
  int? trueHeading;
  int? imoNumber;
  String? callSign;
  String? name;
  String? destination;
  String? eta;
  double? draught;
  double? shipLength;
  double? shipWidth;
  int? shipType;
  double? dimensionA;
  double? dimensionB;
  double? dimensionC;
  double? dimensionD;
  int? positionFixingDeviceType;
  String? reportClass;
  DateTime? msgtimeStatic;

  VesselFull({
    required this.mmsi,
    required this.msgtime,
    this.courseOverGround,
    this.latitude,
    this.longitude,
    this.navigationalStatus,
    this.rateOfTurn,
    this.speedOverGround,
    this.trueHeading,
    this.imoNumber,
    this.callSign,
    this.name,
    this.destination,
    this.eta,
    this.draught,
    this.shipLength,
    this.shipWidth,
    this.shipType,
    this.dimensionA,
    this.dimensionB,
    this.dimensionC,
    this.dimensionD,
    this.positionFixingDeviceType,
    this.reportClass,
    this.msgtimeStatic,
  });

  factory VesselFull.fromJson(Map<String, dynamic> json) {
    return VesselFull(
      mmsi: json['mmsi'] ?? 0,
      msgtime: DateTime.parse(json['msgtime'] ?? DateTime.now().toIso8601String()),
      courseOverGround: json['courseOverGround']?.toDouble() ?? 0.0,
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      navigationalStatus: json['navigationalStatus'] ?? 0,
      rateOfTurn: json['rateOfTurn']?.toDouble() ?? 0.0,
      speedOverGround: json['speedOverGround']?.toDouble() ?? 0.0,
      trueHeading: json['trueHeading'] ?? 0,
      imoNumber: json['imoNumber'] ?? 0,
      callSign: json['callSign'] ?? '',
      name: json['name'] ?? '',
      destination: json['destination'] ?? '',
      eta: json['eta'] ?? '',
      draught: json['draught']?.toDouble() ?? 0.0,
      shipLength: json['shipLength']?.toDouble() ?? 0.0,
      shipWidth: json['shipWidth']?.toDouble() ?? 0.0,
      shipType: json['shipType'] ?? 0,
      dimensionA: json['dimensionA']?.toDouble() ?? 0.0,
      dimensionB: json['dimensionB']?.toDouble() ?? 0.0,
      dimensionC: json['dimensionC']?.toDouble() ?? 0.0,
      dimensionD: json['dimensionD']?.toDouble() ?? 0.0,
      positionFixingDeviceType: json['positionFixingDeviceType'] ?? 0,
      reportClass: json['reportClass'] ?? '',
      msgtimeStatic: json['msgtimeStatic'] != null
          ? DateTime.parse(json['msgtimeStatic'])
          : null,
    );
  }
}