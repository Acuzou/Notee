import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../research_file/Data/data_function.dart';
import '../Model/news.dart';
import '../widget/news_item.dart';
import 'package:cuzou_app/main.dart';

class NewsShop extends StatefulWidget {
  final QueryDocumentSnapshot shopReference;
  final bool isMyNews;
  final bool isDark;
  final bool isFrench;
  final List<QueryDocumentSnapshot> shopsDocs;

  const NewsShop({
    Key key,
    this.shopReference,
    this.isMyNews,
    this.isDark,
    this.isFrench,
    this.shopsDocs,
  }) : super(key: key);

  @override
  NewsShopState createState() => NewsShopState();
}

class NewsShopState extends State<NewsShop> {
  void deleteNewsItem(int indexNews) async {
    var newsSnapshot = await FirebaseFirestore.instance
        .collection('shops')
        .doc(widget.shopReference.id)
        .collection('news')
        .get();

    List<QueryDocumentSnapshot> newsList = newsSnapshot.docs;

    QueryDocumentSnapshot newsSelected =
        newsList.firstWhere((news) => news['newsId'] == indexNews);

    await FirebaseFirestore.instance
        .collection('shops')
        .doc(widget.shopReference.id)
        .collection('news')
        .doc(newsSelected.id)
        .delete();

    await FirebaseFirestore.instance
        .collection('shops')
        .doc(widget.shopReference.id)
        .update({'nbPublications': widget.shopReference['nbPublications'] - 1});

    double rate = getRate(
        widget.shopReference['nbPublications'],
        widget.shopReference['nbFavorites'],
        widget.shopReference['meanResponseTime'],
        widget.shopReference['subCatId'],
        widget.shopsDocs);

    await FirebaseFirestore.instance
        .collection('shops')
        .doc(widget.shopReference.id)
        .update({'rate': rate});

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('shops/${widget.shopReference.id}/news')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> newsSnapshot) {
        if (newsSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final newsDocs = newsSnapshot.data.docs;

        return (newsDocs.isNotEmpty)
            // ? Container(
            //     color: primaryColor(isDark),
            //     margin: const EdgeInsets.only(
            //         left: 10, right: 10, top: 10, bottom: 20),
            //     //height: height * 0.71,
            //     width: double.infinity,
            //     child:
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                reverse: false,
                itemCount: newsDocs.length,
                itemBuilder: (ctx, index) {
                  var newsSnapshot = newsDocs[index];
                  News news = News(
                    shopId: newsSnapshot['shopId'],
                    newsId: newsSnapshot['newsId'],
                    createdAt: newsSnapshot['createdAt'].toDate(),
                    titleNews: newsSnapshot['titleNews'],
                    titleShop: newsSnapshot['titleShop'],
                    content: newsSnapshot['content'],
                    imageUrl: newsSnapshot['imageNewsUrl'],
                  );
                  return NewsItem(
                    publication: news,
                    isMyNews: widget.isMyNews,
                    isDark: widget.isDark,
                    isFrench: widget.isFrench,
                    isInJournal: false,
                    deleteNewsItem: deleteNewsItem,
                  );
                },
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.1,
                  ),
                  Text(
                    widget.isFrench
                        ? 'Il n\'y a pas encore de publication dans ce journal !'
                        : 'No publication in this feed for now !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryColor(!widget.isDark),
                      fontFamily: 'RebondGrotesque',
                      fontSize: 20,
                    ),
                  ),
                ],
              );
      },
    );
  }
}
