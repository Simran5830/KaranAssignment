// ignore_for_file: unnecessary_null_comparison

class Astrologer {
  late String httpStatus;
  late int httpStatusCode;
  late bool success;
  late String message;
  late String apiName;
  late List<Data> data;

  Astrologer(
      {required this.httpStatus,
      required this.httpStatusCode,
      required this.success,
      required this.message,
      required this.apiName,
      required this.data});

  Astrologer.fromJson(Map<String, dynamic> json) {
    httpStatus = json['httpStatus'];
    httpStatusCode = json['httpStatusCode'];
    success = json['success'];
    message = json['message'];
    apiName = json['apiName'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['httpStatus'] = httpStatus;
    data['httpStatusCode'] = httpStatusCode;
    data['success'] = success;
    data['message'] = message;
    data['apiName'] = apiName;
    // ignore: unnecessary_null_comparison
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  late int id;
  late String urlSlug;
  late String namePrefix;
  late String firstName;
  late String lastName;
  late String aboutMe;
  late String profliePicUrl;
  late double experience;
  late List<Languages> languages;
  late int minimumCallDuration;
  late double minimumCallDurationCharges;
  late double additionalPerMinuteCharges;
  late bool isAvailable;
  late double rating;
  late List<Skills> skills;
  late bool isOnCall;
  late int freeMinutes;
  late int additionalMinute;
  late Images images;
  late Availability availability;

  Data(
      {required this.id,
      required this.urlSlug,
      required this.namePrefix,
      required this.firstName,
      required this.lastName,
      required this.aboutMe,
      required this.profliePicUrl,
      required this.experience,
      required this.languages,
      required this.minimumCallDuration,
      required this.minimumCallDurationCharges,
      required this.additionalPerMinuteCharges,
      required this.isAvailable,
      required this.rating,
      required this.skills,
      required this.isOnCall,
      required this.freeMinutes,
      required this.additionalMinute,
      required this.images,
      required this.availability});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    urlSlug = json['urlSlug'];

    firstName = json['firstName'];
    lastName = json['lastName'];
    aboutMe = json['aboutMe'] ?? "";
    profliePicUrl = json['profliePicUrl'] ?? "";
    experience = json['experience'];
    if (json['languages'] != null) {
      languages = <Languages>[];
      json['languages'].forEach((v) {
        languages.add(Languages.fromJson(v));
      });
    }
    minimumCallDuration = json['minimumCallDuration'];
    minimumCallDurationCharges = json['minimumCallDurationCharges'];
    additionalPerMinuteCharges = json['additionalPerMinuteCharges'];
    isAvailable = json['isAvailable'];
    rating = json['rating'] ?? 0.0;
    if (json['skills'] != null) {
      skills = <Skills>[];
      json['skills'].forEach((v) {
        skills.add(Skills.fromJson(v));
      });
    }
    isOnCall = json['isOnCall'];
    freeMinutes = json['freeMinutes'];
    additionalMinute = json['additionalMinute'];
    images = (json['images'] != null ? Images.fromJson(json['images']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['urlSlug'] = urlSlug;
    data['namePrefix'] = namePrefix;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['aboutMe'] = aboutMe;
    data['profliePicUrl'] = profliePicUrl;
    data['experience'] = experience;
    if (languages != null) {
      data['languages'] = languages.map((v) => v.toJson()).toList();
    }
    data['minimumCallDuration'] = minimumCallDuration;
    data['minimumCallDurationCharges'] = minimumCallDurationCharges;
    data['additionalPerMinuteCharges'] = additionalPerMinuteCharges;
    data['isAvailable'] = isAvailable;
    data['rating'] = rating;
    if (skills != null) {
      data['skills'] = skills.map((v) => v.toJson()).toList();
    }
    data['isOnCall'] = isOnCall;
    data['freeMinutes'] = freeMinutes;
    data['additionalMinute'] = additionalMinute;
    if (images != null) {
      data['images'] = images.toJson();
    }
    if (availability != null) {
      data['availability'] = availability.toJson();
    }
    return data;
  }
}

class Languages {
  int? id;
  String? name;

  Languages({required this.id, required this.name});

  Languages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Skills {
  int? id;
  String? name;
  String? description;

  Skills({required this.id, required this.name, required this.description});

  Skills.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}

class Images {
  Small? small;
  Large? large;
  Large? medium;

  Images({required this.small, required this.large, required this.medium});

  Images.fromJson(Map<String, dynamic> json) {
    small = json['small'] != null ? Small.fromJson(json['small']) : null;
    large = json['large'] != null ? Large.fromJson(json['large']) : null;
    medium = json['medium'] != null ? Large.fromJson(json['medium']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (small != null) {
      data['small'] = small?.toJson();
    }
    if (large != null) {
      data['large'] = large?.toJson();
    }
    if (medium != null) {
      data['medium'] = medium?.toJson();
    }
    return data;
  }
}

class Small {
  String? imageUrl;
  int? id;

  Small({this.imageUrl, this.id});

  Small.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['imageUrl'] = imageUrl;
    data['id'] = id;
    return data;
  }
}

class Large {
  String? imageUrl;
  int? id;

  Large({required this.imageUrl, this.id});

  Large.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['imageUrl'] = imageUrl;
    data['id'] = id;
    return data;
  }
}

class Availability {
  List<String>? days;
  Slot? slot;

  Availability({required this.days, required this.slot});

  Availability.fromJson(Map<String, dynamic> json) {
    days = json['days'].cast<String>();
    slot = json['slot'] != null ? Slot.fromJson(json['slot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['days'] = days;
    if (slot != null) {
      data['slot'] = slot?.toJson();
    }
    return data;
  }
}

class Slot {
  String? toFormat;
  String? fromFormat;
  String? from;
  String? to;

  Slot(
      {required this.toFormat,
      required this.fromFormat,
      required this.from,
      required this.to});

  Slot.fromJson(Map<String, dynamic> json) {
    toFormat = json['toFormat'];
    fromFormat = json['fromFormat'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['toFormat'] = toFormat;
    data['fromFormat'] = fromFormat;
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}

String getSkills(Data data) {
  String skills = "";
  for (int i = 0; i < data.skills.length; i++) {
    skills += data.skills[i].name!;
    if (i != data.skills.length - 1) {
      skills += ", ";
    }
  }
  return skills;
}

String getLanguages(Data data) {
  String lang = "";
  for (int i = 0; i < data.languages.length; i++) {
    lang += data.languages[i].name!;
    if (i != data.skills.length - 1) {
      lang += ", ";
    }
  }
  return lang;
}
