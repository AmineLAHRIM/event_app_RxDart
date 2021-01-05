// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..address = json['address'] as String
    ..date =
        json['date'] == null ? null : DateTime.parse(json['date'] as String)
    ..imageUrl = json['imageUrl'] as String
    ..price = (json['price'] as num)?.toDouble()
    ..description = json['description'] as String
    ..near = json['near'] as bool
    ..deleted = json['deleted'] as bool
    ..userEventDetails = (json['userEventDetails'] as List)
        ?.map((e) => e == null
            ? null
            : UserEventDetail.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..tickets = (json['tickets'] as List)
        ?.map((e) =>
            e == null ? null : Ticket.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..users = (json['users'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'date': instance.date?.toIso8601String(),
      'imageUrl': instance.imageUrl,
      'price': instance.price,
      'description': instance.description,
      'near': instance.near,
      'deleted': instance.deleted,
      'userEventDetails':
          instance.userEventDetails?.map((e) => e?.toJson())?.toList(),
      'tickets': instance.tickets?.map((e) => e?.toJson())?.toList(),
      'users': instance.users?.map((e) => e?.toJson())?.toList(),
    };
