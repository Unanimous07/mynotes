//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_views.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:mynotes/views/login_view.dart';
//import 'package:mynotes/views/register_views.dart';
//import 'firebase_options.dart';


import 'package:mynotes/views/verify_emailview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/login/':(context) => const LoginView(),
        '/register':(context) => const RegisterView(),
      },
    )
  );
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState){
            
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    if (!user.emailVerified) {
                      return const VerifyEmail();
                    } else {
                      return const LoginView();
                    }
                  
                  } else {
                    return const RegisterView();
                  }

            default: 
              return const Center(child: CircularProgressIndicator());

            }
          }
          );
  }
}


