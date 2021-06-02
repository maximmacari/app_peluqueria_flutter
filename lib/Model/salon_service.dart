import 'dart:convert';

import 'package:flutter/material.dart';

class SalonService {
  String _id;
  String _subgroup;
  String _name;
  String _duration;
  String _price;

  SalonService(
      {@required String id,
      @required String subgroup,
      @required String name,
      @required String duration,
      @required String price}) {
    this._id = id;
    this._subgroup = subgroup;
    this._name = name;
    this._duration = duration;
    this._price = price;
  }

  String get subgroup => this._subgroup;
  String get name => this._name;
  String get price => this._price;

  String get id => this._id;
  String get duration => this._duration;

  Color get subgroupColor {
    switch (this.subgroup) {
      case "cortes":
        return Colors.brown;
      case "peinados":
        return Colors.purple;
      case "tintes":
        return Colors.orange;
      case "mechas":
        return Colors.amber;
      case "decoloraciones":
        return const Color(0xffc0c0c0); // silver
      case "alisados":
        return Colors.pink;
      case "extensiones":
        return Colors.indigo;
      case "recogidos":
        return Colors.blue;
      case "tratamientos":
        return Colors.green;
      case "permanenetes":
        return Colors.cyan;
      case "maquillajes":
        return Colors.red;
      case "uñas":
        return Colors.yellow;
      default:
        return Colors.transparent;
    }
  }

  static List<SalonService> fromJsonList(String json) {
    final List parsedList = jsonDecode(json); 
    return parsedList.map((i) => SalonService.fromJson(i)).toList();
  } 

  factory SalonService.fromJson(Map<String, dynamic> json) => SalonService(
      id: json['Codigo'],
      subgroup: json['Subgrupo'],
      name: json['Nombre'],
      duration: json['Duracion'],
      price: json['Precio']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Codigo'] = this._id;
    data['Subgrupo'] = this._subgroup;
    data['Nombre'] = this._name;
    data['Duracion'] = this._duration;
    data['Precio'] = this._price;
    return data;
  }

  String toString() {
    return """{"Codigo": "$_id","Subgrupo": "$_subgroup","Nombre": "$_name","Duracion": "$_duration","Precio": "$_price"}""";
  }
}

class SalonServiceList {
  List<SalonService> salonServices;

  SalonServiceList(this.salonServices);

  factory SalonServiceList.fromJson(List<dynamic> json) {
    List<SalonService> services = [];
    services = json.map((i) => SalonService.fromJson(i)).toList();
    return new SalonServiceList(services);
  }
}

extension ListExt on List<SalonService> {
  List<SalonService> filterBySubgroupName(String name) {
    return this.where((element) => element._subgroup == name).toList();
  }

//TODO quitar
  List<SalonService> getUniqueSubgroup() {
    List<SalonService> _uniqueServices = [];
    for (final e in this) {
      if (int.parse(e.id.substring(e.id.length - 1)) == 0) {
        _uniqueServices.add(e);
      }
    }
    return _uniqueServices;
  }
}
