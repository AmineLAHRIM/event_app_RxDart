import 'dart:convert';

import 'package:event_app/models/message_error.dart';
import 'package:flutter/material.dart';

import 'package:event_app/constant.dart';
import 'package:event_app/models/event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class EventService {
  var eventsSubject = BehaviorSubject<List<Event>>();
  var firstNearEventSubject = BehaviorSubject<Event>();
  var messageErrorSubject = BehaviorSubject<MessageError>();

  static final EventService instance=EventService();

  static EventService getInstance() {
    return instance;
  }

  EventService() {
    print('EventService Consturctor');
    eventsSubject.listen((value) {
      if (value != null && !value.isEmpty) {
        messageErrorSubject.sink.add(MessageError(message: "Yes It\'s Work", messageType: MessageType.success));
      }else{
        messageErrorSubject.sink.add(MessageError(message: "Yes It\'s Work But It\'s Empty", messageType: MessageType.warning));
      }
    });
  }


  Future<List<Event>> findAll() async {
    var response = await http.get(Constant.REST_URL + '/event/');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      var events = data.map((e) => Event.fromJson(e)).toList();
      eventsSubject.sink.add(events);
      return events;
    } else {
      throw Exception('No Data Found');
    }
  }

  void firstNear() async {
    var events = eventsSubject.stream.value;

    if (events == null || events.isEmpty) {
      print('fistNear findall');
      await findAll();
    }
    Event latestEventNear = eventsSubject.stream.value.firstWhere((element) => element.near == true);
    firstNearEventSubject.sink.add(latestEventNear);
  }


  Future<Event> findById(int id) async {
    print('id==findById' + id.toString());

    var response = await http.get(Constant.REST_URL + '/event/' + id.toString());

    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body);
      Event currentEvent = Event.fromJson(data);
      print('id==findById currentEvent');
      return currentEvent;
    } else {
      print('id==findById error');
      throw Exception('No Data Found');
    }
  }

  Future<Event> add(Event event) async {
    var response = await http.post(Constant.REST_URL + '/event/', headers: {'Content-Type': 'application/json'}, body: json.encode(event.toJson()));

    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body);
      Event newEvent = Event.fromJson(data);
      return newEvent;
    } else {
      throw Exception('No Data Found');
    }
  }

  Future<Event> update(int id, Event event) async {
    var response = await http.put(Constant.REST_URL + '/event/' + id.toString(), headers: {'Content-Type': 'application/json'}, body: json.encode(event.toJson()));

    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body);
      Event newEvent = Event.fromJson(data);
      return newEvent;
    } else {
      throw Exception('No Data Found');
    }
  }

  delete(int id) {
    var events = eventsSubject.stream.value;
    print('1/');
    print('delete events' + events.length.toString());
    events.removeAt(events.indexWhere((element) => element.id == id));
    eventsSubject.sink.add(events);
    print('2/');
    print('delete events' + events.length.toString());
  }

  change(int id) {
    var events = eventsSubject.stream.value;
    print('1/');
    print('change events' + events.length.toString());
    events.firstWhere((element) => element.id == id).name = 'Amine LAHRIM';
    eventsSubject.sink.add(events);
    print('2/');
    print('change events' + events.length.toString());
  }

  Future<int> deleteById(int id) async {
    var response = await http.delete(
      Constant.REST_URL + '/event/' + id.toString(),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      int data = json.decode(response.body);

      return data;
    } else {
      throw Exception('No Data Found');
    }
  }



  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
