import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:movies_db/screens/movie_detail.dart';

import '../services/movies_service.dart';

class Highlight extends StatefulWidget {
  const Highlight({
    Key? key,
    required this.service,
  }) : super(key: key);

  final MoviesServices service;

  @override
  State<Highlight> createState() => _HighlightState();
}

class _HighlightState extends State<Highlight> {
  late Future fetchHighlights;
  final hightlightData = StreamController();
  late Timer updateStream;

  Future<void> fetchData() async {
    await widget.service.fetchHighlight();
    if (widget.service.highligth.isNotEmpty) {
      hightlightData.add(widget.service
          .highligth[Random().nextInt(widget.service.highligth.length)]);
    }
  }

  @override
  void initState() {
    fetchData();

    // updateStream = Timer.periodic(const Duration(seconds: 15), (timer) {
    //   if (widget.service.highligth.isNotEmpty) {
    //     hightlightData.add(widget.service
    //         .highligth[Random().nextInt(widget.service.highligth.length)]);
    //   }
    // });

    super.initState();
  }

  @override
  void dispose() {
    hightlightData.close();
    // updateStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: hightlightData.stream,
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Container(
                  height: 450,
                )
              : GestureDetector(
                  onTap: () => Navigator.push(context,
                      MovieDetailScreen.route(snapshot.data, widget.service)),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Opacity(
                        opacity: 0.7,
                        child: FadeInImage.assetNetwork(
                            height: 450,
                            fit: BoxFit.cover,
                            placeholder: "assets/black_screen.jpg",
                            placeholderFit: BoxFit.cover,
                            placeholderScale: 1,
                            placeholderCacheHeight: 450,
                            image: widget.service
                                .getBackdropPath(snapshot.data.backdropPath)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(1),
                              Colors.black.withOpacity(0.9),
                              Colors.black.withOpacity(0.8),
                              Colors.transparent
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, bottom: 3),
                                        child: const Text(
                                          "Descubre",
                                          style: TextStyle(
                                              color: Colors.tealAccent,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        margin: const EdgeInsets.only(
                                            left: 10, bottom: 5),
                                        child: Text(
                                          snapshot.data.title,
                                          softWrap: true,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      Chip(
                                          labelStyle: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.white),
                                          backgroundColor: Colors.transparent
                                              .withOpacity(0.5),
                                          avatar: const Icon(
                                            Icons.play_arrow,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          visualDensity:
                                              VisualDensity.comfortable,
                                          label: const Text("Ver más"))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        });
  }
}
