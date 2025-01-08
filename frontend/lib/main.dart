import 'package:flutter/material.dart';
import 'package:task_app/features/auth/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task App ',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
           contentPadding: const EdgeInsets.all(27),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  
                  borderSide: BorderSide(color: Colors.grey.shade300,width: 3),
                ),
                focusedBorder:  OutlineInputBorder(
                  borderSide:const  BorderSide(width: 3),
                  
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 3),
                  borderRadius: BorderRadius.circular(10),
                ),
              errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3,color: Colors.red),),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            
            backgroundColor: Colors.black,
            minimumSize:  const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
        ),
      
        ),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}


