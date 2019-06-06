import 'package:flutter/material.dart';
import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/providers/movies_provider.dart';

class DataSearch extends SearchDelegate {
  final moviesProvider = new MoviesProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    // implement buildActions Re draw of the Widget
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // implement buildLeading Icon
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // implement buildResults Results
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // implement buildSuggestions Suggestions
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: moviesProvider.searchMovie(query),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          final movies = snapshot.data;

          return ListView(
            children: movies.map((movie) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(movie.getPosterImage()),
                  placeholder: AssetImage('assets/no-image.jpg'),
                  fit: BoxFit.contain,
                  width: 50.0,
                ),
                title: Text(movie.title),
                subtitle: Text(movie.originalTitle),
                onTap: () {
                  close(context, null);
                  movie.uniqueId = '';
                  Navigator.pushNamed(context, 'detail', arguments: movie);
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
