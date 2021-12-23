import 'package:assignment/commonWidgets/header.dart';
import 'package:assignment/model/location_model.dart';
import 'package:assignment/model/panchang_model.dart';
import 'package:assignment/service/location_provider.dart';
import 'package:assignment/service/panchang_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class PanchangScreen extends StatefulWidget {
  const PanchangScreen({Key? key}) : super(key: key);

  @override
  State<PanchangScreen> createState() => _PanchangScreenState();
}

class _PanchangScreenState extends State<PanchangScreen> {
  late Size size;
  late Data data;
  final textController = TextEditingController();
  final focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      textController.text =
          Provider.of<LocationProvider>(context, listen: false).getPlaceName;
      _loadLocations("Delhi");
    });
    super.initState();
  }

  _loadLocations(String value) {
    Provider.of<LocationProvider>(context, listen: false)
        .getLocations(value: value);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(
          left: size.width * 0.02,
          right: size.width * 0.02,
          top: size.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _topBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _header(),
                  _desc(),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _dateAndLocationWidget(),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _list()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _topBar() {
    return Header();
  }

  //select date and location
  _dateAndLocationWidget() {
    return Container(
      width: size.width,
      height: size.height * 0.2,
      color: const Color(0xffffb6c1).withOpacity(0.6),
      child: Padding(
        padding: EdgeInsets.only(top: size.height * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                SizedBox(height: size.height * 0.02),
                const Text("Date:"),
                SizedBox(height: size.height * 0.07),
                const Text("Location:"),
              ],
            ),
            //  SizedBox(height:size.height*0.02),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    selectDatePicker(context);
                  },
                  child: Consumer<PanchangProvider>(
                      builder: (context, provider, child) {
                    return Container(
                      height: size.height * 0.06,
                      width: size.width * 0.7,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.02,
                            bottom: size.height * 0.02,
                            left: size.width * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Jiffy(provider.dateSelected)
                                .format("do MMMM, yyyy")),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: size.height * 0.03),
                Consumer<LocationProvider>(builder: (context, provider, child) {
                  return Container(
                    height: size.height * 0.06,
                    width: size.width * 0.7,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.02,
                          bottom: size.height * 0.02,
                          left: size.width * 0.02),
                      child: Form(
                        key: _formKey,
                        child: TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: textController,
                            onChanged: (val) {
                              provider.getLocations(
                                  value: val.isEmpty ? "" : val);
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 8),
                              isDense: true,
                            ),
                          ),
                          suggestionsCallback: (pattern) {
                            return provider.locList.where((element) => element
                                .placeName
                                .toLowerCase()
                                .contains(pattern.toLowerCase()));
                          },
                          itemBuilder: (context, Loc suggestion) {
                            return ListTile(
                              title: Text(suggestion.placeName),
                            );
                          },
                          onSuggestionSelected: (Loc suggestion) {
                            textController.text = suggestion.placeName;
                            provider.setPlace = suggestion.placeName;
                            Provider.of<PanchangProvider>(context,
                                    listen: false)
                                .setPlaceId = suggestion.placeId;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please select a city';
                            }
                          },
                        ),
                      ),
                    ),
                  );
                })
              ],
            )
          ],
        ),
      ),
    );
  }

  _header() {
    return Row(
      children: [
        Container(
            width: size.width * 0.09,
            child: const Icon(Icons.arrow_back_ios_sharp)),
        const Text(
          "Daily Panchang",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  _desc() {
    return Text(
      "India is a country known for its festival but knowing the exact dates can sometimes be difficult.To ensure you do not miss out on the critical dates we bring you the daily panchang.",
      style: TextStyle(fontSize: size.width * 0.03, color: Colors.black54),
    );
  }

  _list() {
    return Consumer<PanchangProvider>(builder: (context, provider, child) {
      return FutureBuilder(
        future: provider.getPanchang(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              data = snapshot.data as Data;
              return Column(
                children: [
                  _tithiDetails(data.tithi),
                  const Divider(),
                  _nakshatraDetails(data.nakshatra),
                  const Divider(),
                  _yogDetails(data.yog),
                  const Divider(),
                  _karanDetails(data.karan),
                  SizedBox(
                    height: size.height * 0.02,
                  )
                ],
              );
            } else {
              return Container();
            }
          }
        },
      );
    });
  }

  _tithiDetails(Tithi data) {
    TextStyle contentStyle =
        TextStyle(fontSize: size.width * 0.03, color: Colors.grey);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tithi",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: size.width * 0.04),
        ),
        SizedBox(height: size.height * 0.009),
        Row(
          children: [
            Text("Tithi Number:", style: contentStyle),
            SizedBox(width: size.width * 0.14),
            Text(data.details.tithiNumber.toString(), style: contentStyle)
          ],
        ),
        SizedBox(height: size.height * 0.009),
        Row(
          children: [
            Text("Tithi Name:", style: contentStyle),
            SizedBox(width: size.width * 0.17),
            Text(data.details.tithiName, style: contentStyle)
          ],
        ),
        SizedBox(height: size.height * 0.009),
        Row(
          children: [
            Text("Special:", style: contentStyle),
            SizedBox(width: size.width * 0.22),
            Text(data.details.special, style: contentStyle)
          ],
        ),
        SizedBox(height: size.height * 0.009),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Summary:",
              style: contentStyle,
            ),
            SizedBox(width: size.width * 0.18),
            Expanded(
                child: Text(
              data.details.summary,
              style: contentStyle,
            ))
          ],
        ),
        SizedBox(height: size.height * 0.009),
        Row(
          children: [
            Text(
              "Diety:",
              style: contentStyle,
            ),
            SizedBox(width: size.width * 0.25),
            Text(
              data.details.deity,
              style: contentStyle,
            )
          ],
        ),
        SizedBox(height: size.height * 0.009),
        Row(
          children: [
            Text(
              "End Time:",
              style: contentStyle,
            ),
            SizedBox(width: size.width * 0.19),
            Text(
              "${data.endTime.hour} hr ${data.endTime.minute} min ${data.endTime.second} sec",
              style: contentStyle,
            )
          ],
        ),
        SizedBox(height: size.height * 0.02)
      ],
    );
  }

  _nakshatraDetails(Nakshatra data) {
    TextStyle contentStyle =
        TextStyle(fontSize: size.width * 0.03, color: Colors.grey);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nakshatra",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: size.width * 0.04),
        ),
        SizedBox(height: size.height * 0.009),
        Row(
          children: [
            Text("Nakshatra Number:", style: contentStyle),
            SizedBox(width: size.width * 0.065),
            Text(data.details.nakNumber.toString(), style: contentStyle)
          ],
        ),
        SizedBox(height: size.height * 0.009),
        Row(
          children: [
            Text("Nakshatra Name:", style: contentStyle),
            SizedBox(width: size.width * 0.09),
            Text(data.details.nakName, style: contentStyle)
          ],
        ),
        SizedBox(height: size.height * 0.009),
        Row(
          children: [
            Text("Ruler:", style: contentStyle),
            SizedBox(width: size.width * 0.26),
            Expanded(child: Text(data.details.ruler, style: contentStyle))
          ],
        ),
        SizedBox(height: size.height * 0.009),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Deity:",
              style: contentStyle,
            ),
            SizedBox(width: size.width * 0.26),
            Expanded(
                child: Text(
              data.details.deity,
              style: contentStyle,
            ))
          ],
        ),
        SizedBox(height: size.height * 0.009),
        Row(
          children: [
            Text(
              "Summary:",
              style: contentStyle,
            ),
            SizedBox(width: size.width * 0.2),
            Expanded(
                child: Text(
              data.details.summary,
              style: contentStyle,
            ))
          ],
        ),
        SizedBox(height: size.height * 0.009),
        Row(
          children: [
            Text(
              "End Time:",
              style: contentStyle,
            ),
            SizedBox(width: size.width * 0.2),
            Text(
              "${data.endTime.hour} hr ${data.endTime.minute} min ${data.endTime.second} sec",
              style: contentStyle,
            )
          ],
        ),
        SizedBox(height: size.height * 0.02)
      ],
    );
  }

  _yogDetails(Yog data) {
    TextStyle contentStyle =
        TextStyle(fontSize: size.width * 0.03, color: Colors.grey);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Yog",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: size.width * 0.04),
        ),
        SizedBox(height: size.height * 0.009),
        Row(
          children: [
            Text("Yog Number:", style: contentStyle),
            SizedBox(width: size.width * 0.16),
            Text(data.details.yogNumber.toString(), style: contentStyle)
          ],
        ),
        SizedBox(height: size.height * 0.009),
        Row(
          children: [
            Text("Yog Name:", style: contentStyle),
            SizedBox(width: size.width * 0.19),
            Text(data.details.yogName, style: contentStyle)
          ],
        ),
        SizedBox(height: size.height * 0.009),
        Row(
          children: [
            Text("Special:", style: contentStyle),
            SizedBox(width: size.width * 0.24),
            Expanded(child: Text(data.details.special, style: contentStyle))
          ],
        ),
        SizedBox(height: size.height * 0.009),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Meaning:",
              style: contentStyle,
            ),
            SizedBox(width: size.width * 0.22),
            Expanded(
                child: Text(
              data.details.meaning,
              style: contentStyle,
            ))
          ],
        ),
      ],
    );
  }

  _karanDetails(Karan data) {
    TextStyle contentStyle =
        TextStyle(fontSize: size.width * 0.03, color: Colors.grey);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Karan",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: size.width * 0.04),
        ),
        SizedBox(height: size.height * 0.009),
        Row(
          children: [
            Text("Karan Number:", style: contentStyle),
            SizedBox(width: size.width * 0.14),
            Text(data.details.karanNumber.toString(), style: contentStyle)
          ],
        ),
        SizedBox(height: size.height * 0.009),
        Row(
          children: [
            Text("Karan Name:", style: contentStyle),
            SizedBox(width: size.width * 0.17),
            Text(data.details.karanName, style: contentStyle)
          ],
        ),
        SizedBox(height: size.height * 0.009),
        Row(
          children: [
            Text("Special:", style: contentStyle),
            SizedBox(width: size.width * 0.24),
            Expanded(child: Text(data.details.special, style: contentStyle))
          ],
        ),
        SizedBox(height: size.height * 0.009),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Deity:",
              style: contentStyle,
            ),
            SizedBox(width: size.width * 0.28),
            Expanded(
                child: Text(
              data.details.deity,
              style: contentStyle,
            ))
          ],
        ),
      ],
    );
  }
}

//datepicker function to select and update date
Future<void> selectDatePicker(BuildContext context) async {
  DateTime selected =
      Provider.of<PanchangProvider>(context, listen: false).dateSelected;
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selected,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030));
  if (picked != null) {
    Provider.of<PanchangProvider>(context, listen: false).dateSet = picked;
  }
}
