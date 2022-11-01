import 'package:youth/core/models/staff.dart';
import '../../locator.dart';
import 'api.dart';

class StaffService {
  Api api = locator<Api>();

  List<Staff> _staffs = [];
  List<Staff> get staffList => _staffs;

  getStaff(aimagId) async {
    _staffs = await api.getStaffList(aimagId);
  }
}
