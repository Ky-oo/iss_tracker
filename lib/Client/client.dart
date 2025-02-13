import 'dart:convert';

import 'package:http/http.dart' as http;

class ClientTracker {
  static const baseUrl = 'http://api.open-notify.org/iss-now.json';

  Future<dynamic> fetchData() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Échec du chargement des données');
    }
  }
}
