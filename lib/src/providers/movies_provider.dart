import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies/src/models/movie_model.dart';

class MoviesProvider {
  String _apiKey = 'XXX';
  String _url = 'api.themoviedb.org';
  String _language = 'en-EN';
  String _nowPlayingPath = '3/movie/now_playing';
  String _popularPath = '3/movie/popular';

  int _popularsPage = 0;

  List<Movie> _populars = new List();

  final _popularsStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularsSink => _popularsStreamController.sink.add;

  Stream<List<Movie>> get popularsStream => _popularsStreamController.stream;

  void dispose() {
    _popularsStreamController?.close();
  }

  Future<List<Movie>> _processResp(Uri url) async {
    final resp = await http.get(url);

    final decodedData = json.decode(resp.body);

    final movies = Movies.fromJsonList(decodedData['results']);

    return movies.items;
  }

  Future<List<Movie>> getNowPlaying() async {
    final url = Uri.https(_url, _nowPlayingPath, {
      'api_key': _apiKey,
      'language': _language,
    });

    return await _processResp(url);
  }

  Future<List<Movie>> getPopular() async {
    _popularsPage++;
    final url = Uri.https(_url, _popularPath, {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularsPage.toString()
    });

    final resp = await _processResp(url);

    // Adding Streams
    _populars.addAll(resp);
    popularsSink(_populars);

    return resp;
  }
}
