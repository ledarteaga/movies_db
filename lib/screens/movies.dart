import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/movies_service.dart';
import '../widgets/poster_scrollview.dart';
import '../widgets/highlight.dart';

class MoviesListScreen extends StatefulWidget {
  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  @override
  Widget build(BuildContext context) {
    final service = Provider.of<MoviesServices>(context);
    final List<Map<String, dynamic>> items = [
      {"name": "En Cartelera", "value": service.nowPlaying},
      {"name": "Aclamadas por la critica", "value": service.topRated},
      {"name": "Mas Populares", "value": service.popular},
      {"name": "Proximos Estrenos", "value": service.upcoming},
    ];

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 55),
          child: ClipRRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: AppBar(
                    title: const Text(
                      'Peliculas',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(Icons.movie),
                      onPressed: () {},
                    ),
                    backgroundColor: Colors.transparent,
                  ))),
        ),
        body: SingleChildScrollView(
          // physics: const BouncingScrollPhysics(),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Highlight(service: service),
            ...items.map(
                (e) => PosterScrollView(data: e["value"], title: e["name"]))
          ]),
        ));
  }
}
