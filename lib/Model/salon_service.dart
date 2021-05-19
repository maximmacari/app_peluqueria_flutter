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

  String get id => _id;
  set id(String id) => _id = id;
  String get subgroup => _subgroup;
  set subgroup(String subgroup) => _subgroup = subgroup;
  String get name => _name;
  set name(String name) => _name = name;
  String get duration => _duration;
  set duration(String duration) => _duration = duration;
  String get price => _price;
  set price(String price) => _price = price;

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

class Services {
  List<SalonService> _salonServices;
  List<SalonService> _esteticaServices;

  Services({List<SalonService> SalonService, List<SalonService> esthetic}) {
    this._salonServices = SalonService;
    this._esteticaServices = esthetic;
  }

  List<SalonService> get SalonService => _salonServices;
  set SalonService(List<SalonService> SalonService) =>
      _salonServices = SalonService;
  List<SalonService> get esthetic => _esteticaServices;
  set esthetic(List<SalonService> esthetic) => _esteticaServices = esthetic;

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
