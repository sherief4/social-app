import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/app_layout.dart';
import 'package:social_app/layouts/cubit/cubit.dart';
import 'package:social_app/modules/login_page/cubit/cubit.dart';
import 'package:social_app/modules/login_page/login_page.dart';
import 'package:social_app/modules/signup_page/cubit/cubit.dart';
import 'package:social_app/network/cache_helper.dart';
import 'package:social_app/shared/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await CacheHelper.init();

  uId = await CacheHelper.getData('uId');

  Widget startWidget;

  if (uId != null) {
    startWidget = AppLayout();
  } else {
    startWidget = LoginPage();
  }
  runApp(MyApp(
    startWidget: startWidget,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.startWidget}) : super(key: key);

  final Widget startWidget;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => LoginCubit(),
          ),
          BlocProvider(
            create: (_) => AppCubit()
              ..getUserData()
              ..getPosts(),
          ),
          BlocProvider(
            create: (_) => SignupCubit(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Social App',
          theme: ThemeData(
            primaryColor: mainColor,
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Jannah',
            primarySwatch: Colors.blueGrey,
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedIconTheme: IconThemeData(
                  color: secondColor,
                ),
                unselectedIconTheme: IconThemeData(
                  color: mainColor,
                ),
                selectedLabelStyle: TextStyle(
                  color: secondColor,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.bold,
                ),
                selectedItemColor: secondColor,
                unselectedItemColor: Colors.black),
          ),
          home: startWidget,
        ));
  }
}
