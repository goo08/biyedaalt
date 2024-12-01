import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:biydaalt/apilinks/allapi.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> trendinglist = [];

  Future<void> trendingListhome() async {
    var trendingweekresponse = await http.get(Uri.parse(trendingweekurl));
    if (trendingweekresponse.statusCode == 200) {
      var tempdata = jsonDecode(trendingweekresponse.body);
      var trendingweekjson = tempdata['result'];
      for (var i = 0; i < trendingweekjson.length; i++) {
        trendinglist.add({
          'id': trendingweekjson[i]['id'],
          'poster_path': trendingweekjson[i]['poster_path'],
          'vote_average': trendingweekjson[i]['vote_average'],
          'media_type': trendingweekjson[i]['media_type'],
          'indexno': i,
        });
      }
    }
  }

  int uval = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          centerTitle: true,
          toolbarHeight: 60,
          pinned: true,
          expandedHeight: MediaQuery.of(context).size.height * 0.5,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: FutureBuilder(
                future: trendingListhome(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CarouselSlider(
                      options: CarouselOptions(
                          viewportFraction: 1,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 2),
                          height: MediaQuery.of(context).size.height),
                      items: trendinglist.map((i) {
                        return Builder(builder: (BuildContext context) {
                          return GestureDetector(
                              onTap: () {},
                              child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            colorFilter: ColorFilter.mode(
                                                Colors.black.withOpacity(0.3),
                                                BlendMode.darken),
                                            image: NetworkImage(
                                                'https://image.tmdb.org/t/p/w500${i['poster_path']}'),
                                            fit: BoxFit.fill)),
                                  )));
                        });
                      }).toList(),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.amber,
                      ),
                    );
                  }
                }),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Trending',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8), fontSize: 16)
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          const Center(
            child: Text('Sample text'),
          )
        ]))
      ],
    ));
  }
}
