import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oneparking_citizen/data/models/zone.dart';
import 'package:oneparking_citizen/data/repository/reserve_repository.dart';
import 'package:oneparking_citizen/pages/main/zone/zone_dialog_events.dart';
import 'package:oneparking_citizen/pages/main/zone/zone_dialog_states.dart';
import 'package:oneparking_citizen/util/error_codes.dart';
import 'package:oneparking_citizen/util/state-util.dart';

class ZoneReserveBloc extends Bloc<ReserveZone, BaseState> {
  ReserveRepository _reserve;

  ZoneReserveBloc(this._reserve);

  @override
  BaseState get initialState => InitialState();

  @override
  Stream<BaseState> mapEventToState(ReserveZone event) async* {
    yield* _reserveZone(event.zone, event.disability);
  }

  Stream<BaseState> _reserveZone(Zone zone, bool disability) async* {
    try {
      yield LoadingReserveState();
      await _reserve.start(
          zone.idZone, zone.name, zone.address, zone.code, disability,
          LatLng(zone.lat, zone.lon));
      yield SuccessReserveState();
    } on Exception catch (e) {
      if (e is AppException) {
        yield ErrorReserveState(e.cause);
      } else {
        yield ErrorReserveState("Error al reservar, intenta de nuevo");
      }
      await Future.delayed(Duration(seconds: 1));
      yield InitialState();
    }
  }
}
