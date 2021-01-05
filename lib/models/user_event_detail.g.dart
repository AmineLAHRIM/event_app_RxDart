// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_event_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEventDetail _$UserEventDetailFromJson(Map<String, dynamic> json) {
  return UserEventDetail()
    ..id = json['id'] as int
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>)
    ..event = json['event'] == null
        ? null
        : Event.fromJson(json['event'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UserEventDetailToJson(UserEventDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user?.toJson(),
      'event': instance.event?.toJson(),
    };
