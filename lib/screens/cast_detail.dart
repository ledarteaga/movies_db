import 'package:flutter/material.dart';
import 'package:movies_db/entities/cast_member.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:provider/provider.dart';

import '../services/movies_service.dart';

// ignore: must_be_immutable
class CastDetailScreen extends StatelessWidget {
  const CastDetailScreen({super.key, required this.movieId});

  final int movieId;

  @override
  Widget build(BuildContext context) {
    MoviesServices movieService = Provider.of<MoviesServices>(context);

    return EnhancedFutureBuilder(
        future: movieService.fetchCast(movieId),
        rememberFutureResult: true,
        whenDone: (snapshotData) => ListView(
              children: snapshotData
                  .map<Widget>((e) => Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              e.name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13),
                            ),
                            const Text(
                              " - ",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              e.character ?? '',
                              style: TextStyle(
                                  color: Colors.grey[200], fontSize: 13),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
        whenNotDone: Container());
  }
}


  //   return FutureBuilder(
    //       future: fetchCast,
    //       builder: (context, snapshot) {
    //         return snapshot.hasData
    //             ? ListView.builder(
    //                 physics: const BouncingScrollPhysics(),
    //                 itemBuilder: (context, index) => Row(
    //                   children: [
    //                     Container(
    //                       alignment: AlignmentDirectional.centerStart,
    //                       margin: const EdgeInsets.symmetric(horizontal: 14),
    //                       child: Column(
    //                         children: [
    //                           Container(
    //                             alignment: Alignment.centerLeft,
    //                             margin: const EdgeInsets.only(top: 30),
    //                             child: Text(
    //                               snapshot.data![index].name,
    //                               style: const TextStyle(
    //                                   color: Colors.white,
    //                                   fontSize: 18,
    //                                   fontWeight: FontWeight.w700),
    //                             ),
    //                           ),
    //                           Container(
    //                             alignment: Alignment.centerLeft,
    //                             margin: const EdgeInsets.only(top: 10),
    //                             child: Row(
    //                               children: [
    //                                 Expanded(
    //                                   child: Text(
    //                                     snapshot.data![index]
    //                                             .knownForDepartment ??
    //                                         "",
    //                                     style: TextStyle(
    //                                         fontStyle: FontStyle.italic,
    //                                         color: Colors.white.withOpacity(0.5),
    //                                         fontSize: 16,
    //                                         fontWeight: FontWeight.w700),
    //                                   ),
    //                                 ),
    //                                 Text(
    //                                   snapshot.data![index].popularity
    //                                       .floorToDouble()
    //                                       .toString(),
    //                                   style: const TextStyle(
    //                                       color: Colors.white,
    //                                       fontSize: 16,
    //                                       fontWeight: FontWeight.w700),
    //                                 ),
    //                                 const Icon(
    //                                   Icons.star_rounded,
    //                                   color: Colors.yellow,
    //                                   size: 20,
    //                                 )
    //                               ],
    //                             ),
    //                           ),
    //                           Container(
    //                             alignment: Alignment.centerLeft,
    //                             margin: const EdgeInsets.only(top: 20),
    //                             child: Text(
    //                               snapshot.data![index].biography ?? "",
    //                               style: const TextStyle(
    //                                   color: Colors.white,
    //                                   fontSize: 14,
    //                                   fontWeight: FontWeight.w400),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               )
    //             : SizedBox();
    //       });
    // }
  