import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sms_auth1/Model/custom_utils.dart';
import 'package:flutter_sms_auth1/Model/salon_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';

//Un (with) mixin se refiere a  agregar las capacidades de otra clase o clases a nuestra propia clase, sin heredar de esas clases, pero pudinedo utilizar sus propiedades.
class HomeObservable with ChangeNotifier {
  String _selectedSubgroup = "cortes";
  List<SalonService> _servicesList = [];
  final Logger _log = Logger(
    printer: PrettyPrinter(),
  );

  String get selectedSubgroup => _selectedSubgroup;
  List<SalonService> get servicesList => _servicesList;

  set selectedSubgroup(String newSubgroup) {
    _selectedSubgroup = newSubgroup;
    notifyListeners();
  }

  callback(newSubgroup) {
    _selectedSubgroup = newSubgroup;
  }

  List<String> get servicesNames =>
      _servicesList.map((e) => e.name).toSet().toList();

  Future<List<SalonService>> getFirestoreServices() async {
    List<SalonService> sserviceList = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("SERVICES").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        sserviceList.add(SalonService.fromJson(result.data()));
      });
      print("SERVICES Rquest GET: ${sserviceList.toString()}");
    });
    return sserviceList;
  }

  SalonService getSalonserviceByName(String name) {
    return _servicesList.where((element) => element.name == name).toList()[0];
  }

  void initHome(context) {
    getFirestoreServices().then((data) => {
          internalAppDirectory.then((directory) => {
                writeFileAsString(directory.path.toString() + "/services.json",
                    data.toString()),
                readFileAsString(directory.path.toString() + "/services.json").then((content) => {
                  _servicesList = SalonService.fromJsonList(content.toString()).toList(),
                  print("decoded: ${_servicesList}")
                })
              })
        });
  }

  /*   reqPermissions(context).then((status) => {
          status.isGranted
              ? {
                  _log.i("Permission granted: ${status.toString()}"),
                  internalAppDirectory.then((directory) => {
                        fileExists(directory.path.toString() + "/services.json")
                            .then((fileExists) => {
                                  fileExists
                                      ? {
                                          _log.i("File /servies.json exists"),
                                          readFileAsString(
                                                  directory.path.toString() +
                                                      "/services.json")
                                              .then((fileResult) => {
                                                    _log.i("Read results from file: ${fileResult.toString()}")})
                                        }
                                      : {
                                          _log.w(
                                              "File /services.json does not exist"),
                                          getFirestoreServices(),
                                          writeFileAsString(
                                              directory.path.toString() +
                                                  "/services.json",
                                              _servicesList.toString()),
                                        }
                                })
                      })
                }
              : {
                  _log.i("Permission denied: ${status.toString()}"),
                }
        });
  } */
}
