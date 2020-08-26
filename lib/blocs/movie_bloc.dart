import 'dart:async';

import 'package:flutter_movie/api/api_response.dart';
import 'package:flutter_movie/models/movie_response.dart';
import 'package:flutter_movie/repository/movie_list_repository.dart';

class MovieBloc {
  MovieListRepository _MovieListRepository;
  StreamController _movieListController;
  StreamSink<ApiResponse<List<Movie>>> get movieListSink =>
      _movieListController.sink;
  Stream<ApiResponse<List<Movie>>> get movieListStream =>
      _movieListController.stream;
  MovieBloc() {
    _movieListController = StreamController<ApiResponse<List<Movie>>>();
    _MovieListRepository = MovieListRepository();
    fetchMovies();
  }

  // Fetch
  fetchMovies() async {
    movieListSink.add(ApiResponse.loading(''));
    try {
      List<Movie> movies = await _MovieListRepository.fetchMovies();
      movieListSink.add(ApiResponse.completed(movies));
    } catch (error) {
      movieListSink.add(ApiResponse.error(error.toString()));
      print(error);
    }
  }

  dispose() {
    _movieListController?.close();
  }
}
