import 'package:event_app/models/event.dart';
import 'package:event_app/services/EventService.dart';
import 'package:rxdart/rxdart.dart';
enum EventHomeBlocEvents{
  SELECT_DATE,
  NONE,
}

class EventHomeBloc {
  /*static final instance = new EventHomeBloc();

  static EventHomeBloc getInstance() => instance;*/
  var blocEvents=BehaviorSubject<EventHomeBlocEvents>.seeded(EventHomeBlocEvents.NONE);

  var eventService = EventService.getInstance();
  var datesSubject = BehaviorSubject<List<DateTime>>();
  var nearEventsSubject = BehaviorSubject<List<Event>>.seeded([]);
  var selectedDateTimeSubject = BehaviorSubject<DateTime>.seeded(DateTime.now());

  EventHomeBloc() {
    allNearEvents();
    allDates();
    print('EventHomeBloc constructor');

    blocEvents.listen((value) {
      switch(value){
        case EventHomeBlocEvents.SELECT_DATE:
          break;
      }
    });

    selectedDateTimeSubject.listen((value) {
      if (value != null) {
        print('selectedDateTimeSubject');
        var events= eventService.eventsSubject.stream.value;
        events = events.where((element) => element.near == true && isSameDay(element.date)).toList();
        nearEventsSubject.sink.add(events);
      }
    });
  }

  bool isSameDay(DateTime dateTime) {
    var selectedDateTime=selectedDateTimeSubject.stream.value;
    if(selectedDateTime==null){
      return false;
    }
    return selectedDateTime.year == dateTime.year && selectedDateTime.month == dateTime.month && selectedDateTime.day == dateTime.day;
  }

  void allDates() {
    List<DateTime> datesValues = datesSubject.stream.value;

    DateTime dateTime = DateTime.now();
    int numberDays = 40;
    if (datesValues == null || datesValues.isEmpty) {
      datesValues = [];
      for (int i = 0; i < numberDays; i++) {
        DateTime currentDateTime = dateTime.add(Duration(days: i - 2));
        datesValues.add(currentDateTime);
      }
    }
    Future.delayed(Duration(seconds: 5),(){
      datesSubject.sink.add(datesValues);
    });
  }

  void allNearEvents() {
    List<Event> events = eventService.eventsSubject.value;
    if (events == null || events.isEmpty) {
      eventService.findAll().then((value) {
        if (value != null && !value.isEmpty) {
          events = value;
          nearEventsSubject.sink.add(events.where((element) => element.near == true).toList());
        }
      });
    } else {
      nearEventsSubject.sink.add(events.where((element) => element.near == true).toList());
    }
  }

  dispose(){
    datesSubject.close();
    nearEventsSubject.close();
    selectedDateTimeSubject.close();
  }
}
