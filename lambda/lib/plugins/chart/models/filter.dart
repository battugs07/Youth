class Filter {
  String? column;
  String? condition;
  String? value;

  Filter({this.column, this.condition, this.value});

  Filter.fromJson(Map<String, dynamic> json) {
    column = json['column'];
    condition = json['condition'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['column'] = this.column;
    data['condition'] = this.condition;
    data['value'] = this.value;
    return data;
  }
}
