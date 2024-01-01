import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:movies_db/entities/entities.dart';
import 'package:movies_db/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/movies_service.dart';
import '../widgets/poster_scrollview.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen(
      {required this.movie, required this.service, super.key});

  final Movie movie;
  final MoviesServices service;

  static Route<dynamic> route(Movie movieInd, MoviesServices services) {
    return CupertinoPageRoute(
      builder: (context) =>
          MovieDetailScreen(movie: movieInd, service: services),
    );
  }

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<List<WatchProvider>> fetchWatchProviders;
  late Future<List<CastMember>> fetchCast;
  late Future<String> fetchTrailer;
  final ScrollController _controller = ScrollController();
  bool isAppBarTransparent = true;

  bool isExpanded = false;

  @override
  initState() {
    fetchWatchProviders =
        widget.service.fetchWatchProviders(widget.movie, context);
    fetchTrailer = widget.service.fetchTrailer(widget.movie.id);
    fetchCast = widget.service.fetchCast(widget.movie.id);
    super.initState();
  }

  List<Genre> getGenres(Movie movie) {
    return movie.genreIds
        .map((e) =>
            widget.service.genres.firstWhere((element) => element.id == e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 55),
          child: ClipRRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: AppBar(
                    // title: Text(
                    //   widget.title,
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //       color: Colors.white,
                    //       fontWeight: FontWeight.w700,
                    //       fontSize: 16),
                    // ),
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    backgroundColor: Colors.transparent,
                  ))),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Stack(alignment: AlignmentDirectional.bottomCenter, children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 400),
                child: Opacity(
                  opacity: 0.5,
                  child: FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      placeholder: "assets/black_screen.jpg",
                      placeholderFit: BoxFit.cover,
                      placeholderScale: 1,
                      placeholderCacheHeight: 400,
                      image: widget.service
                          .getBackdropPath(widget.movie.backdropPath)),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(1),
                      // Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 180,
                      margin: const EdgeInsets.only(right: 20),
                      color: const Color.fromARGB(135, 158, 158, 158),
                      child: Image.network(
                        widget.service
                            .getImagePath(widget.movie.posterPath ?? ""),
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: Center(
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.grey[600],
                              size: 80,
                            ),
                          ),
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[600],
                          );
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            Container(
              alignment: AlignmentDirectional.centerStart,
              margin: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 30),
                    child: Text(
                      widget.movie.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "(${widget.movie.releaseDate.year})",
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          widget.movie.voteAverage.floorToDouble().toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.yellow,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            widget.movie.overview ?? "",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                        spacing: 10,
                        runSpacing: 0,
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        children: [
                          ...getGenres(widget.movie).map((e) => Chip(
                              visualDensity: VisualDensity.compact,
                              labelPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 7),
                              backgroundColor: Colors.black.withOpacity(0.85),
                              label: Text(
                                e.name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontStyle: FontStyle.normal),
                              )))
                        ]),
                  ),
                  Row(
                    children: [
                      FutureBuilder(
                          future: fetchTrailer,
                          builder: (context, snapshot) {
                            return InkWell(
                              onTap: () {
                                //lanzar app de youtube
                                launchUrl(Uri.parse(snapshot.data!),
                                    mode: LaunchMode
                                        .externalNonBrowserApplication);
                              },
                              child:
                                  snapshot.hasData && snapshot.data!.isNotEmpty
                                      ? Container(
                                          margin: const EdgeInsets.only(
                                              top: 15, right: 15),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.video_library_rounded,
                                                  color: Colors.white,
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 5),
                                                  child: const Text(
                                                    "Ver trailer",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )
                                              ]),
                                        )
                                      : const SizedBox(
                                          height: 10,
                                        ),
                            );
                          }),
                      InkWell(
                        onTap: () => showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              decoration: const BoxDecoration(
                                color: Colors.black,
                              ),
                              padding: const EdgeInsets.only(
                                  top: 20, right: 10, left: 10),
                              height: 400,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Reparto',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700)),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Expanded(
                                    child: CastDetailScreen(
                                        movieId: widget.movie.id),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.people_rounded,
                                color: Colors.white,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                child: const Text(
                                  "Ver Reparto",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ]),
                      )
                      // FutureBuilder(
                      //     future: fetchCast,
                      //     builder: (context, AsyncSnapshot snapshot) {
                      //       return Container(
                      //           margin: const EdgeInsets.only(top: 15),
                      //           child: snapshot.hasData
                      //               ? InkWell(
                      //                   onTap: () => Navigator.push(
                      //                       context,
                      //                       CastListView.route(
                      //                           snapshot.data, "")),
                      //                   child: Row(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.start,
                      //                       children: [
                      //                         const Icon(
                      //                           Icons.people_rounded,
                      //                           color: Colors.white,
                      //                         ),
                      //                         Container(
                      //                           margin: const EdgeInsets.only(
                      //                               left: 5),
                      //                           child: const Text(
                      //                             "Ver Reparto",
                      //                             style: TextStyle(
                      //                                 color: Colors.white,
                      //                                 fontSize: 14,
                      //                                 fontWeight:
                      //                                     FontWeight.w500),
                      //                           ),
                      //                         )
                      //                       ]),
                      //                 )
                      //               : const SizedBox(
                      //                   width: 5,
                      //                 ));
                      //     })
                    ],
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: fetchWatchProviders,
              builder: (context, snapshot) {
                return snapshot.hasData && snapshot.data!.isNotEmpty
                    ? Container(
                        height: 80,
                        margin: const EdgeInsets.only(left: 15),
                        child: Row(children: [
                          Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: const Text(
                              "Míralo por:",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              children: [
                                ...snapshot.data!
                                    .map((e) => Container(
                                          width: 50,
                                          margin:
                                              const EdgeInsets.only(left: 15),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                fit: BoxFit.fitWidth,
                                                image: NetworkImage(widget
                                                    .service
                                                    .getLogoPath(e.logoPath)),
                                              )),
                                        ))
                                    .toList()
                              ],
                            ),
                          )
                        ]),
                      )
                    : const SizedBox(
                        height: 3,
                      );
              },
            ),
            FutureBuilder(
              future: widget.service.fetchSimilarMovies(widget.movie.id),
              builder: (context, snapshot) => Container(
                child: snapshot.hasData
                    ? snapshot.data!.isNotEmpty
                        ? PosterScrollView(
                            data: snapshot.data!,
                            title: "Tambien te puede gustar")
                        : const SizedBox(
                            height: 40,
                          )
                    : const SizedBox(
                        height: 100,
                      ),
              ),
            )
          ]),
        ));
  }
}
