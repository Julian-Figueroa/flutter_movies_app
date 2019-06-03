import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies/src/models/movie_model.dart';

class MoviesProvider {
  String _apiKey = '6212acb45aadbcfd8ab4316e030d78f7';
  String _url = 'api.themoviedb.org';
  String _language = 'en-EN';
  String _unencodedPath = '3/movie/now_playing';

  Future<List<Movie>> getNowPlaying() async {
    final url = Uri.https(_url, _unencodedPath, {
      'api_key': _apiKey,
      'language': _language,
    });

    final resp = await http.get(url);

    final decodedData = json.decode(resp.body);

    final movies = Movies.fromJsonList(decodedData['results']);

    return movies.items;
  }
}
