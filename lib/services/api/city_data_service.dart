import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/city.dart';

class CityDataService {

  // static const  _url = "https://city-by-api-ninjas.p.rapidapi.com/v1/city?name=";
  static const  _urlBase = "https://city-by-api-ninjas.p.rapidapi.com/v1/city?";

  static const _urlName = "name=";
  static const _urlCountry = "country=";
  static const _urlMinPopulation = "min_population=";
  static const _urlMaxPopulation = "max_population=";
  static const _urlMinLat = "min_lat=";
  static const _urlMaxLat = "max_lat=";
  static const _urlMinLon = "min_lon=";
  static const _urlMaxLon = "max_lon=";
  static const _urlLimit = "limit=";

  static const _headers = {
    "X-RapidAPI-Key": "412e5f2877mshab2b21abeba2ab9p1bd299jsn4c8e79e2db2d",
    "X-RapidAPI-Host": "city-by-api-ninjas.p.rapidapi.com"
  };

  static Future<List<City>> fetchCities({String name = "", String country = "", int minPopulation = 0, int maxPopulation = 0, double minLat = 0, double maxLat = 0, double minLon = 0, double maxLon = 0, int limit = 0}) async {
    String url = _urlBase;
    bool _first = true;

    if (name == "" && country == "" && minPopulation == 0 && maxPopulation == 0 && minLat == 0 && maxLat == 0 && minLon == 0 && maxLon == 0 && limit == 0) {
      return [];
    }

    if (name != "") {
      url += _urlName + name;
      _first = false;
    }
    if (country != "") {
      if (!_first) {
        url += "&";
      }
      url += _urlCountry + country;
      _first = false;
    }
    if (minPopulation != 0) {
      if (!_first) {
        url += "&";
      }
      url += _urlMinPopulation + minPopulation.toString();
      _first = false;
    }
    if (maxPopulation != 0) {
      if (!_first) {
        url += "&";
      }
      url += _urlMaxPopulation + maxPopulation.toString();
      _first = false;
    }
    if (minLat != 0) {
      if (!_first) {
        url += "&";
      }
      url += _urlMinLat + minLat.toString();
      _first = false;
    }
    if (maxLat != 0) {
      if (!_first) {
        url += "&";
      }
      url += _urlMaxLat + maxLat.toString();
      _first = false;
    }
    if (minLon != 0) {
      if (!_first) {
        url += "&";
      }
      url += _urlMinLon + minLon.toString();
      _first = false;
    }
    if (maxLon != 0) {
      if (!_first) {
        url += "&";
      }
      url += _urlMaxLon + maxLon.toString();
      _first = false;
    }
    if (limit != 0) {
      if (!_first) {
        url += "&";
      }
      url += _urlLimit + limit.toString();
      _first = false;
    }

    final response = await http.get(Uri.parse(url), headers: _headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((city) {
        return City.fromJson(city);
      }).toList();
    } else {
      throw Exception('Failed to load city');
    }
  }
}