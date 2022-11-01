import 'package:youth/core/models/job.dart';
import 'package:youth/core/services/api.dart';
import 'base_model.dart';
import '../../locator.dart';

class JobModel extends BaseModel {
  Api api = locator<Api>();

  List<Job> get jobList => api.jobList;

  Future<void> getJob() async {
    setLoading(true);
    await api.getJobList();
    setLoading(false);
  }
}