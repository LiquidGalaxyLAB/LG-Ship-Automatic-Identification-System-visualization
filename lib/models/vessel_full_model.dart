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
      mmsi: json['mmsi'],
      msgtime: DateTime.parse(json['msgtime']),
      courseOverGround: json['courseOverGround']?.toDouble(),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      navigationalStatus: json['navigationalStatus'],
      rateOfTurn: json['rateOfTurn']?.toDouble(),
      speedOverGround: json['speedOverGround']?.toDouble(),
      trueHeading: json['trueHeading'],
      imoNumber: json['imoNumber'],
      callSign: json['callSign'],
      name: json['name'],
      destination: json['destination'],
      eta: json['eta'],
      draught: json['draught']?.toDouble(),
      shipLength: json['shipLength']?.toDouble(),
      shipWidth: json['shipWidth']?.toDouble(),
      shipType: json['shipType'],
      dimensionA: json['dimensionA']?.toDouble(),
      dimensionB: json['dimensionB']?.toDouble(),
      dimensionC: json['dimensionC']?.toDouble(),
      dimensionD: json['dimensionD']?.toDouble(),
      positionFixingDeviceType: json['positionFixingDeviceType'],
      reportClass: json['reportClass'],
      msgtimeStatic: json['msgtimeStatic'] != null
          ? DateTime.parse(json['msgtimeStatic'])
          : null,
    );
  }
}