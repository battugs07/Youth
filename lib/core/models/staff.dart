class Staff {
  int? id;
  String? appointment;
  int? zxzId;
  int? position;
  String? lastname;
  String? firstname;
  int? status;
  String? phone;
  String? createdAt;
  String? updatedAt;
  String? image;
  String? description;
  int? msgSend;
  String? positionName;

  Staff(
      {this.id,
      this.appointment,
      this.zxzId,
      this.position,
      this.lastname,
      this.firstname,
      this.status,
      this.phone,
      this.createdAt,
      this.updatedAt,
      this.image,
      this.description,
      this.msgSend,
      this.positionName});

  Staff.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appointment = json['appointment'];
    zxzId = json['zxz_id'];
    position = json['position'];
    lastname = json['lastname'];
    firstname = json['firstname'];
    status = json['status'];
    phone = json['phone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    description = json['description'];
    msgSend = json['msg_send'];
    positionName = json['position_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['appointment'] = this.appointment;
    data['zxz_id'] = this.zxzId;
    data['position'] = this.position;
    data['lastname'] = this.lastname;
    data['firstname'] = this.firstname;
    data['status'] = this.status;
    data['phone'] = this.phone;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    data['description'] = this.description;
    data['msg_send'] = this.msgSend;
    data['position_name'] = this.positionName;
    return data;
  }
}
