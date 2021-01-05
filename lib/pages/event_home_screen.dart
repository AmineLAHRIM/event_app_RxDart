import 'package:align_positioned/align_positioned.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/blocs/event_home_bloc.dart';
import 'package:event_app/blocs/home_bloc.dart';
import 'package:event_app/models/event.dart';
import 'package:event_app/services/EventService.dart';
import 'package:event_app/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventHomeScreen extends StatelessWidget {
  static final String routeName = '/event-home';

  EventService eventService = EventService.getInstance();
  EventHomeBloc eventHomeBloc = EventHomeBloc();

  void onSelectedDate(DateTime currentDateTime) {
    eventHomeBloc.selectedDateTimeSubject.sink.add(currentDateTime);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiLight);
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                flex: 10,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 20,
                        child: InkResponse(
                          splashFactory: InkRipple.splashFactory,
                          onTap: () => null,
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 16),
                            child: SvgPicture.asset('assets/images/menu.svg'),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 60,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                          child: FittedBox(
                            child: Text(
                              'Event',
                              style: Theme.of(context).textTheme.headline5,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 20,
                        child: InkResponse(
                          splashFactory: InkRipple.splashFactory,
                          onTap: () => null,
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                              child: SvgPicture.asset('assets/images/icon_notification_fill.svg'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  child: FittedBox(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Discover with \nupcoming events.',
                        style: Theme.of(context).textTheme.headline3,
                      )),
                ),
              ),
              Expanded(
                flex: 15,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  child: FractionallySizedBox(
                    heightFactor: 0.6,
                    child: StreamBuilder<List<DateTime>>(
                        stream: eventHomeBloc.datesSubject.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var dates = snapshot.data;
                            return ListView.builder(
                              padding: EdgeInsets.only(left: 16),
                              scrollDirection: Axis.horizontal,
                              itemCount: dates.length,
                              itemBuilder: (context, index) {
                                DateTime currentDateTime = dates[index];
                                return StreamBuilder<DateTime>(
                                    stream: eventHomeBloc.selectedDateTimeSubject.stream,
                                    builder: (context, snapshot) {
                                      bool isCurrentDate = false;
                                      if (snapshot.hasData && eventHomeBloc.isSameDay(currentDateTime)) {
                                          isCurrentDate = true;
                                      }
                                      return DateItem(
                                        currentDateTime: currentDateTime,
                                        isCurrentDate: isCurrentDate,
                                        eventHomeBloc: eventHomeBloc,
                                      );
                                    });
                              },
                            );
                          }
                          return ListView.builder(
                            padding: EdgeInsets.only(left: 16),
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 20,
                            itemBuilder: (context, index) => DateItemLoading(),
                          );
                        }),
                  ),
                ),
              ),
              Expanded(
                flex: 57,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        height: 30,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 80,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Near',
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 20,
                              child: FractionallySizedBox(
                                heightFactor: 0.7,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'See all',
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 100,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          margin: EdgeInsets.only(top: 16),
                          child: StreamBuilder<List<Event>>(
                              stream: eventHomeBloc.nearEventsSubject.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var events = snapshot.data;
                                  return ListView.builder(
                                    padding: EdgeInsets.only(left: 16, right: 16, top: 0),
                                    itemCount: events.length,
                                    itemBuilder: (context, index) {
                                      Event currentEvent = events[index];
                                      return NearEventItem(currentEvent: currentEvent);
                                    },
                                  );
                                }
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 25,
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: SvgPicture.asset('assets/images/icon_home_fill.svg'),
                              ),
                              Positioned.fill(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashFactory: InkRipple.splashFactory,
                                    onTap: () {
                                      var events = eventService.eventsSubject.value;
                                      eventService.firstNearEventSubject.sink.add(events[0]);
                                      //eventService.items.sink.add(events);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 25,
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: SvgPicture.asset('assets/images/icon_calendar.svg'),
                              ),
                              Positioned.fill(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashFactory: InkRipple.splashFactory,
                                    onTap: () => null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 25,
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: SvgPicture.asset('assets/images/icon_ticket.svg'),
                              ),
                              Positioned.fill(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashFactory: InkRipple.splashFactory,
                                    onTap: () => null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 25,
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: SvgPicture.asset('assets/images/icon_settings.svg'),
                              ),
                              Positioned.fill(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashFactory: InkRipple.splashFactory,
                                    onTap: () => null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DateItemLoading extends StatelessWidget {
  const DateItemLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 8),
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: Card(
          elevation: 0,
          color: Colors.grey.withOpacity(0.3),
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class DateItem extends StatelessWidget {
  const DateItem({
    Key key,
    @required this.currentDateTime,
    @required this.isCurrentDate,
    @required this.eventHomeBloc,
  }) : super(key: key);

  final DateTime currentDateTime;
  final bool isCurrentDate;
  final EventHomeBloc eventHomeBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 8),
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: Card(
          elevation: 0,
          color: isCurrentDate ? Theme.of(context).primaryColor : Colors.white,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isCurrentDate
                ? BorderSide.none
                : BorderSide(
                    width: 1.5,
                    color: AppTheme.borderCard,
                  ),
          ),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                child: FractionallySizedBox(
                  heightFactor: 0.7,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 50,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            DateFormat.E().format(currentDateTime),
                            style: isCurrentDate ? Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white) : Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 50,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            currentDateTime.day.toString(),
                            style: isCurrentDate ? Theme.of(context).textTheme.headline4.copyWith(color: Colors.white) : Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashFactory: InkRipple.splashFactory,
                    onTap: (){
                      eventHomeBloc.selectedDateTimeSubject.sink.add(currentDateTime);
                      //eventHomeBloc.blocEvents.sink.add(EventHomeBlocEvents.SELECT_DATE);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NearEventItem extends StatelessWidget {
  const NearEventItem({
    Key key,
    @required this.currentEvent,
  }) : super(key: key);

  final Event currentEvent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: double.infinity,
          height: 120,
          child: Stack(
            children: [
              Row(
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 5,
                    child: Card(
                      elevation: 0,
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radius),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: currentEvent.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 5,
                  ),
                  Expanded(
                    flex: 65,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          children: [
                            Spacer(
                              flex: 10,
                            ),
                            Expanded(
                              flex: 20,
                              child: Container(
                                child: Container(
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        currentEvent.name,
                                        style: Theme.of(context).textTheme.headline5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 30,
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor: 0.5,
                                  heightFactor: 1,
                                  child: Text(
                                    currentEvent.address,
                                    maxLines: 2,
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(
                              flex: 5,
                            ),
                            Expanded(
                              flex: 25,
                              child: Container(
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      DateFormat.jm().format(currentEvent.date) + ' - ' + DateFormat.jm().format(currentEvent.date.add(Duration(hours: 2))),
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Spacer(
                              flex: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashFactory: InkRipple.splashFactory,
                    splashColor: AppTheme.shadow.withOpacity(0.1),
                    onTap: () {
                      //Navigator.pushNamed(context, EventDetailScreen.routeName,arguments: currentEvent.id);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
