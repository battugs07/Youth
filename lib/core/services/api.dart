import 'package:youth/core/models/Elearn.dart';
import 'package:youth/core/models/PodCast.dart';
import 'package:youth/core/models/contact.dart';
import 'package:youth/core/models/event.dart';
import 'package:youth/core/models/bag_khoroo.dart';
import 'package:youth/core/models/knowledge.dart';
import 'package:youth/core/models/law.dart';
import 'package:youth/core/models/soum.dart';
import 'package:youth/core/models/aimag.dart';
import 'package:youth/core/models/aimag_news.dart';
import 'package:youth/core/models/job.dart';
import 'package:youth/core/models/national_council.dart';
import 'package:youth/core/models/youth_council.dart';
import 'package:youth/core/models/resolution.dart';
import 'package:youth/core/models/staff.dart';
import 'package:lambda/modules/network_util.dart';
import 'package:youth/core/models/volunteer_work.dart';

class Api {
  NetworkUtil _http = new NetworkUtil();

  Future<String> getPaymentInfo() async {
    var response = await _http.get('/api/m/payment');
    return response["body"];
  }

  //Job
  List<Job> _job = [];
  List<Job> get jobList => _job;

  Future<void> getJobList() async {
    _job = [];

    final response = await _http.get('/mobile/api/getJobs/null');
    var parsed = response['data'];

    for (var item in parsed) {
      _job.add(Job.fromJson(item));
    }
  }

  /* NB */

  Future getNationalCouncil(aimagId, soumId) async {
    List<NationalCouncil> data = [];
    final response = await _http.post('/api/mobile/zxvz', {
      "search": "",
      "aimag": aimagId,
      "soum": soumId,
    });

    var parsed = response as List<dynamic>;

    for (var d in parsed) {
      data.add(NationalCouncil.fromJson(d));
    }
    return data;
  }

  Future getYouthCouncil(page, aimagId, soumId, bkhId) async {
    List<YouthCouncil> data = [];
    final response =
        await _http.post('/api/mobile/zxz?page=' + page.toString(), {"search": "", "aimag": aimagId, "soum": soumId, "bag-khoroo": bkhId});

    var parsed = response['data'];

    for (var y in parsed) {
      data.add(YouthCouncil.fromJson(y));
    }
    return data;
  }

  Future getAimagList() async {
    List<Aimag> data = [];

    final response = await _http.get('/api/mobile/aimag');
    var parsed = response;

    for (var item in parsed) {
      data.add(Aimag.fromJson(item));
    }

    return data;
  }

  Future getSoumList(int aimagId) async {
    List<Soum> data = [];

    final response = await _http.get('/api/mobile/soum/' + aimagId.toString());
    var parsed = response;

    for (var item in parsed) {
      data.add(Soum.fromJson(item));
    }

    return data;
  }

  Future getBagKhorooList(int soumId) async {
    List<BagKhoroo> data = [];

    final response = await _http.get('/api/mobile/bag-khoroo/' + soumId.toString());
    var parsed = response;

    for (var b in parsed) {
      data.add(BagKhoroo.fromJson(b));
    }

    return data;
  }

  Future getStaffList(aimagId) async {
    List<Staff> data = [];

    final response = await _http.get('/api/mobile/get-member-list/' + aimagId.toString());
    var parsed = response;

    for (var item in parsed) {
      data.add(Staff.fromJson(item));
    }

    return data;
  }

  Future getAimagNews(int aimagId, int page) async {
    List<AimagNews> data = [];

    final response = await _http.get('/api/mobile/get-news/' + aimagId.toString() + "?page=" + page.toString());
    var parsed = response['data'] as List<dynamic>;

    for (var news in parsed) {
      data.add(AimagNews.fromJson(news));
    }

    return data;
  }

  Future getData(int aimagId, int type, int page) async {
    List<Resolution> data = [];

    final response = await _http.get('/api/mobile/get-legals/' + aimagId.toString() + '/' + type.toString() + '?page=' + page.toString());

    var parsed = response['data'] as List<dynamic>;

    for (var r in parsed) {
      data.add(Resolution.fromJson(r));
    }

    return data;
  }

  Future getVolunteerWorks(int aimagId, int page) async {
    List<VolunteerWork> data = [];

    final response = await _http.get('/api/mobile/getVolunteers/' + aimagId.toString() + '?page=' + page.toString());

    var parsed = response['data']['data'] as List<dynamic>;

    for (var r in parsed) {
      data.add(VolunteerWork.fromJson(r));
    }

    return data;
  }

  Future getApiEvents(int aimagId, int page) async {
    List<Event> data = [];

    final response = await _http.get('/api/mobile/getEvents/' + aimagId.toString() + '?page=' + page.toString());

    var parsed = response['data']['data'] as List<dynamic>;

    for (var r in parsed) {
      data.add(Event.fromJson(r));
    }

    return data;
  }

  Future getApiLaws(int page) async {
    List<Law> data = [];

    final response = await _http.get('/api/mobile/getLegals?page=$page');

    var parsed = response['data']['data'] as List<dynamic>;

    for (var r in parsed) {
      data.add(Law.fromJson(r));
    }

    return data;
  }

  Future getApiKnowLedge(int page) async {
    List<KnowLedge> data = [];

    final response = await _http.get('/api/mobile/getKnowLedges?page=' + page.toString());

    var parsed = response['data']['data'] as List<dynamic>;

    for (var k in parsed) {
      data.add(KnowLedge.fromJson(k));
    }

    return data;
  }

  Future getApiElearn(int page) async {
    List<Elearn> data = [];

    final response = await _http.get('/api/mobile/getLessons?page=$page');
    var parsed = response['data']['data'];

    for (var k in parsed) {
      data.add(Elearn.fromJson(k));
    }

    return data;
  }

  Future getApiPodCast(int page) async {
    List<PodCast> data = [];

    final response = await _http.get('/api/mobile/getPodCasts?page=' + page.toString());

    var parsed = response['data']['data'] as List<dynamic>;

    for (var p in parsed) {
      data.add(PodCast.fromJson(p));
    }

    return data;
  }

  // Future getContactList() async {
  //   List<Contact> data = [];

  //   final response = await _http.get('/api/mobile/getContact');

  //   var parsed = response;

  //   for (var p in parsed) {
  //     data.add(Contact.fromJson(p));
  //   }

  //   return data;
  // }
}
