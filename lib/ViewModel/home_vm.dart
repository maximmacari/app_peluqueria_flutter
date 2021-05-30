import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms_auth1/Model/custom_utils.dart';
import 'package:flutter_sms_auth1/Model/salon_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sms_auth1/Model/salon_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:flutter_sms_auth1/Shared/custom_extensions.dart';

//Un (with) mixin se refiere a  agregar las capacidades de otra clase o clases a nuestra propia clase, sin heredar de esas clases, pero pudinedo utilizar sus propiedades.
class HomeObservable with ChangeNotifier {
  String _selectedSubgroup = "cortes";
  List<SalonService> _servicesList = [];
  Logger _log = Logger("HomeScreen");

  String get selectedSubgroup => _selectedSubgroup;
  List<SalonService> get servicesList => _servicesList;

  set selectedSubgroup(String newSubgroup) {
    _selectedSubgroup = newSubgroup;
    notifyListeners();
  }

  callback(newSubgroup) {
    _selectedSubgroup = newSubgroup;
  }

  List<String> get servicesNames => _servicesList.map((e) => e.name.capitalized()).toSet().toList();

  void getFirestoreServices() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection("SERVICES").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        _servicesList
            .add(SalonService.fromJson(result.data()));
      });
    });
  }

  SalonService getSalonserviceByName(String name){
    return _servicesList.where((element) => element.name == name).toList()[0];
  }

  void initHome(context) {
    reqPermissions(context).then((status) => {
          status.isGranted
              ? {
                  _log.info("Permission granted: ${status.toString()}"),
                  mainDirectory.then((directory) => {
                        fileExists(directory.path.toString() + "/services.json")
                            .then((fileExists) => {
                                  fileExists
                                      ? {
                                          _log.info(
                                              "File /servies.json exists"),
                                          readFileAsString(
                                                  directory.path.toString() +
                                                      "/services.json")
                                              .then((fileResult) => {
                                                    _log.info(
                                                        "Read results from file: ${fileResult.toString()}")
                                                  })
                                        }
                                      : {
                                          _log.warning(
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
                  _log.info("Permission denied: ${status.toString()}"),
                }
        });
  }

/* 
  //Not really needed //TODO quitar
  Future<void> _signOut() async {
    final _authFirebase = FirebaseAuth.instance; 
    try {
      if (_authFirebase.currentUser != null) {
        await _authFirebase.signOut();
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Screen.LOGIN, (route) => false);
      }
    } catch (err) {
      OkAlertDialog("Error", "Ha habido un error: ${err.toString()}",
          () => {Navigator.of(context).pop()});
    }
  } */

}
