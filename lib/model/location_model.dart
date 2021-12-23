class Location {
  Location({
    required this.httpStatus,
    required this.httpStatusCode,
    required this.success,
    required this.message,
    required this.apiName,
    required this.data,
  });
  late final String httpStatus;
  late final int httpStatusCode;
  late final bool success;
  late final String message;
  late final String apiName;
  late final List<Loc> data;

  Location.fromJson(Map<String, dynamic> json) {
    httpStatus = json['httpStatus'];
    httpStatusCode = json['httpStatusCode'];
    success = json['success'];
    message = json['message'];
    apiName = json['apiName'];
    data = json['data'] == null
        ? []
        : List.from(json['data']).map((e) => Loc.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['httpStatus'] = httpStatus;
    _data['httpStatusCode'] = httpStatusCode;
    _data['success'] = success;
    _data['message'] = message;
    _data['apiName'] = apiName;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Loc {
  Loc({
    required this.placeName,
    required this.placeId,
  });
  late final String placeName;
  late final String placeId;

  Loc.fromJson(Map<String, dynamic> json) {
    placeName = json['placeName'] ?? "";
    placeId = json['placeId'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['placeName'] = placeName;
    _data['placeId'] = placeId;
    return _data;
  }
}
