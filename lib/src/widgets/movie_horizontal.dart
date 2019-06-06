import 'package:flutter/material.dart';
import 'package:movies/src/models/movie_model.dart';

class HorizontalMovie extends StatelessWidget {
  final List<Movie> movies;
  final Function nextPage;

  HorizontalMovie({@required this.movies, @required this.nextPage});

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.2,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemBuilder: (context, i) {
          return _card(context, movies[i]);
        },
        itemCount: movies.length,
        // children: _cards(context),
      ),
    );
  }

  Widget _card(BuildContext context, Movie movie) {
    movie.uniqueId = '${movie.id}-poster';
    final card = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(movie.getPosterImage()),
                placeholder: AssetImage('assets/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
            tag: movie.uniqueId,
          ),
          SizedBox(
            height: 5.0,
          ),
          Center(
            child: Text(
              movie.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      child: card,
      onTap: () {
        Navigator.pushNamed(context, 'detail', arguments: movie);
      },
    );
  }

//   List<Widget> _cards(BuildContext context) {
//     return movies.map((movie) {
//       return Container(
//         margin: EdgeInsets.only(right: 15.0),
//         child: Column(
//           children: <Widget>[
//             ClipRRect(
//               borderRadius: BorderRadius.circular(20.0),
//               child: FadeInImage(
//                 image: NetworkImage(movie.getPosterImage()),
//                 placeholder: AssetImage('assets/no-image.jpg'),
//                 fit: BoxFit.cover,
//                 height: 160.0,
//               ),
//             ),
//             SizedBox(
//               height: 5.0,
//             ),
//             Center(
//               child: Text(
//                 movie.title,
//                 overflow: TextOverflow.ellipsis,
//                 style: Theme.of(context).textTheme.caption,
//               ),
//             ),
//           ],
//         ),
//       );
//     }).toList();
//   }
}
