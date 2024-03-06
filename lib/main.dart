import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:krl_app/pages/home_page.dart';

void main() {
  runApp(const KRLApp());
}

class KRLApp extends StatelessWidget {
  const KRLApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const HomePage(),
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}
