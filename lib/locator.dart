// import 'package:get_it/get_it.dart';
import 'package:get_it/get_it.dart';
import 'package:lambda/modules/agent/agent_controller.dart';
import 'package:lambda/modules/gcm/notify.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:youth/core/services/aimag_news_service.dart';
import 'package:youth/core/services/elearn_service.dart';
import 'package:youth/core/services/event_service.dart';
import 'package:youth/core/services/podcast_service.dart';
import 'package:youth/core/services/resolution_service.dart';
import 'package:youth/core/services/volunteer_work_service.dart';
import 'package:youth/core/viewmodels/aimag_news_model.dart';
import 'package:youth/core/viewmodels/elearn_model.dart';
import 'package:youth/core/viewmodels/podcast_model.dart';
import 'package:youth/core/viewmodels/resolution_model.dart';
import 'package:youth/core/viewmodels/volunteer_work_model.dart';
import 'core/services/aimag_service.dart';
import 'core/services/knowledge_service.dart';
import 'core/services/law_service.dart';
import 'core/services/national_council_service.dart';
import 'core/services/youth_council_service.dart';
import 'core/services/soum_service.dart';
import 'core/services/bag_khoroo_service.dart';
import 'core/services/staff_service.dart';
import 'core/services/user_service.dart';
import 'core/services/api.dart';
import 'core/viewmodels/aimag_model.dart';
import 'core/viewmodels/base_model.dart';
import 'core/viewmodels/job_model.dart';
import 'core/viewmodels/knowledge_model.dart';
import 'core/viewmodels/law_model.dart';
import 'core/viewmodels/soum_model.dart';
import 'core/viewmodels/bag_khoroo_model.dart';
import 'core/viewmodels/staff_model.dart';
import 'core/viewmodels/user_model.dart';
import 'core/viewmodels/national_council_model.dart';
import 'core/viewmodels/youth_council_model.dart';
import 'core/viewmodels/event_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  //Basic services
  locator.registerSingleton<Notify>(new Notify());
  locator.registerSingleton<AgentController>(new AgentController());
  locator.registerSingleton<NetworkUtil>(new NetworkUtil());

  //App services for data fetch
  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => NationalCouncilService());
  locator.registerLazySingleton(() => YouthCouncilService());
  locator.registerLazySingleton(() => AimagService());
  locator.registerLazySingleton(() => SoumService());
  locator.registerLazySingleton(() => BagKhorooService());
  locator.registerLazySingleton(() => StaffService());
  locator.registerLazySingleton(() => AimagNewsService());
  locator.registerLazySingleton(() => ResolutionService());
  locator.registerLazySingleton(() => VolunteerWorkService());
  locator.registerLazySingleton(() => EventService());
  locator.registerLazySingleton(() => LawService());
  locator.registerLazySingleton(() => KnowLedgeService());
  locator.registerLazySingleton(() => ElearnService());
  locator.registerLazySingleton(() => PodCastService());

  //App view models for busines logic
  locator.registerFactory(() => BaseModel());
  locator.registerFactory(() => UserModel());
  locator.registerFactory(() => JobModel());
  locator.registerFactory(() => NationalCouncilModel());
  locator.registerFactory(() => YouthCouncilModel());
  locator.registerFactory(() => AimagModel());
  locator.registerFactory(() => SoumModel());
  locator.registerFactory(() => BagKhorooModel());
  locator.registerFactory(() => StaffModel());
  locator.registerFactory(() => AimagNewsModel());
  locator.registerFactory(() => ResolutionModel());
  locator.registerFactory(() => VolunteerWorkModel());
  locator.registerFactory(() => EventModel());
  locator.registerFactory(() => LawModel());
  locator.registerFactory(() => KnowLedgeModel());
  locator.registerFactory(() => ElearnModel());
  locator.registerFactory(() => PodCastModel());
}
