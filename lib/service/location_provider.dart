import 'dart:convert';
import 'package:assignment/model/location_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationProvider with ChangeNotifier {
  final List<Loc> _locList = [];

  List<Loc> get locList => _locList;

  String _place = "Delhi, India";

  String get getPlaceName => _place;

  set setPlace(String value) {
    _place = value;
    notifyListeners();
  }

  Future<void> getLocations({String value = "Delhi"}) async {
    http.Response response;
    try {
      var url = Uri.parse(
          'https://www.astrotak.com/astroapi/api/location/place?inputPlace=$value');
      response = await http.get(url);
      if (response.statusCode == 200) {
        Location locations = Location.fromJson(json.decode(response.body));
        addData(locations.data);
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  void addData(List<Loc> dlist) {
    _locList.clear();
    _locList.addAll(dlist);
    notifyListeners();
  }
}
