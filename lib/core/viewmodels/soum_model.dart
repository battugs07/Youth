import 'package:youth/core/models/soum.dart';
import 'package:youth/core/services/soum_service.dart';

import 'base_model.dart';
import '../../locator.dart';

class SoumModel extends BaseModel {
  SoumService api = locator<SoumService>();
  List<Soum> get soumList => api.soumList;

  Future<void> getSoumModelList(aimagId) async {
    setLoading(true);
    await api.getSoumuud(aimagId);
    setLoading(false);
  }
}
