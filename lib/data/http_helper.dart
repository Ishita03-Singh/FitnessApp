import 'package:flutter_application_1/data/weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpHelper {
  // https://api.openweathermap.org/data/2.5/weather?q=London&appid=d50aaa04b10510bcfe5e450b400e15fc
  String authority = 'api.openweathermap.org';
  String path = 'data/2.5/weather';
  String apikey = 'd50aaa04b10510bcfe5e450b400e15fc';

  Future<Weather> getWeather(String location) async {
    Map<String, dynamic> parameters = {'q': location, 'appId': apikey};

    Uri uri = Uri.https(authority, path, parameters);
    http.Response result = await http.get(uri);
    Map<String, dynamic> data = json.decode(result.body);

    Weather weather = Weather.fromJson(data);
    return weather;
  }
}
