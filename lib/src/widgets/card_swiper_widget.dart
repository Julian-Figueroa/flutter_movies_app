import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CardSwiper extends StatelessWidget {
  final List<dynamic> movies;

  CardSwiper({@required this.movies});

  @override
  Widget build(BuildContext context) {
    final _screeSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screeSize.width * 0.7,
        itemHeight: _screeSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              "https://image.tmdb.org/t/p/w500/ace6QSimOwBR5fMhiDW5aLTYNZJ.jpg",
              fit: BoxFit.cover,
            ),
          );
        },
        itemCount: movies.length,
        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }
}
