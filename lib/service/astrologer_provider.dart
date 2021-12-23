import 'dart:convert';

import 'package:assignment/model/astrologer_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AstrologerProvider with ChangeNotifier {
  List<Data> _data = <Data>[];
  List<Data> get datalist => _data;

  final Map<String, bool> skills = {
    'Coffe cup reading': false,
    'vastu': false,
    'Palmistry': false,
    'face reading': false,
    'astrology': false,
    'Numerology': false,
    'Vedic Astrology': false,
    'Face Reading': false,
    'Kundali': false
  };

  final Map<String, bool> language = {
    'English': false,
    'Hindi': false,
  };

  Map<String, bool> get getLanguages => language;

  Map<String, bool> get getSkills => skills;

  Set<String> languageList = {};

  void addToLanguageList(String val) {
    languageList.add(val);
    filterDataList(value: "");
  }

  void removeFromLanguageList(String val) async {
    languageList.remove(val);
    await getAstrologers();
    filterDataList(value: "");
  }

  Set<String> skillList = {};
  void addToList(String val) {
    skillList.add(val);
    filterDataList(value: "");
  }

  void removeFromList(String val) async {
    skillList.remove(val);
    await getAstrologers();
    filterDataList(value: "");
  }

  Future<void> getAstrologers() async {
    http.Response response;
    try {
      var url = Uri.parse('https://www.astrotak.com/astroapi/api/agent/all');
      response = await http.get(url);
      if (response.statusCode == 200) {
        Astrologer astrologers =
            Astrologer.fromJson(json.decode(response.body));
        addData(astrologers.data);
        sortExpHTL();
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  void addData(List<Data> dlist) {
    _data.clear();
    _data.addAll(dlist);
    filterDataList(value: "");
    notifyListeners();
  }

  void sortExpLTH() {
    _data.sort((a, b) => a.experience.toInt().compareTo(b.experience.toInt()));

    notifyListeners();
  }

  void sortExpHTL() {
    _data.sort((a, b) => b.experience.toInt().compareTo(a.experience.toInt()));

    notifyListeners();
  }

  void sortPriceHTL() {
    _data.sort((a, b) => b.minimumCallDurationCharges
        .toInt()
        .compareTo(a.minimumCallDurationCharges.toInt()));

    notifyListeners();
  }

  void sortPriceLTH() {
    _data.sort((a, b) => a.minimumCallDurationCharges
        .toInt()
        .compareTo(b.minimumCallDurationCharges.toInt()));
    notifyListeners();
  }

  void filterOnSearch(String value) async {
    await getAstrologers();
    _data = _data
        .where((element) =>
            element.firstName.toLowerCase().contains(value.toLowerCase()) ||
            element.lastName.toLowerCase().contains(value.toLowerCase()) ||
            checkLang(element, value) ||
            checkSkills(element, value) &&
                checkFilterSkills(element) &&
                checkFilterLang(element))
        .toList();
    _data = _data.toSet().toList();
    notifyListeners();
  }

  bool checkLang(Data data, String value) {
    bool? isAvailable = false;
    for (var element in data.languages) {
      isAvailable = element.name?.toLowerCase().contains(value.toLowerCase());
      if (isAvailable == true) {
        break;
      }
    }
    return isAvailable ?? false;
  }

  bool checkFilterSkills(Data data) {
    if (skillList.isEmpty) {
      return true;
    } else {
      for (var element in skillList) {
        for (var elem in data.skills) {
          if (elem.name!.toLowerCase().contains(element.toLowerCase())) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool checkFilterLang(Data data) {
    if (languageList.isEmpty) {
      return true;
    } else {
      for (var element in languageList) {
        for (var elem in data.languages) {
          if (elem.name!.toLowerCase().contains(element.toLowerCase())) {
            return true;
          }
        }
      }
    }
    return false;
  }

  filterDataList({String value = ""}) {
    _data = _data
        .where(
            (element) => checkFilterSkills(element) && checkFilterLang(element))
        .toList();
    _data = _data.toSet().toList();
    notifyListeners();
  }

  bool checkSkills(Data data, String value) {
    bool? isAvailable = false;
    for (var element in data.skills) {
      isAvailable = element.name?.toLowerCase().contains(value.toLowerCase());
      if (isAvailable == true) {
        break;
      }
    }
    return isAvailable ?? false;
  }
}
