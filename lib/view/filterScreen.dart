import 'package:assignment/service/astrologer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late AstrologerProvider prov;
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    prov = Provider.of<AstrologerProvider>(context, listen: false);

    //skill list
    var expanded = ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: prov.getLanguages.keys.map((String key) {
        return CheckboxListTile(
          title: Text(key),
          value: prov.language[key],
          activeColor: Colors.orange,
          checkColor: Colors.white,
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                prov.language[key] = true;
                prov.addToLanguageList(key);
              } else {
                prov.language[key] = false;
                prov.removeFromLanguageList(key);
              }
            });
          },
        );
      }).toList(),
    );

    //language list
    var expanded2 = ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: prov.getSkills.keys.map((String key) {
        return CheckboxListTile(
          title: Text(key),
          value: prov.skills[key],
          activeColor: Colors.orange,
          checkColor: Colors.white,
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                prov.skills[key] = true;
                prov.addToList(key);
              } else {
                prov.skills[key] = false;
                prov.removeFromList(key);
              }
            });
          },
        );
      }).toList(),
    );

    //header
    var row = Row(
      children: [
        GestureDetector(
          child: Container(
              width: size.width * 0.09,
             
              child: const Icon(Icons.arrow_back_ios_sharp)),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        SizedBox(width: size.width * 0.35),
        Text(
          "Filter",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: size.width * 0.05),
        ),
      ],
    );

    //mainbody
    var column =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      SizedBox(
        height: size.height * 0.02,
      ),
      row,
      SizedBox(
        height: size.height * 0.02,
      ),
      Text(
        "Skills",
        style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: size.width * 0.04),
      ),
      expanded2,
      const Divider(),
      Text(
        "Languages",
        style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: size.width * 0.04),
      ),
      expanded,
    ]);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              left: size.width * 0.02, right: size.width * 0.02),
          child: SingleChildScrollView(
            child: column,
          ),
        ),
      ),
    );
  }
}
