import 'package:contact_app/contact_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // or a light color
      statusBarIconBrightness:
          Brightness.dark, // dark icons for light status bar
      systemNavigationBarColor: Colors.white, // light nav bar
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  await ContactDb.instance.initializeContactDb();
  runApp(
    BlocProvider<ContactBloc>(
      create: (context) => ContactBloc(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: ThemeMode.light,

      debugShowCheckedModeBanner: false,
      home: ContactAppDashboard(),
    );
  }
}
