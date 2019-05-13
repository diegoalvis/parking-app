import 'package:oneparking_citizen/data/api/zone_api.dart';
import 'package:oneparking_citizen/data/db/dao/config_dao.dart';
import 'package:oneparking_citizen/data/db/dao/event_dao.dart';
import 'package:oneparking_citizen/data/db/dao/schedule_dao.dart';
import 'package:oneparking_citizen/data/models/config.dart';
import 'package:oneparking_citizen/data/models/event.dart';
import 'package:oneparking_citizen/data/models/zone.dart';
import 'package:oneparking_citizen/util/error_codes.dart';

class ZoneRepository {
  ZoneApi _api;
  ScheduleDao _scheduleDao;
  EventDao _eventDao;
  ErrorCodes _errors;

  ZoneRepository(this._api, this._eventDao, this._scheduleDao, this._errors);

  Future<ZoneDes> getState(String idZone, String type) async {
    final event = await _eventDao.get(idZone);
    if (event != null) return ZoneDes(des: State.event, event: event);

    final now = DateTime.now();
    final mins = (now.hour * 60) + now.minute;
    final day = now.weekday - 1;

    final schedule = await  _scheduleDao.get(type, day, min: mins);
    if(schedule == null) return ZoneDes(des:State.timeout);

    final rspn = await _api.state(idZone);
    if (!rspn.success) _errors.validateError(rspn.error);

    return ZoneDes(des: State.active, state: rspn.data);
  }
}

enum State { active, event, timeout }

class ZoneDes {
  State des;
  Event event;
  ZoneState state;

  ZoneDes({this.des, this.event, this.state});
}
