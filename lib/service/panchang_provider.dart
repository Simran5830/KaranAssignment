import 'dart:convert';
import 'package:assignment/model/panchang_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PanchangProvider with ChangeNotifier {
  DateTime _dateSelected = DateTime.now();

  set dateSet(DateTime date) {
    _dateSelected = date;
    notifyListeners();
  }

  String _placeId = "ChIJL_P_CXMEDTkRw0ZdG-0GVvw";
  set setPlaceId(String val) {
    _placeId = val;
    notifyListeners();
  }

  DateTime get dateSelected => _dateSelected;

  Future<Data?> getPanchang() async {
    http.Response response;
    Panchang? panchang;
    try {
      var url = Uri.parse(
          'https://www.astrotak.com/astroapi/api/horoscope/daily/panchang');
      response = await http.post(url,
          headers: {'Content-type': 'application/json'},
          body: json.encode({
            "day": _dateSelected.day,
            "month": _dateSelected.month,
            "year": _dateSelected.year,
            "placeId": _placeId
          }));
      if (response.statusCode == 200) {
        panchang = Panchang.fromJson(json.decode(response.body));
        //notifyListeners();
        return panchang.data;
      }
    } catch (e) {
      print(e);
    }
    return panchang?.data;
  }
}
