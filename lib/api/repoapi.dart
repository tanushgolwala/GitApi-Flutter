import 'dart:convert';
import 'package:http/http.dart' as http;

//This is the ideal way of doing stuff, where we have a separate file for the API calls
//However for simplicity these functions have been added to the initial file itself

Future<List<String>> fetchRepositories(String owner) async {
  final response =
      await http.get(Uri.parse('https://api.github.com/users/$owner/repos'));
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return List<String>.from(data.map((repo) => repo['name']));
  } else {
    throw Exception('Failed to fetch repositories');
  }
}
