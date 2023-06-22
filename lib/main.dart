import 'package:flutter/material.dart';

import 'common/routes/view_routes.dart';

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    initialRoute: RoutesApp.home,
    onGenerateRoute: RoutesApp.generateRoute,
    // onGenerateInitialRoutes: (initialRoute) => [
    //   MaterialPageRoute(
    //     builder: (context) => const LoginForm(),
    //   )
    // ],
    debugShowCheckedModeBanner: false,
  ));
}
