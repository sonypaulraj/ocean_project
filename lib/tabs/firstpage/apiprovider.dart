
import 'dart:io';

import 'apimodel.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static Future<http.Response> getModelList() async {
    http.Response response;
    var url = Uri.parse("https://api.publicapis.org/entries");
    try {
      response = await http.get(url);
    } catch (e) {
      rethrow;
    }
    return response;
  }
}
class ModelRepo {
  static Future<List<Entry>?> getModelList() async {
    try {
      var response = await HttpService.getModelList();
      if (response.statusCode == 200) {
        var result = modelListFromJson(response.body);
        return result.entries;
      } else {
        return null;
      }
    } on SocketException {
      rethrow;
    } on HttpException {
      rethrow;
    } on FormatException {
      rethrow;
    }
  }
}

