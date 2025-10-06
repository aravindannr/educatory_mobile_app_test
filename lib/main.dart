import 'package:educatory_mobile_application/core/constants/app_routes.dart';
import 'package:educatory_mobile_application/firebase_options.dart';
import 'package:educatory_mobile_application/providers/home_provider.dart';
import 'package:educatory_mobile_application/providers/login_provider.dart';
import 'package:educatory_mobile_application/providers/otp_page_provider.dart';
import 'package:educatory_mobile_application/providers/profile_provider.dart';
import 'package:educatory_mobile_application/providers/sign_up_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OtpPageProvider()),
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MaterialApp(
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
