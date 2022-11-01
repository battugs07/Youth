import 'package:youth/core/models/soum.dart';
import '../../locator.dart';
import 'api.dart';

class SoumService {
  Api api = locator<Api>();

  List<Soum> _soumuud = [];
  List<Soum> get soumList => _soumuud;

  getSoumuud(aimagId) async {
    _soumuud = await api.getSoumList(aimagId);
  }
}
