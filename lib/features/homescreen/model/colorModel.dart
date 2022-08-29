import 'package:flutter/material.dart';

import 'dart:convert';

List<BarColor> barColorFromJson(String str) =>
    List<BarColor>.from(json.decode(str).map((x) => BarColor.fromJson(x)));

String barColorToJson(List<BarColor> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BarColor {
  BarColor({
    required this.color,
    required this.height,
  });

  Color color;
  double height;

  factory BarColor.fromJson(Map<String, dynamic> json) => BarColor(
        color: json["color"],
        height: json["height"],
      );

  Map<String, dynamic> toJson() => {
        "color": color,
        "height": height,
      };
}

List<FileList> fileListFromJson(String str) =>
    List<FileList>.from(json.decode(str).map((x) => FileList.fromJson(x)));

String fileListToJson(List<FileList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FileList {
  FileList({
    required this.filePath,
    required this.fileName,
  });

  String filePath;
  String fileName;

  factory FileList.fromJson(Map<String, dynamic> json) => FileList(
        filePath: json["filePath"],
        fileName: json["fileName"],
      );

  Map<String, dynamic> toJson() => {
        "filePath": filePath,
        "fileName": fileName,
      };
}
