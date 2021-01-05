// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..imageUrl = json['imageUrl'] as String
    ..geoLocalisation = json['geoLocalisation'] as String
    ..deleted = json['deleted'] as bool
    ..userEventDetails = (json['userEventDetails'] as List)
        ?.map((e) => e == null
            ? null
            : UserEventDetail.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..events = (json['events'] as List)
        ?.map(
            (e) => e == null ? null : Event.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'geoLocalisation': instance.geoLocalisation,
      'deleted': instance.deleted,
      'userEventDetails':
          instance.userEventDetails?.map((e) => e?.toJson())?.toList(),
      'events': instance.events?.map((e) => e?.toJson())?.toList(),
    };
