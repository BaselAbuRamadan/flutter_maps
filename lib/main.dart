import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_maps/app_router.dart';
import 'package:flutter_maps/presentation/screens/login_screen.dart';
import 'constants/strings.dart';
import 'firebase_options.dart';

late String initialRoute;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.authStateChanges().listen((user){
    if(user == null){
      initialRoute = loginScreen;
    }else {
      initialRoute = mapScreen;
    }

  });
  runApp( MyApp( appRouter: AppRouter(),),);
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({Key? key, required this.appRouter}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: initialRoute,
    );
  }
}

