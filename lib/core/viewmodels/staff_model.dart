import 'package:youth/core/models/staff.dart';
import 'package:youth/core/services/staff_service.dart';
import 'base_model.dart';
import '../../locator.dart';

class StaffModel extends BaseModel {
  StaffService api = locator<StaffService>();
  List<Staff> get staffList => api.staffList;

  Future<void> getStaffList(aimagId) async {
    setLoading(true);
    await api.getStaff(aimagId);
    setLoading(false);
  }
}
