import 'package:flutter_movie/api/Api.dart';
import 'package:flutter_movie/api/api_key.dart';
import 'package:flutter_movie/models/movie_response.dart';

class MovieDetailRepository {
  final String _apiKey = apiKey;
  Api _helper = Api();

  Future<Movie> fetchMovieDetail(int selectedMovie) async {
    final response = await _helper.get("movie/$selectedMovie?api_key=$_apiKey");
    return Movie.fromJson(response);
  }
}
