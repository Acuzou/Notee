// ignore_for_file: file_names

import "package:flutter/material.dart";
import "package:cuzou_app/main.dart";
import "package:cuzou_app/research_file/Data/general_data.dart";
import "package:cuzou_app/research_file/Model/shop.dart";

import '../../general_widget/data_widget.dart';

// ignore: must_be_immutable
class SimpleDialogCity extends StatefulWidget {
  double width;
  double height;
  bool isFrench;
  Color color;
  int cityId;
  Function(int cityId, String cityText) submitCity;

  SimpleDialogCity({
    Key key,
    this.width,
    this.height,
    this.isFrench,
    this.submitCity,
    this.color,
    this.cityId,
  }) : super(key: key);

  @override
  State<SimpleDialogCity> createState() => _SimpleDialogCityState();
}

class _SimpleDialogCityState extends State<SimpleDialogCity> {
  int cityIndex;
  String cityName;
  bool isDark = true;
  List<City> _cityList = cityList;
  TextEditingController cityController;

  @override
  void initState() {
    super.initState();

    cityIndex = widget.cityId;
    cityName = getCityName(cityList[widget.cityId]);
  }

  void sendCityChosen(int cityIndex, String cityName) {
    if (cityIndex != 0) {
      widget.submitCity(cityIndex, cityName);
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void updateDisplay(String value) {
    setState(() {
      if (value.isEmpty) {
        _cityList = cityList;
      } else {
        _cityList = [City.Default] +
            cityList.where((city) {
              return getCityName(city)
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase());
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        widget.isFrench ? 'Liste des villes' : 'City list',
        style: TextStyle(color: widget.color, fontFamily: 'RebondGrotesque'),
        textAlign: TextAlign.center,
      ),
      contentPadding: const EdgeInsets.all(20),
      backgroundColor: tintColor(Palette.black, 0.01),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            researchBar(isDark, widget.isFrench, false, true, updateDisplay,
                cityController),
            SizedBox(
              height: widget.height * 0.500,
              width: widget.width * 0.7,
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return Container(
                    width: widget.width * 0.6,
                    height: widget.height * 0.09,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          cityName = getCityName(_cityList[index + 1]);
                          cityIndex = index + 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.black,
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 5,
                          bottom: 5,
                        ),
                        side: (cityIndex == index + 1)
                            ? BorderSide(
                                width: 5,
                                color: widget.color,
                              )
                            : BorderSide(
                                width: 2,
                                color: widget.color,
                              ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        getCityName(_cityList[index + 1]),
                        style: TextStyle(
                          fontSize: 20,
                          color: widget.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
                itemCount: _cityList.length - 1,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            //End Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //Close button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    widget.isFrench ? 'Retour' : 'Return',
                    style: TextStyle(
                      color: widget.color,
                      fontSize: 16,
                    ),
                  ),
                ),
                //Validate Button
                ElevatedButton(
                  onPressed: () {
                    sendCityChosen(cityIndex, cityName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.color,
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 15,
                      bottom: 15,
                    ),
                  ),
                  child: Text(
                    widget.isFrench ? "Valider" : 'Validate',
                    style: TextStyle(
                      color: Palette.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
