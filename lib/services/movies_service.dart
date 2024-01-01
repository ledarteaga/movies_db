import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:movies_db/entities/entities.dart';

class MoviesServices with ChangeNotifier {
  List<Movie> _nowPlaying = [];
  List<Movie> _popular = [];
  List<Movie> _topRated = [];
  List<Movie> _upcoming = [];
  List<Movie> _highligth = [];
  List<Genre> _genres = [];
  String language = "es";

  List<Genre> get genres => _genres;

  set genres(List<Genre> genres) {
    _genres = genres;
  }

  List<Movie> get highligth => _highligth;

  set highligth(List<Movie> highligth) {
    _highligth = highligth;
  }

  List<Movie> get upcoming => _upcoming;

  set upcoming(List<Movie> upcoming) {
    _upcoming = upcoming;
  }

  List<Movie> get topRated => _topRated;

  List<Movie> get popular => _popular;

  set popular(List<Movie> popular) {
    _popular = popular;
  }

  Map<String, dynamic> _base_config = {};

  List<Movie> get nowPlaying {
    return [..._nowPlaying];
  }

  MoviesServices() {
    fetchNowPlaying();
    fetchPopular();
    fetchTopRated();
    fetchUpcoming();
    fetchHighlight();
    fetchGenres();
  }

  String getImagePath(String str) {
    final String url = _base_config["base_url"];
    final String posterSize = _base_config["poster_sizes"][4];

    return "$url/$posterSize/$str";
  }

  String getLogoPath(String str) {
    final String url = _base_config["base_url"];
    final String posterSize = _base_config["logo_sizes"][3];

    return "$url/$posterSize/$str";
  }

  String getBackdropPath(String? str) {
    final String url = _base_config["base_url"];
    final String imgSize = _base_config["backdrop_sizes"][3];

    return "$url/$imgSize/${str ?? ""}";
  }

  String getCastMemberPath(String? str) {
    final String url = _base_config["base_url"];
    final String imgSize = _base_config["profile_sizes"][3];

    return "$url/$imgSize/${str ?? ""}";
  }

  fetchNowPlaying() async {
    List<Movie> list = [];
    final pagenum = Random().nextInt(3) + 1;
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=&page=$pagenum&language=$language');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      await fetchConfigurations();

      list = extractedData["results"]
          .map<Movie>((item) => Movie.fromJson(item))
          .toList();

      _nowPlaying = list;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  fetchTopRated() async {
    List<Movie> list = [];
    final pagenum = Random().nextInt(5) + 1;
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/top_rated?api_key=&page=$pagenum&language=$language');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      await fetchConfigurations();

      list = extractedData["results"]
          .map<Movie>((item) => Movie.fromJson(item))
          .toList();

      _topRated = list;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  fetchPopular() async {
    List<Movie> list = [];
    final pagenum = Random().nextInt(5) + 1;

    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=&$pagenum&language=$language');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      await fetchConfigurations();

      list = extractedData["results"]
          .map<Movie>((item) => Movie.fromJson(item))
          .toList();

      _popular = list;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  fetchUpcoming() async {
    final pagenum = Random().nextInt(5) + 1;

    List<Movie> list = [];
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/upcoming?api_key=&page=$pagenum&language=$language');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      await fetchConfigurations();

      list = extractedData["results"]
          .map<Movie>((item) => Movie.fromJson(item))
          .toList();

      _upcoming = list;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Movie>> fetchHighlight() async {
    List<Movie> result;
    final url = Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?api_key=&language=$language');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      await fetchConfigurations();

      result = extractedData["results"]
          .map<Movie>((item) => Movie.fromJson(item))
          .toList();

      _highligth = result;
      return _highligth;
      // notifyListeners();
    } catch (error) {
      // throw error;
      debugPrint("$error");
      return [];
    }
  }

  Future<List<Movie>> fetchSimilarMovies(int movieId) async {
    List<Movie> result;
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/similar?api_key=&language=$language');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      await fetchConfigurations();

      result = extractedData["results"]
          .map<Movie>((item) => Movie.fromJson(item))
          .toList();

      return result;
      // notifyListeners();
    } catch (error) {
      // throw error;
      debugPrint("$error");
      return [];
    }
  }

  Future<String> fetchTrailer(int movieId) async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=&language=$language');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> results = extractedData["results"];

      if (results.any((element) =>
          element["site"] == "YouTube" && element["type"] == "Trailer")) {
        var key = results.firstWhere(
            (el) => el["type"] == "Trailer" && el["site"] == "YouTube")["key"];
        return "https://www.youtube.com/watch?v=$key";
      } else {
        return "";
      }
    } catch (error) {
      debugPrint("$error");
      return "";
    }
  }

  Future<List<CastMember>> fetchCast(int movieId) async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=&language=$language');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List results = extractedData["cast"];

      return results.map((e) => CastMember.fromJson(e)).toList();
    } catch (error) {
      debugPrint("$error");
      return [];
    }
  }

  Future<CastMember?> fetchCastMember(int castID) async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/person/$castID?api_key=&language=$language');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      return CastMember.fromJson(extractedData);
    } catch (error) {
      debugPrint("$error");
      return null;
    }
  }

  fetchConfigurations() async {
    final url =
        Uri.parse('https://api.themoviedb.org/3/configuration?api_key=');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      _base_config = extractedData["images"];
    } catch (error) {
      rethrow;
    }
  }

  fetchGenres() async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/genre/movie/list?api_key=&api_key=&language=$language');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List results = extractedData["genres"];

      _genres = results.map((e) => Genre.fromJson(e)).toList();
    } catch (error) {
      debugPrint("$error");
      return [];
    }
  }

  Future<List<WatchProvider>> fetchWatchProviders(
      Movie movie, BuildContext context) async {
    // Get the current system locale
    // final locale = Localizations.localeOf(context);

// Get the region code;
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/${movie.id}/watch/providers?api_key=');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        final Map results = extractedData["results"];

        if (results.isNotEmpty) {
          if (results.containsKey("PE")) {
            return [...results["PE"]["flatrate"], ...results["PE"]["buy"]]
                .map((e) => WatchProvider.fromJson(e))
                .toList();
          } else if (results.containsKey("US")) {
            return results["US"]["buy"]
                .map((e) => WatchProvider.fromJson(e))
                .toList();
          }
        }

        return [];
      } else {
        return [];
      }
    } catch (error) {
      debugPrint("$error");
      return [];
    }
  }
}
