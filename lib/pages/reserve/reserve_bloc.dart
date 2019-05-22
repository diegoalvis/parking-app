import 'package:bloc/bloc.dart';
import 'package:oneparking_citizen/data/repository/reserve_repository.dart';
import 'package:oneparking_citizen/util/error_codes.dart';
import 'package:oneparking_citizen/util/state-util.dart';
import 'package:rxdart/rxdart.dart';

class ReserveBloc extends Bloc<ReserveEvent, BaseState> {
  static const STOP_INTENTS = 3;

  ReserveRepository _repository;

  int retryIntents = STOP_INTENTS;

  final _valueSubject = PublishSubject<int>();
  Stream<int> get valueStream => _valueSubject.stream;

  final _errorSubject = PublishSubject<String>();
  Stream<String> get errorStream => _errorSubject.stream;

  ReserveBloc(this._repository);

  @override
  void dispose() {
    _valueSubject.close();
    _errorSubject.close();
    super.dispose();
  }

  @override
  BaseState get initialState => InitialState();

  @override
  Stream<BaseState> mapEventToState(ReserveEvent event) async* {
    try {
      switch (event.event) {
        case ReserveEventType.getActive:
          yield LoadingState();
          final reserve = await _repository.current();
          if (reserve == null || reserve.date == null) {
            yield NoReservesState();
          } else {
            yield SuccessState(data: reserve);
            final time = DateTime.now().difference(reserve.date);
            //final time = Duration(hours: 3, minutes: 59, seconds: 52);
            final value = await _repository.getValue(timeInMinutes: time.inMinutes);
            _valueSubject.sink.add(value);
          }
          break;
        case ReserveEventType.stop:
          retryIntents--;
          if (retryIntents == 0) {
            await _repository.forceStop();
            yield FinishReserveState();
            break;
          }
          await _repository.stop();
          yield FinishReserveState();
          break;
        case ReserveEventType.getValue:
          final value = await _repository.getValue(timeInMinutes: event.data as int);
          _valueSubject.sink.add(value);
          break;
      }
    } on Exception catch (e) {
      if (e is StopReserveException) {
        _errorSubject.sink.add(e.cause);
        return;
      }
      yield ErrorState(errorMessage(e));
      await Future.delayed(Duration(seconds: 1));
      yield InitialState();
    }
  }
}

enum ReserveEventType { stop, getActive, getValue }

class ReserveEvent<T> {
  final ReserveEventType event;
  final T data;

  ReserveEvent(this.event, {this.data});
}

class FinishReserveState extends BaseState {
  @override
  String toString() => 'state-finish-reserve';
}

class NoReservesState extends BaseState {
  @override
  String toString() => 'state-no-reserves';
}