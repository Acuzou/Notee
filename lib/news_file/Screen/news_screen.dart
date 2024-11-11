import 'package:flutter/material.dart';
import 'package:cuzou_app/main.dart';
import '../Model/news.dart';
import '../widget/news_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class NewsScreen extends StatefulWidget {
  static const routeName = "/news-screen";

  bool isDark;
  bool isFrench;

  NewsScreen({Key key, this.isDark, this.isFrench}) : super(key: key);

  @override
  NewsScreenState createState() => NewsScreenState();
}

class NewsScreenState extends State<NewsScreen> {
  Future<List<News>> newsJournal;
  bool isInit = true;

  Future<List<News>> getNewsList(
      List<QueryDocumentSnapshot> favorites, context) async {
    List<News> newsJournal = [];

    try {
      var shopSnapshot =
          await FirebaseFirestore.instance.collection("shops").get();

      List<QueryDocumentSnapshot> shopData = shopSnapshot.docs;
      if (shopData.isNotEmpty) {
        for (int i = 0; i < favorites.length; i++) {
          var shop = shopData
              .firstWhere((shop) => shop['shopId'] == favorites[i]['shopId']);

          var newsSnapshot = await FirebaseFirestore.instance
              .collection("shops")
              .doc(shop.id)
              .collection("news")
              .orderBy('createdAt', descending: true)
              .get();

          List<QueryDocumentSnapshot> newsDocs = newsSnapshot.docs;

          for (QueryDocumentSnapshot newsDoc in newsDocs) {
            newsJournal.add(News(
              shopId: newsDoc['shopId'],
              newsId: newsDoc['newsId'],
              createdAt: newsDoc['createdAt'].toDate(),
              titleNews: newsDoc['titleNews'],
              titleShop: newsDoc['titleShop'],
              content: newsDoc['content'],
              imageUrl: newsDoc['imageNewsUrl'],
            ));

            //Sort by Date
            newsJournal.sort((newsA, newsB) {
              DateTime dateA = newsA.createdAt;
              DateTime dateB = newsB.createdAt;

              return dateB.compareTo(dateA);
            });
          }
        }
      }
    } on PlatformException catch (err) {
      var message = 'An error occured, pleased check your credentials !';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }

    return newsJournal;
  }

  @override
  Widget build(BuildContext context) {
    User auth = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(auth.uid)
            .collection('favorite')
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> favoriteSnapshot) {
          if (favoriteSnapshot.hasError) {
            return const Text('Something went wrong.');
          }
          if (!favoriteSnapshot.hasData) {
            return const Text('No DATA');
          }
          if (favoriteSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final favorites = favoriteSnapshot.data.docs;

          if (isInit) {
            newsJournal = getNewsList(favorites, context);
            isInit = false;
          }

          return Scaffold(
            backgroundColor: primaryColor(widget.isDark),
            body: SafeArea(
              child: Container(
                color: primaryColor(widget.isDark),
                margin: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 20),
                height: double.infinity,
                width: double.infinity,
                child: FutureBuilder(
                    future: newsJournal,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        //if (snapshot.hasData) {

                        if (snapshot.data.length != 0) {
                          return ListView.builder(
                            itemBuilder: (ctx, index) {
                              return NewsItem(
                                publication: snapshot.data[index],
                                isMyNews: false,
                                isDark: widget.isDark,
                                isFrench: widget.isFrench,
                                isInJournal: true,
                              );
                            },
                            itemCount: snapshot.data.length,
                          );
                        } else {
                          return Center(
                            child: Text(
                              widget.isFrench
                                  ? 'Ajoutez des commerces à vos favoris pour voir leur Journal !'
                                  : 'Add shops in your favorites to see their Newspaper',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: primaryColor(!widget.isDark),
                                fontFamily: 'RebondGrotesque',
                                fontSize: 20,
                              ),
                            ),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return Center(
                          child: Text(
                            widget.isFrench
                                ? 'Ajoutez des commerces à vos favoris pour voir leur Journal !'
                                : 'Add shops in your favorites to see their Newspaper',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: primaryColor(!widget.isDark),
                              fontFamily: 'RebondGrotesque',
                              fontSize: 20,
                            ),
                          ),
                        );
                      }
                    }),
              ),
            ),
          );
        });
  }
}
