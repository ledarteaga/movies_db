import 'package:flutter/material.dart';
import 'package:movies_db/screens/movie_detail.dart';
import 'package:provider/provider.dart';
import '../services/movies_service.dart';
import '../screens/screens.dart';
import 'package:movies_db/entities/movie.dart';

class PosterScrollView extends StatefulWidget {
  const PosterScrollView({
    Key? key,
    required this.data,
    required this.title,
  }) : super(key: key);

  final List<Movie> data;
  final String title;

  @override
  State<PosterScrollView> createState() => _PosterScrollViewState();
}

class _PosterScrollViewState extends State<PosterScrollView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _animation;

  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animation);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<MoviesServices>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10, top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 30, left: 10),
          height: 220,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemExtent: 160,
            scrollDirection: Axis.horizontal,
            itemCount: widget.data.length < 10 ? widget.data.length : 11,
            itemBuilder: (ctx, i) {
              if (i == 10) {
                return GestureDetector(
                  child: Container(
                    color: Colors.black,
                    margin: const EdgeInsets.only(right: 25),
                    width: 150,
                    child: Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white60.withOpacity(0.3)),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PosterMovieGridView.route(
                                      widget.data, widget.title));
                            },
                            icon: const Icon(Icons.arrow_forward_rounded),
                            color: Colors.white,
                            style: const ButtonStyle(),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Ver más",
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        )
                      ],
                    )),
                  ),
                );
              }

              return GestureDetector(
                onTap: () => Navigator.push(
                    context, MovieDetailScreen.route(widget.data[i], service)),
                child: Container(
                  margin: const EdgeInsets.only(right: 25),
                  width: 150,
                  child: FadeInImage.assetNetwork(
                      fadeInDuration: const Duration(milliseconds: 300),
                      fit: BoxFit.cover,
                      placeholder: "assets/black_screen.jpg",
                      placeholderFit: BoxFit.fitHeight,
                      placeholderScale: 1,
                      placeholderCacheHeight: 150,
                      image: service
                          .getImagePath(widget.data[i].posterPath ?? "")),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
