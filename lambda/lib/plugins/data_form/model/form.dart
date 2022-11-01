class OfflineFormData {
  int? id;
  String? schemaId;
  int? synced;
  String? data;
  String? schema;
  String? formName;
  String? date;

  OfflineFormData(this.id, this.schemaId, this.synced, this.data, this.schema,
      this.formName, this.date);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'schemaId': schemaId,
      'synced': synced,
      'data': data,
      'schema': schema,
      'formName': formName,
      'date': date,
    };
    return map;
  }

  OfflineFormData.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    schemaId = map['schemaId'];
    synced = map['synced'];
    data = map['data'];
    schema = map['schema'];
    formName = map['formName'];
    date = map['date'];
  }
}
