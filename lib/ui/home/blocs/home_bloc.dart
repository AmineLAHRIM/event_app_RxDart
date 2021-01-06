import 'dart:async';

import 'package:event_app/models/event.dart';
import 'package:event_app/repositories/event_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

/*enum HomeBlocEvents {
  FETCH_FIRST_NEAR_EVENT,
  FETCH_EVENTS,
  DELETE_EVENT,
}*/

class HomeBloc {
  //Bloc Event
  //var blocEvent = BehaviorSubject<HomeBlocEvents>();

  EventService eventService=EventService.getInstance();

  // Events
  HomeBloc() {
    eventService.findAll();
    eventService.firstNear();
    print('HomeBloc Constructor');
    /*switch (blocEvent.stream.value) {
      case HomeBlocEvents.FETCH_FIRST_NEAR_EVENT:
        fetchFistNearEvent();
        break;
      case HomeBlocEvents.FETCH_EVENTS:
        break;
      case HomeBlocEvents.DELETE_EVENT:
        break;
    }*/
  }



  dispose() {
    //blocEvent.close();
  }
}
