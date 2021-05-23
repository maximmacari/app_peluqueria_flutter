
class SalonService {
  String _id;
  String _subgroup;
  String _name;
  String _duration;
  String _price;

  SalonService(
      {String id,
      String subgroup,
      String name,
      String duration,
      String price}) {
    this._id = id;
    this._subgroup = subgroup;
    this._name = name;
    this._duration = duration;
    this._price = price;
  }

  SalonService.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _subgroup = json['subgroup'];
    _name = json['name'];
    _duration = json['duration'];
    _price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['subgroup'] = this._subgroup;
    data['name'] = this._name;
    data['duration'] = this._duration;
    data['price'] = this._price;
    return data;
  }
}

/* class Services {
  List _salonServices;
  List _esteticaServices;

  Services({List SalonService, List esthetic}) {
    this._salonServices = SalonService;
    this._esteticaServices = esthetic;
  }

  List get SalonService => _salonServices;
  set SalonService(List SalonService) =>
      _salonServices = SalonService;
  List get esthetic => _esteticaServices;
  set esthetic(List esthetic) => _esteticaServices = esthetic;

  Services.fromJson(Map<String, dynamic> json) {
    if (json['SalonService'] != null) {
      _salonServices = [];
      json['SalonService'].forEach((v) {
        _salonServices.add(new SalonService.fromJson(v));
      });
    }
    if (json['Esthetic'] != null) {
      _esteticaServices = [];
      json['Esthetic'].forEach((v) {
        _esteticaServices.add(new SalonService.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._salonServices != null) {
      data['SalonService'] =
          this._salonServices.map((v) => v.toJson()).toList();
    }
    if (this._esteticaServices != null) {
      data['Esthetic'] = this._esteticaServices.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


 */