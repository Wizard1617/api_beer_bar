import 'package:api_beer_bar/Page/beer_list_screen.dart';
import 'package:api_beer_bar/Page/login_screen.dart';
import 'package:api_beer_bar/Page/register_screen.dart';
import 'package:api_beer_bar/auth_cubit.dart';
import 'package:api_beer_bar/register_cubit.dart';
import 'package:api_beer_bar/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'BeerBar App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey, // Используйте ключ здесь

      home: BlocProvider(
        create: (context) => AuthCubit(),
        child: LoginScreen(),
      ),
      routes: {
        '/login': (context) => BlocProvider(
          create: (context) => AuthCubit(),
          child: LoginScreen(),
        ),
        '/register': (context) => BlocProvider(
          create: (context) => RegisterCubit(),
          child: RegisterScreen(),
        ),
        '/beer_list': (context) => BeerListScreen(),
      },
    );
  }
}
