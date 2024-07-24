import 'dart:convert';
import 'dart:async';
import 'package:ais_visualizer/models/knn_vessel_model.dart';
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
  http.Client _clientVesselStream = http.Client();
  StreamSubscription<VesselFull>? _activeStreamSubscription;
  StreamController<VesselFull> _streamController =
      StreamController<VesselFull>.broadcast();

  Future<void> cancelActiveStreamSubscription() async {
    if (_activeStreamSubscription != null) {
      await _activeStreamSubscription!.cancel();
      _activeStreamSubscription = null;
    }
    _clientVesselStream.close();
  }

  Future<void> initializeStreamController() async {
    _clientVesselStream = http.Client();
    if (_streamController.hasListener) {
      await _streamController.close();
      _streamController = StreamController<VesselFull>.broadcast();
    }
  }

  Future<List<VesselSampled>> fetchInitialData() async {
    final token = await AuthService.getToken();
    final url =
        Uri.parse('https://live.ais.barentswatch.no/v1/latest/combined');
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
    final url =
        Uri.parse('https://live.ais.barentswatch.no/live/v1/sse/combined');
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

    await for (var event
        in stream.transform(utf8.decoder).transform(const LineSplitter())) {
      if (event.startsWith('data: ')) {
        String jsonData = event.substring(6);
        Map<String, dynamic> jsonMap = jsonDecode(jsonData);
        yield VesselSampled.fromJson(jsonMap);
      }
    }
  }

  Future<VesselFull?> fetchVesselData(int mmsi) async {
    await cancelActiveStreamSubscription();
    final token = await AuthService.getToken();
    final url =
        Uri.parse('https://live.ais.barentswatch.no/v1/latest/combined');
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
    await cancelActiveStreamSubscription();
    final token = await AuthService.getToken();
    final url =
        Uri.parse('https://live.ais.barentswatch.no/live/v1/sse/combined');
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
    print('Streaming vessel data for MMSI: $mmsi');
    await initializeStreamController();

    final request = http.Request('POST', url)
      ..headers.addAll(headers)
      ..body = body;

    final response = await _clientVesselStream.send(request);
    final stream = response.stream;

    _activeStreamSubscription = stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .where((event) => event.startsWith('data: '))
        .map((event) => event.substring(6))
        .map((jsonData) => jsonDecode(jsonData))
        .map((jsonMap) => VesselFull.fromJson(jsonMap))
        .listen((sample) {
      print('Emitting sample: $sample');
      // Emit the sample to the stream
      _streamController.add(sample);
    }, onError: (error) {
      print('Error occurred in streamVesselData: $error');
    }, cancelOnError: true);

    // Yield data from the stream controller
    yield* _streamController.stream;
  }

  Future<List<VesselSampled>> fetchHistoricTrackData(
      int mmsi, String startTime, String endTime) async {
    try {
      final token = await AuthService.getToken();
      final baseUrl =
          'https://historic.ais.barentswatch.no/open/v1/historic/tracks';
      final modelFormat = 'json';

      final url = Uri.parse(
          '$baseUrl/$mmsi/$startTime/$endTime?modelFormat=$modelFormat');

      final headers = {
        'Authorization': 'Bearer $token',
        'accept': 'application/json',
      };

      final response = await _client.get(url, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((item) => VesselSampled.fromJson(item)).toList();
      } else {
        throw Exception(
            'Failed to fetch historic track data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching historic track data: $e');
      rethrow;
    }
  }

  // General Speed Ranges:
  // Small Boats: 1-10 knots
  // Fishing Boats: 1-15 knots
  // Cargo Ships: 10-20 knots
  // Passenger Ferries: 15-30 knots
  // 1 knot minimum area to avoid stationary vessels

  Future<List<KnnVesselModel>> fetchAisPositionsInArea({
    required String bbox,
    required String start,
    required String end,
    required double minSpeed,
  }) async {
    final url =
        'https://kystdatahuset.no/ws/api/ais/positions/within-bbox-time';

    final payload = jsonEncode({
      'bbox': bbox,
      'start': start,
      'end': end,
      'minSpeed': minSpeed,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'accept': 'text/plain',
          'Content-Type': 'application/json',
        },
        body: payload,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          final List<dynamic> rawData = responseData['data'];

          List<KnnVesselModel> aisDataList =
              rawData.map((item) => KnnVesselModel.fromList(item)).toList();

          return aisDataList;
        } else {
          print('API call was not successful: ${responseData['msg']}');
          return [];
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
