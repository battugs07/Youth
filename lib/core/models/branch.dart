class Branch {
  int? id;
  String? title;
  String? address;
  String? phone;
  String? email;
  String? location;
  String? photo;
  String? lat;
  String? lng;

  Branch({this.id, this.title, this.address, this.phone, this.email, this.location, this.photo, this.lat, this.lng});

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    location = json['location'];
    photo = json['photo'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['location'] = this.location;
    data['photo'] = this.photo;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}
