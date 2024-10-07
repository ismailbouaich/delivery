import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_app/routes/app_routes.dart';


void main()async {
    await GetStorage.init(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final box=GetStorage();
    final token = box.read('token');
     return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Forum App',
      initialRoute: token == null ? '/login' : '/home',
      getPages: AppRoutes.routes,
    );
   
      
  }
}
