import 'package:youth/core/models/bag_khoroo.dart';
import '../../locator.dart';
import 'api.dart';

class BagKhorooService {
  Api api = locator<Api>();

  //List<Object>
  List<BagKhoroo> _bagKhorood = [];

  List<BagKhoroo> get bagKhorooList => _bagKhorood;

  getBagKhooList(soumId) async {
    _bagKhorood = await api.getBagKhorooList(soumId);
  }
}
