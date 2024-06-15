// import 'dart:convert';
//
// import 'package:flutter/services.dart' show rootBundle;
//
// class LocationService {
//   static Future<List<dynamic>> loadJson(String path) async {
//     String jsonString = await rootBundle.loadString(path);
//     return json.decode(jsonString);
//   }
//
//   static Future<List<dynamic>> loadRegions() async {
//     return await loadJson('assets/RegionsDistricts.json');
//   }
//
//   static Future<List<dynamic>> loadDistricts() async {
//     return await loadJson('assets/DistrictsWards.json');
//   }
// }

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class LocationService {
  static Future<dynamic> loadJson(String path) async {
    String jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString);
  }

  static Future<List<dynamic>> loadRegions() async {
    List<dynamic> jsonData = await loadJson('assets/RegionsDistricts.json');
    return jsonData;
  }

  static Future<List<dynamic>> loadDistricts() async {
    Map<String, dynamic> jsonData =
        await loadJson('assets/DistrictsWards.json');
    return jsonData['features'] as List<dynamic>;
  }
}

// void main() async {
//   // Ensure that WidgetsFlutterBinding is initialized to use rootBundle
//   WidgetsFlutterBinding.ensureInitialized();
//
//   print('Loading regions...');
//   List<dynamic> regions = await LocationService.loadRegions();
//   print('Loaded regions:');
//   print(regions);
//
//   print('Loading districts...');
//   List<dynamic> districts = await LocationService.loadDistricts();
//   print('Loaded districts:');
//   print(districts);
// }
