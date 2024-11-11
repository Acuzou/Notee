import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;
  final double width;
  final String imageAsset;

  const CategoryItem(
      {Key key,
      this.title,
      this.color,
      this.onTap,
      this.width,
      this.imageAsset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Hero(
        tag: title,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            //splashColor: Theme.of(context).primaryColor,
            //borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset(imageAsset, fit: BoxFit.cover),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
