// To parse this JSON data, do
//
//     final modelList = modelListFromJson(jsonString);
import 'dart:convert';

ModelList modelListFromJson(String str) => ModelList.fromJson(json.decode(str));
String modelListToJson(ModelList data) => json.encode(data.toJson());

class ModelList {
  ModelList({
    required this.count,
    required this.entries,
  });
  int count;
  List<Entry> entries;
  factory ModelList.fromJson(Map json) => ModelList(
    count: json["count"],
    entries: List.from(json["entries"].map((x) => Entry.fromJson(x))),
  );
  Map toJson() => {
    "count": count,
    "entries": List.from(entries.map((x) => x.toJson())),
  };
}

class Entry {
  Entry({
    required this.api,
    required this.description,
    required this.auth,
    required this.https,
    required this.cors,
    required this.link,
    required this.category,
  });
  String api;
  String description;
  Auth? auth;
  bool https;
  Cors? cors;
  String link;
  String category;
  factory Entry.fromJson(Map json) => Entry(
    api: json["API"],
    description: json["Description"],
    auth: authValues.map[json["Auth"]],
    https: json["HTTPS"],
    cors: corsValues.map[json["Cors"]],
    link: json["Link"],
    category: json["Category"],
  );
  Map toJson() => {
    "API": api,
    "Description": description,
    "Auth": authValues.reverse[auth],
    "HTTPS": https,
    "Cors": corsValues.reverse[cors],
    "Link": link,
    "Category": category,
  };
}

enum Auth { API_KEY, EMPTY, O_AUTH, X_MASHAPE_KEY, USER_AGENT }

final authValues = EnumValues({
  "apiKey": Auth.API_KEY,
  "": Auth.EMPTY,
  "OAuth": Auth.O_AUTH,
  "User-Agent": Auth.USER_AGENT,
  "X-Mashape-Key": Auth.X_MASHAPE_KEY
});

enum Cors { yes, no, unknown, unkown }

final corsValues = EnumValues({
  "no": Cors.no,
  "unknown": Cors.unknown,
  "unkown": Cors.unkown,
  "yes": Cors.yes
});

class EnumValues<T> {
  Map<String, T> map = {};
  Map<T, String> reverseMap = {};
  EnumValues(this.map);
  Map<T, String> get reverse {
    reverseMap;
    return reverseMap;
  }
}
// To parse this JSON data, do
//
//     final new = newFromJson(jsonString);


