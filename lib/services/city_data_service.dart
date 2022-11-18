import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/city.dart';

class CityDaraService {

  static const  _url = "https://city-by-api-ninjas.p.rapidapi.com/v1/city?name=";
  static const _headers = {
    "X-RapidAPI-Key": "412e5f2877mshab2b21abeba2ab9p1bd299jsn4c8e79e2db2d",
    "X-RapidAPI-Host": "city-by-api-ninjas.p.rapidapi.com"
  };

  static Future<City> fetchCityData(String cityName) async {
    final response = await http
        .get(Uri.parse(_url + cityName),
        headers: _headers);

    if (response.statusCode == 200) {
      return City.fromJson(List<Map<String, dynamic>>.from(jsonDecode(response.body)));
    } else {
      throw Exception('Failed to load city data: ${response.reasonPhrase}');
    }
  }
}