import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_db/screens/movie_detail.dart';
import 'package:provider/provider.dart';
import '../../services/movies_service.dart';
import 'package:movies_db/entities/movie.dart';

class PosterMovieGridView extends StatefulWidget {
  const PosterMovieGridView({
    Key? key,
    required this.data,
    required this.title,
  }) : super(key: key);

  static Route<dynamic> route(List<Movie> data, String title) {
    return CupertinoPageRoute(
      builder: (context) => PosterMovieGridView(data: data, title: title),
    );
  }

  final List<Movie> data;
  final String title;

  @override
  State<PosterMovieGridView> createState() => _PosterMovieGridViewState();
}

class _PosterMovieGridViewState extends State<PosterMovieGridView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<MoviesServices>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 55),
        child: ClipRRect(
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AppBar(
                  title: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  backgroundColor: Colors.transparent,
                ))),
      ),
      backgroundColor: Colors.black,
      body: GridView.builder(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 110),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisExtent: 220,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30),
          itemCount: widget.data.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () => Navigator.push(
                  context, MovieDetailScreen.route(widget.data[i], service)),
              child: Container(
                width: 150,
                child: FadeInImage.assetNetwork(
                    fadeInDuration: const Duration(milliseconds: 300),
                    fit: BoxFit.cover,
                    placeholder: "assets/black_screen.jpg",
                    placeholderFit: BoxFit.fitHeight,
                    placeholderScale: 1,
                    placeholderCacheHeight: 150,
                    image:
                        service.getImagePath(widget.data[i].posterPath ?? "")),
              ),
            );
          }),
    );
  }
}
