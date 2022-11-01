class VolunteerWork {
  int? id;
  String? name;
  String? startdate;
  String? enddate;
  String? image;
  int? personcount;
  int? userId;
  String? createdAt;
  String? address;
  String? works;
  String? description;
  int? aimagId;

  VolunteerWork(
      {this.id,
      this.name,
      this.startdate,
      this.enddate,
      this.image,
      this.personcount,
      this.userId,
      this.createdAt,
      this.address,
      this.works,
      this.description,
      this.aimagId});

  VolunteerWork.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    startdate = json['startdate'];
    enddate = json['enddate'];
    image = json['image'];
    personcount = json['personcount'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    address = json['address'];
    works = json['works'];
    description = json['description'];
    aimagId = json['aimag_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['startdate'] = this.startdate;
    data['enddate'] = this.enddate;
    data['image'] = this.image;
    data['personcount'] = this.personcount;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['address'] = this.address;
    data['works'] = this.works;
    data['description'] = this.description;
    data['aimag_id'] = this.aimagId;
    return data;
  }
}
