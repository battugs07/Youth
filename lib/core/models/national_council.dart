class NationalCouncil {
  int? id;
  String? name;
  int? aimag;
  int? soum;
  int? khoroo;
  String? agentlagName;
  String? helber;
  String? organization;
  String? slogan;
  String? introduction;
  String? logo;
  String? zuvlulType;
  String? createdAt;
  String? updatedAt;
  int? secrataryId;
  int? status;
  int? viewed;
  String? description;
  int? memberCount;
  String? qr;

  NationalCouncil(
      {this.id,
      this.name,
      this.aimag,
      this.soum,
      this.khoroo,
      this.agentlagName,
      this.helber,
      this.organization,
      this.slogan,
      this.introduction,
      this.logo,
      this.zuvlulType,
      this.createdAt,
      this.updatedAt,
      this.secrataryId,
      this.status,
      this.viewed,
      this.description,
      this.memberCount,
      this.qr});

  NationalCouncil.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    aimag = json['aimag'];
    soum = json['soum'];
    khoroo = json['khoroo'];
    agentlagName = json['agentlag_name'];
    helber = json['helber'];
    organization = json['organization'];
    slogan = json['slogan'];
    introduction = json['introduction'];
    logo = json['logo'];
    zuvlulType = json['zuvlul_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    secrataryId = json['secratary_id'];
    status = json['status'];
    viewed = json['viewed'];
    description = json['description'];
    memberCount = json['memberCount'];
    qr = json['qr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['aimag'] = this.aimag;
    data['soum'] = this.soum;
    data['khoroo'] = this.khoroo;
    data['agentlag_name'] = this.agentlagName;
    data['helber'] = this.helber;
    data['organization'] = this.organization;
    data['slogan'] = this.slogan;
    data['introduction'] = this.introduction;
    data['logo'] = this.logo;
    data['zuvlul_type'] = this.zuvlulType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['secratary_id'] = this.secrataryId;
    data['status'] = this.status;
    data['viewed'] = this.viewed;
    data['description'] = this.description;
    data['memberCount'] = this.memberCount;
    data['qr'] = this.qr;
    return data;
  }
}
