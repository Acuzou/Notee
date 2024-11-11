// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuzou_app/general_widget/listWheelScroll.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

// ignore: must_be_immutable
class GaleryShop extends StatefulWidget {
  QueryDocumentSnapshot shopData;
  double width;
  double height;
  bool isDark;
  Function(int index) setIndex;
  //int imagesLength;

  GaleryShop({
    Key key,
    this.shopData,
    this.width,
    this.height,
    this.isDark,
    this.setIndex,
    //this.imagesLength,
  }) : super(key: key);

  @override
  State<GaleryShop> createState() => _GaleryShopState();
}

class _GaleryShopState extends State<GaleryShop> {
  int indexPhoto = 0;
  bool isInit = true;
  bool isPhotoCharged = false;
  List<NetworkImage> galeryLoaded = [];

  Future<List<NetworkImage>> getImage(
      List<QueryDocumentSnapshot> galeryDocs) async {
    galeryLoaded = [];
    for (int i = 0; i < galeryDocs.length; i++) {
      galeryLoaded.add(NetworkImage(galeryDocs[i]['shopPictureUrl']));
    }

    return galeryLoaded;
  }

  @override
  Widget build(BuildContext context) {
    // if (isInit) {
    //   Future.delayed(const Duration(milliseconds: 500), () {
    //     setState(() {
    //       isPhotoCharged = true;
    //       isInit = false;
    //     });
    //   });
    // }

    return SizedBox(
      height: widget.height * 0.35,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('shops')
              .doc(widget.shopData.id)
              .collection('galery')
              .snapshots(),
          builder: (context, galerySnapshot) {
            if (galerySnapshot.hasError) {
              const Text('Something went wrong.');
            }
            if (galerySnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final List<QueryDocumentSnapshot> galeryDocs =
                galerySnapshot.data.docs;

            return Stack(
              children: <Widget>[
                //ImageShop
                SizedBox(
                  height: widget.height * 0.35,
                  child: ListWheelScrollViewX.useDelegate(
                    childCount: galeryDocs.length,
                    itemExtent: widget.width * 0.93,
                    diameterRatio: 5,
                    //physics: const NeverScrollableScrollPhysics(),
                    physics: const FixedExtentScrollPhysics(),
                    //physics: const ScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    controller:
                        FixedExtentScrollController(initialItem: indexPhoto),
                    renderChildrenOutsideViewport: false,
                    //clipBehavior: Clip.none,
                    //useMagnifier: true,
                    //magnification: 1.5,
                    squeeze: 0.9,
                    onSelectedItemChanged: (index) {
                      indexPhoto = index;
                      widget.setIndex(index);
                    },

                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: galeryDocs.length,
                      //childCount: 3,
                      builder: (context, index) {
                        return ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(30),
                          ),
                          child: SizedBox(
                            height: widget.height * 0.35,
                            width: widget.width * 0.93,
                            child: FutureBuilder(
                              future: getImage(galeryDocs),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  //if (snapshot.hasData) {
                                  return Image(
                                    image: snapshot.data[index],
                                    fit: BoxFit.cover,
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                Positioned(
                  width: widget.width,
                  bottom: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, elevation: 0),
                        child: Icon(
                          Icons.arrow_back_ios_outlined,
                          size: 30,
                          color: Palette.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            if (indexPhoto != 0) {
                              indexPhoto -= 1;
                              widget.setIndex(indexPhoto);
                            }
                          });
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, elevation: 0),
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 30,
                          color: Palette.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            if (indexPhoto != galeryDocs.length - 1) {
                              indexPhoto += 1;
                              widget.setIndex(indexPhoto);
                            }
                          });
                        },
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
