import 'dart:convert';
import 'dart:async';
import 'package:ais_visualizer/models/vessel_sampled_model.dart';
import 'package:ais_visualizer/models/vessel_full_model.dart';
import 'package:ais_visualizer/services/auth_service.dart';
import 'package:http/http.dart' as http;

class AisDataService {
  AisDataService._internal();
  static final AisDataService _singleton = AisDataService._internal();

  factory AisDataService() {
    return _singleton;
  }

  final http.Client _client = http.Client();

  Future<List<VesselSampled>> fetchInitialData() async {
    final token = await AuthService.getToken();
    final url = Uri.parse('https://live.ais.barentswatch.no/v1/latest/combined');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await _client.get(url, headers: headers);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((item) => VesselSampled.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load initial data');
    }
  }

  Stream<VesselSampled> streamVesselsData() async* {
    final token = await AuthService.getToken();
    final url = Uri.parse('https://live.ais.barentswatch.no/live/v1/sse/combined');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'accept': 'text/event-stream',
    };
    final body = jsonEncode({"downsample": true});

    final request = http.Request('POST', url)
      ..headers.addAll(headers)
      ..body = body;

    final response = await _client.send(request);
    final stream = response.stream;

    await for (var event in stream.transform(utf8.decoder).transform(const LineSplitter())) {
      if (event.startsWith('data: ')) {
        String jsonData = event.substring(6);
        Map<String, dynamic> jsonMap = jsonDecode(jsonData);
        yield VesselSampled.fromJson(jsonMap);
      }
    }
  }

  Future<VesselFull?> fetchVesselData(int mmsi) async {
    final token = await AuthService.getToken();
    final url = Uri.parse('https://live.ais.barentswatch.no/v1/latest/combined');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      "mmsi": [mmsi],
      "modelType": "Full",
      "downsample": true
    });

    final response = await _client.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      if (jsonList.isNotEmpty) {
        return VesselFull.fromJson(jsonList[0]);
      }
    } else {
      throw Exception('Failed to load vessel data');
    }
    return null;
  }

  Stream<VesselFull> streamVesselData(int mmsi) async* {
    final token = await AuthService.getToken();
    final url = Uri.parse('https://live.ais.barentswatch.no/live/v1/sse/combined');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'accept': 'text/event-stream'
    };
    final body = jsonEncode({
      "mmsi": [mmsi],
      "downsample": true,
      "modelType": "Full"
    });

    final request = http.Request('POST', url)
      ..headers.addAll(headers)
      ..body = body;

    final response = await _client.send(request);
    final stream = response.stream;

    await for (var event in stream.transform(utf8.decoder).transform(const LineSplitter())) {
      if (event.startsWith('data: ')) {
        String jsonData = event.substring(6);
        Map<String, dynamic> jsonMap = jsonDecode(jsonData);
        yield VesselFull.fromJson(jsonMap);
      }
    }
  }
}
