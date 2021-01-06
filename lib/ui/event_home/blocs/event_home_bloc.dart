import 'package:event_app/models/event.dart';
import 'package:event_app/repositories/event_repository.dart';
import 'package:event_app/ui/event_home/blocs/event_home_bloc_events.dart';
import 'package:rxdart/rxdart.dart';

class EventHomeBloc {
  /*static final instance = new EventHomeBloc();

  static EventHomeBloc getInstance() => instance;*/
  //Bloc Events
  var blocEvents = BehaviorSubject<EventHomeBlocEvents>();

  var eventService = EventService.getInstance();
  var datesSubject = BehaviorSubject<List<DateTime>>();
  var nearEventsSubject = BehaviorSubject<List<Event>>.seeded([]);
  var selectedDateTimeSubject = BehaviorSubject<DateTime>.seeded(DateTime.now());

  int performOperation(EventHomeBlocEvents event) {}

  EventHomeBloc() {
    allNearEvents();
    allDates();

    setupBlocListners();
  }

  void setupBlocListners() {
    blocEvents.listen((e) {
      e.when(dateChanged: (datetime) {
        print('dateChanged' + datetime.toString());
        if (datetime != null) {
          //update datetime
          selectedDateTimeSubject.sink.add(datetime);

          //filter near events for the same day of the datetime
          var events = eventService.eventsSubject.stream.value;
          events = events.where((element) => element.near == true && isSameDay(element.date)).toList();
          nearEventsSubject.sink.add(events);
        }
      }, nearEventsDelete: (id) {
        print('nearEventsDeletes' + id.toString());

        eventService.deleteById(id).then((value) {
          if(value>0){
            var events = eventService.eventsSubject.stream.value;
            var index= events.indexWhere((element) => element.id==id);
            if(index!=-1){
              events.removeAt(index);
              eventService.eventsSubject.sink.add(events);
            }

            EventHomeBlocEvents.dateChanged(selectedDateTimeSubject.stream.value);

          }
        });

      });
    });
  }


  bool isSameDay(DateTime dateTime) {
    var selectedDateTime = selectedDateTimeSubject.stream.value;
    if (selectedDateTime == null) {
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
    Future.delayed(Duration(seconds: 5), () {
      datesSubject.sink.add(datesValues);
    });
  }

  void allNearEvents() {
    List<Event> events = eventService.eventsSubject.value;
    if (events == null || events.isEmpty) {
      eventService.findAll().then((value) {
        if (value != null && !value.isEmpty) {
          events = value;
          events = events.where((element) => element.near == true && isSameDay(element.date)).toList();
          nearEventsSubject.sink.add(events);
        }
      });
    } else {
      events = events.where((element) => element.near == true && isSameDay(element.date)).toList();
      nearEventsSubject.sink.add(events);
    }
  }

  dispose() {
    datesSubject.close();
    nearEventsSubject.close();
    selectedDateTimeSubject.close();
  }

}
