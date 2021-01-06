import 'package:event_app/models/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_home_bloc_events.freezed.dart';

@freezed
abstract class EventHomeBlocEvents with _$EventHomeBlocEvents {

  const factory EventHomeBlocEvents.dateChanged(DateTime dateTime)=_DateChanged;
  const factory EventHomeBlocEvents.nearEventsDelete(int id)=_NearEventsDelete;

}
