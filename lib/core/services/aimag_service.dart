import 'package:youth/core/models/aimag.dart';
import '../../locator.dart';
import 'api.dart';

class AimagService {
  Api api = locator<Api>();

  //List<Object>
  List<Aimag> _aimaguud = [];

  List<Aimag> get aimagList => _aimaguud;

  getAimags() async {
    _aimaguud = await api.getAimagList();
  }
}
