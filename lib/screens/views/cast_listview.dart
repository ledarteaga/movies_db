import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_db/entities/cast_member.dart';
import 'package:movies_db/screens/cast_detail.dart';
import 'package:provider/provider.dart';

import '../../services/movies_service.dart';

class CastListView extends StatefulWidget {
  const CastListView({
    Key? key,
    required this.data,
    required this.title,
  }) : super(key: key);

  static Route<dynamic> route(List<CastMember> data, String title) {
    return CupertinoPageRoute(
      builder: (context) => CastListView(data: data, title: title),
    );
  }

  final List<CastMember> data;
  final String title;

  @override
  State<CastListView> createState() => _CastListViewState();
}

class _CastListViewState extends State<CastListView>
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
                    title: const Text(
                      "Reparto",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
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
        backgroundColor: Colors.black,
        body: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 15, right: 15, top: 100),
            itemBuilder: (context, index) => InkWell(
                  // onTap: () => Navigator.push(context,
                  //     CastDetailScreen.route(widget.data[index].id, service)),
                  child: Row(children: [
                    Container(
                      width: 80,
                      height: 100,
                      margin: const EdgeInsets.only(right: 20),
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        // shape: BoxShape.circle,
                      ),
                      child: widget.data[index].profilePath == null
                          ? const Icon(
                              Icons.person,
                              color: Colors.grey,
                            )
                          : Image.network(
                              service.getCastMemberPath(
                                  widget.data[index].profilePath),
                              fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.data[index].name,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          widget.data[index].character ?? "",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ))
                  ]),
                ),
            separatorBuilder: (context, index) => const Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                  height: 20,
                ),
            itemCount: widget.data.length));
  }
}
