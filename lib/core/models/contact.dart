class Contact {
  int? id;
  String? address;
  String? email;
  String? phone;
  String? fax;
  String? location;
  String? web;
  String? facebook;
  String? twitter;
  String? pinterest;
  String? google;
  String? instagram;
  String? googleAnalytics;
  String? facebookPixel;
  String? slogan;

  Contact(
      {this.id,
      this.address,
      this.email,
      this.phone,
      this.fax,
      this.location,
      this.web,
      this.facebook,
      this.twitter,
      this.pinterest,
      this.google,
      this.instagram,
      this.googleAnalytics,
      this.facebookPixel,
      this.slogan});

  Contact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    email = json['email'];
    phone = json['phone'];
    fax = json['fax'];
    location = json['location'];
    web = json['web'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    pinterest = json['pinterest'];
    google = json['google'];
    instagram = json['instagram'];
    googleAnalytics = json['google_analytics'];
    facebookPixel = json['facebook_pixel'];
    slogan = json['slogan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['fax'] = this.fax;
    data['location'] = this.location;
    data['web'] = this.web;
    data['facebook'] = this.facebook;
    data['twitter'] = this.twitter;
    data['pinterest'] = this.pinterest;
    data['google'] = this.google;
    data['instagram'] = this.instagram;
    data['google_analytics'] = this.googleAnalytics;
    data['facebook_pixel'] = this.facebookPixel;
    data['slogan'] = this.slogan;
    return data;
  }
}
