import 'package:youth/core/models/bag_khoroo.dart';
import 'package:youth/core/services/bag_khoroo_service.dart';

import 'base_model.dart';
import '../../locator.dart';

class BagKhorooModel extends BaseModel {
  BagKhorooService api = locator<BagKhorooService>();
  List<BagKhoroo> get bagKhorooList => api.bagKhorooList;

  Future<void> getBagKhoroolList(soumId) async {
    setLoading(true);
    await api.getBagKhooList(soumId);
    setLoading(false);
  }
}
