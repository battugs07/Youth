class BagKhoroo {
  int? id;
  String? ner;
  String? code;
  int? sumDuuregId;
  int? oldId;
  int? aimagId;
  int? square;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  BagKhoroo({this.id, this.ner, this.code, this.sumDuuregId, this.oldId, this.aimagId, this.square, this.deletedAt, this.createdAt, this.updatedAt});

  BagKhoroo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ner = json['ner'];
    code = json['code'];
    sumDuuregId = json['sum_duureg_id'];
    oldId = json['old_id'];
    aimagId = json['aimag_id'];
    square = json['square'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ner'] = this.ner;
    data['code'] = this.code;
    data['sum_duureg_id'] = this.sumDuuregId;
    data['old_id'] = this.oldId;
    data['aimag_id'] = this.aimagId;
    data['square'] = this.square;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
