import 'package:descarte_bem/utils/widgets/loading_widget.dart';
import 'package:descarte_bem/view/map_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';
import 'login_page.dart';
import '../controllers/map_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool? signedIn;
  bool? loading;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, userController, child) {
        signedIn = userController.isSignedIn;
        loading = userController.loading;
        return Builder(
          builder: (c) => redirect(),
        );
      },
    );
  }

  Widget redirect() {
    if (loading!) {
      return loadingWidget(context);
    }

    if (!signedIn!) {
      return LoginPage();
    }

    return ChangeNotifierProvider(
      create: (context) => MapController(),
      child: Consumer<MapController>(
        builder: (context, controller, _) {
          return MapPage(controller: controller);
        },
      )
    );
  }
}