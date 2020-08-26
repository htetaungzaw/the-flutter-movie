import 'package:flutter_movie/api/Api.dart';
import 'package:flutter_movie/api/api_key.dart';
import 'package:flutter_movie/models/movie_response.dart';

class MovieListRepository {
  final String _apiKey = apiKey;
  Api _helper = Api();
  Future<List<Movie>> fetchMovies() async {
    final response = await _helper.get("movie/popular?api_key=$_apiKey");
    return MovieResponse.fromJson(response).results;
  }
}
