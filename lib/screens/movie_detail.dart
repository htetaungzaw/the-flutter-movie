import 'package:flutter/material.dart';
import 'package:flutter_movie/api/api_response.dart';
import 'dart:ui' as ui;

import 'package:flutter_movie/blocs/movie_detail_bloc.dart';
import 'package:flutter_movie/commons/constants.dart';
import 'package:flutter_movie/commons/date_utils.dart';
import 'package:flutter_movie/models/movie_response.dart';
import 'package:flutter_movie/widgets/loading_indicator.dart';
import 'package:flutter_movie/widgets/error.dart';

class MovieDetail extends StatefulWidget {
  final int selectedMovie;
  const MovieDetail(this.selectedMovie);
  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  MovieDetailBloc _movieDetailBloc;
  @override
  void initState() {
    super.initState();
    _movieDetailBloc = MovieDetailBloc(widget.selectedMovie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text(
          'The Flutter Movie',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            _movieDetailBloc.fetchMovieDetail(widget.selectedMovie),
        child: StreamBuilder<ApiResponse<Movie>>(
          stream: _movieDetailBloc.movieDetailStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return LoadingIndicator();
                  break;
                case Status.COMPLETED:
                  return ShowMovieDetail(displayMovie: snapshot.data.data);
                  break;
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () =>
                        _movieDetailBloc.fetchMovieDetail(widget.selectedMovie),
                  );
                  break;
              }
            }
            return Container();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _movieDetailBloc.dispose();
    super.dispose();
  }
}

class ShowMovieDetail extends StatelessWidget {
  final Movie displayMovie;
  ShowMovieDetail({Key key, this.displayMovie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        new Image.network(
          imagePrefix + '/${displayMovie.posterPath}',
          fit: BoxFit.cover,
        ),
        new BackdropFilter(
          filter: new ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: new Container(
            color: Colors.black.withOpacity(0.6),
          ),
        ),
        new SingleChildScrollView(
          child: new Container(
            margin: const EdgeInsets.all(20.0),
            child: new Column(
              children: <Widget>[
                new Container(
                  alignment: Alignment.center,
                  child: new Container(
                    width: 400.0,
                    height: 400.0,
                  ),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10.0),
                    image: new DecorationImage(
                        image: new NetworkImage(
                            imagePrefix + '/${displayMovie.posterPath}'),
                        fit: BoxFit.cover),
                    boxShadow: [
                      new BoxShadow(
                          blurRadius: 20.0, offset: new Offset(0.0, 10.0))
                    ],
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 0.0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                          child: new Text(
                        displayMovie.title,
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                        ),
                      )),
                      new Text(
                        displayMovie.voteAverage.toStringAsFixed(1),
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end, //change here don't //worked
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 16,
                      ),
                      new Padding(
                          padding: const EdgeInsets.only(
                              left: 2, right: 2, bottom: 10)),
                      Text(
                        'Release Date: ' +
                            DateUtils.formatDate(
                                displayMovie.releaseDate, 'dd MMMM yyyy'),
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w900),
                      ),
                    ]),
                new Padding(padding: const EdgeInsets.only(bottom: 15)),
                new Text(displayMovie.overview,
                    style: new TextStyle(color: Colors.white)),
                new Padding(padding: const EdgeInsets.all(10.0)),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
