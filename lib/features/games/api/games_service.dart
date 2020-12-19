import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sports_picker/features/games/api/games_response.dart';

/// TODO add service error scenario
class GamesService {
  Future<GamesResponse> fetchData() async {
    /// This is mocking a service call where the games would be stored.
    var response = await rootBundle.loadStructuredData(
        'lib/features/games/api/games_mocked_data.json', (String s) async {
      return json.decode(s);
    });
    GamesResponse _gamesResponse = GamesResponse.fromJson(response);
    return _gamesResponse;
  }
}
