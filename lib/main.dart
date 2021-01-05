import 'package:event_app/blocs/home_bloc.dart';
import 'package:event_app/pages/event_home_screen.dart';
import 'package:event_app/pages/home_screen.dart';
import 'package:event_app/pages/splash_screen.dart';
import 'package:event_app/size_config.dart';
import 'package:event_app/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        setupSystemSettings();
        return MaterialApp(
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
          routes: {
            SplashScreen.routeName: (ctx) => SplashScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            EventHomeScreen.routeName: (ctx) => EventHomeScreen(),
          },
        );
      });
    });
  }
}

void setupSystemSettings() {
  // this will change color of status bar and system navigation bar
  SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiDark);

  // this will prevent change oriontation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
