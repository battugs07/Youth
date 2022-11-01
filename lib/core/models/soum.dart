class Soum {
  int? id;
  String? ner;
  String? code;
  int? aimagId;
  int? oldId;
  String? lat;
  String? lng;
  int? square;
  int? duureg;
  int? deletedAt;

  Soum({this.id, this.ner, this.code, this.aimagId, this.oldId, this.lat, this.lng, this.square, this.duureg, this.deletedAt});

  Soum.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ner = json['ner'];
    code = json['code'];
    aimagId = json['aimag_id'];
    oldId = json['old_id'];
    lat = json['lat'];
    lng = json['lng'];
    square = json['square'];
    duureg = json['duureg'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ner'] = this.ner;
    data['code'] = this.code;
    data['aimag_id'] = this.aimagId;
    data['old_id'] = this.oldId;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['square'] = this.square;
    data['duureg'] = this.duureg;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
