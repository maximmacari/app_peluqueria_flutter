import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sms_auth1/Model/custom_utils.dart';
import 'package:flutter_sms_auth1/Model/salon_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sms_auth1/Model/user_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';

//Un (with) mixin se refiere a  agregar las capacidades de otra clase o clases a nuestra propia clase, sin heredar de esas clases, pero pudinedo utilizar sus propiedades.
class HomeObservable with ChangeNotifier {
  List<SalonService> _servicesList = [];
  final Logger _log = Logger(
    printer: PrettyPrinter(),
  );

  String get selectedSubgroup => UserPreferences.getSelectedSubGroup().toString();
  List<SalonService> get servicesList => _servicesList;
  List<String> get servicesNames =>
      _servicesList.map((e) => e.name).toSet().toList();

  set selectedSubgroup(String newValue) {
    UserPreferences.setSelectedSubGroup(newValue);
    notifyListeners();
  }

  set servicesList(List<SalonService> newServices) {
    _servicesList = newServices;
    notifyListeners();
  }

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

  void _readServicesFile(String path) {
    readFileAsString(path).then((content) => {
          servicesList = SalonService.fromJsonList(content.toString()).toList(),
        });
  }

  void initHome(context) {
    String servicesFilePath;
    reqPermissions(context).then((status) => {
          status.isGranted
              ? {
                  _log.i("Permission granted: ${status.toString()}"),
                  internalAppDirectory.then((directory) => {
                        servicesFilePath =
                            directory.path.toString() + "/services.json",
                        fileExists(servicesFilePath).then((fileExists) => {
                              fileExists
                                  ? {
                                      _log.i("File /servies.json exists"),
                                      _readServicesFile(servicesFilePath)
                                    }
                                  : {
                                      _log.w(
                                          "File /services.json does not exist"),
                                      getFirestoreServices().then((data) => {
                                            writeFileAsString(servicesFilePath,
                                                data.toString()),
                                            _readServicesFile(servicesFilePath)
                                          })
                                    }
                            })
                      })
                }
              : {
                  _log.i("Permission denied: ${status.toString()}"),
                }
        });
  }
}
