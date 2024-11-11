import 'package:cuzou_app/shop_file/screen/shop_detail_screen.dart';
import 'package:flutter/material.dart';
import '../Model/news.dart';

import 'package:cuzou_app/main.dart';
import 'package:date_format/date_format.dart';

class NewsItem extends StatefulWidget {
  final News publication;
  final bool isMyNews;
  final bool isDark;
  final bool isFrench;
  final bool isInJournal;
  final Function(int indexNews) deleteNewsItem;

  const NewsItem({
    Key key,
    this.publication,
    this.isMyNews,
    this.isDark,
    this.isFrench,
    this.isInJournal,
    this.deleteNewsItem,
  }) : super(key: key);

  @override
  NewsItemState createState() => NewsItemState();
}

class NewsItemState extends State<NewsItem> {
  News publication;
  bool isDark;
  bool isMyNews;
  bool isFrench;

  @override
  void initState() {
    publication = widget.publication;
    isDark = widget.isDark;
    isFrench = widget.isFrench;
    isMyNews = widget.isMyNews;
    super.initState();
  }

  int indexLongPress = 0;
  bool showDeleteButton = false;

  void selectShop(BuildContext context, int shopId) {
    Color categoryColor = shadeColor(Palette.orange, 0.1);
    Navigator.pushNamed(context, ShopDetailScreen.routeName, arguments: {
      'shopId': shopId,
      'isFrench': isFrench,
      'isDark': isDark,
      'categoryColor': categoryColor,
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.isInJournal) {
          selectShop(context, publication.shopId);
        }
      },
      child: GestureDetector(
        onLongPress: () {
          if (isMyNews) {
            setState(() {
              indexLongPress += 1;
              if (indexLongPress % 2 == 0) {
                showDeleteButton = false;
              } else {
                showDeleteButton = true;
              }
            });
          }
        },
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: secondaryColor(!isDark, Palette.orange),
                ),
                borderRadius: BorderRadius.circular(30),
                color: primaryColor(isDark),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: primaryColor(!isDark),
                                  width: 3,
                                  style: BorderStyle.solid,
                                ),
                                // right: BorderSide(
                                //   color: primaryColor(!isDark),
                                //   width: 3,
                                //   style: BorderStyle.solid,
                                // ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        publication.titleShop,
                                        style: TextStyle(
                                          color: secondaryColor(
                                              !isDark, Palette.orange),
                                          fontSize: 20,
                                          fontFamily: 'RebondGrotesque',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        publication.titleNews,
                                        style: TextStyle(
                                          color: primaryColor(!isDark),
                                          fontSize: 18,
                                          fontFamily: 'RebondGrotesque',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      )
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      Text(
                                        formatDate(
                                          publication.createdAt,
                                          [HH, ':', nn],
                                        ),
                                        style: TextStyle(
                                          color: primaryColor(!isDark),
                                        ),
                                      ),
                                      Text(
                                        formatDate(
                                          publication.createdAt,
                                          [d, ' ', MM, ' '],
                                        ),
                                        style: TextStyle(
                                          color: primaryColor(!isDark),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Text(publication.content,
                                style: TextStyle(
                                  color: primaryColor(!isDark),
                                  fontSize: 18,
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          publication.imageUrl != 'No image'
                              ? Image.network(publication.imageUrl)
                              : Container(),
                          //NetworkImage(publication.imageUrl)
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            (showDeleteButton)
                ? Positioned(
                    right: 30,
                    bottom: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                title: Text(
                                  isFrench
                                      ? 'Êtes-vous sûr de vouloir supprimer votre publication ?'
                                      : 'Are you sure to delete your publication ?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Palette.orange,
                                    fontFamily: 'RebondGrotesque',
                                    fontSize: 22,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 30, top: 50),
                                backgroundColor: tintColor(Palette.black, 0.01),
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      //Return Button
                                      Flexible(
                                        flex: 1,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Palette.orange,
                                            padding: const EdgeInsets.all(10),
                                            shape: const CircleBorder(),
                                          ),
                                          child: const Icon(
                                            Icons.arrow_back,
                                            size: 30,
                                          ),
                                        ),
                                      ),

                                      //Continuer Button
                                      Flexible(
                                        flex: 2,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            widget.deleteNewsItem(
                                                publication.newsId);
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Palette.orange,
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 15,
                                              bottom: 15,
                                            ),
                                            shape: const StadiumBorder(),
                                          ),
                                          child: Text(
                                            isFrench ? 'Valider' : 'Accept',
                                            style: TextStyle(
                                              color: Palette.secondary,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'RebondGrotesque',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: shadeColor(Palette.blue, 0.2),
                        padding: const EdgeInsets.all(10),
                        shape: const CircleBorder(),
                      ),
                      child: Icon(
                        Icons.delete,
                        size: 30,
                        color: Palette.black,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
