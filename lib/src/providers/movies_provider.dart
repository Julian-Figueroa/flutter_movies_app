import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies/src/models/actor_model.dart';
import 'package:movies/src/models/movie_model.dart';

class MoviesProvider {
  String _apiKey = 'XXX';
  String _url = 'api.themoviedb.org';
  String _language = 'en-EN';
  String _nowPlayingPath = '3/movie/now_playing';
  String _popularPath = '3/movie/popular';
  String _queryPath = '3/search/movie';

  int _popularsPage = 0;

  bool _loading = false;

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
    if (_loading) return [];

    _loading = true;

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

    _loading = false;

    return resp;
  }

  Future<List<Actor>> getCast(String movieId) async {
    final url = Uri.https(_url, '3/movie/$movieId/credits', {
      'api_key': _apiKey,
      'language': _language,
    });

    final resp = await http.get(url);

    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actors;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_url, _queryPath, {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
    });

    return await _processResp(url);
  }
}
