import 'package:descarte_bem/services/sign_in_service.dart';
import 'package:descarte_bem/view/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/user_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (await Permission.locationWhenInUse.isDenied) {
    await Permission.locationWhenInUse.request();
  }

  runApp(MultiProvider(
    providers: [
      Provider<SignInService>(create: (context) => SignInService()),

      ChangeNotifierProvider<UserController>(
        create: (context) => UserController(context.read())),
    ],
    child: const App()
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Descarte Bem',
      home: const SplashPage(),
    );
  }
}
