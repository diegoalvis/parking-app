import 'package:dio/dio.dart';
import 'package:oneparking_citizen/data/api/base_api.dart';
import 'package:oneparking_citizen/data/api/model/rspn.dart';
import 'package:oneparking_citizen/data/preferences/user_session.dart';
import 'package:oneparking_citizen/util/http_util.dart';

import 'model/state_info.dart';

class ZoneApi extends BaseApi{

  ZoneApi(Dio dio, UserSession session) : super(dio, session);

  Future<Rspn<StateInfo>> state(String id) async{
      Response response = await get('/zones/$id/state');
      return validate(response, parseZoneState);
  }

}

StateInfo parseZoneState(Map<String, dynamic> json){
  return StateInfo.fromJson(json);
}