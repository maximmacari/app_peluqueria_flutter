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

  factory SalonService.fromJson(Map<String, dynamic> json)
    => SalonService(
        id: json['Codigo'],
        subgroup: json['Subgrupo'],
        name: json['Nombre'],
        duration: json['Duracion'],
        price: json['Precio']
  );

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
    return "id: $_id subgroup: $_subgroup name: $_name duration: $_duration price: $_price";
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

//TODO how to import json data  into firebase wiht node,
//TODO JSON read local file
