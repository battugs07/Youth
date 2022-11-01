class Aimag {
  int? id;
  String? ner;
  String? code;
  int? busId;
  int? oldId;
  String? lat;
  String? lng;
  int? daraalal;
  int? square;
  int? deletedAt;

  Aimag({this.id, this.ner, this.code, this.busId, this.oldId, this.lat, this.lng, this.daraalal, this.square, this.deletedAt});

  Aimag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ner = json['ner'];
    code = json['code'];
    busId = json['bus_id'];
    oldId = json['old_id'];
    lat = json['lat'];
    lng = json['lng'];
    daraalal = json['daraalal'];
    square = json['square'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ner'] = this.ner;
    data['code'] = this.code;
    data['bus_id'] = this.busId;
    data['old_id'] = this.oldId;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['daraalal'] = this.daraalal;
    data['square'] = this.square;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
