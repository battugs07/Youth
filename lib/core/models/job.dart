class Job {
  int? id;
  String? title;
  String? description;
  int? user_id;
  String? duedate;
  int? howmanyhire;
  String? created_at;
  int? aimag_id;

  Job({this.id, this.title, this.description, this.user_id, this.duedate, this.howmanyhire, this.created_at, this.aimag_id});

  Job.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    title = parsedJson['title'];
    description = parsedJson['description'];
    user_id = parsedJson['user_id'];
    duedate = parsedJson['duedate'];
    howmanyhire = parsedJson['howmanyhire'];
    created_at = parsedJson['created_at'];
    aimag_id = parsedJson['aimag_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['user_id'] = user_id;
    data['duedate'] = duedate;
    data['howmanyhire'] = howmanyhire;
    data['created_at'] = created_at;
    data['aimag_id'] = aimag_id;
    return data;
  }
}
