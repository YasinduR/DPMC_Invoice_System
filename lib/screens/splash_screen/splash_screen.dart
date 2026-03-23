import 'package:flutter/material.dart';
import 'package:myapp/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
return Scaffold(
  body: SizedBox.expand(
    child: Image.asset(
      'assets/images/dpmc_splash.JPG',
      fit: BoxFit.cover,
      alignment: Alignment.center,
    ),
  ),
);
  }
}
