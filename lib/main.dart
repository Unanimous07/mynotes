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
                  if (user?.emailVerified ?? false) {
                    print('You are a verified User');
                    return const Text('Done');

                  } else {
                    
                    return const VerifyEmail();
                  }
              

            default: 
              return const Center(child: CircularProgressIndicator());

            }
          }
          );
  }
}


class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Column (
            children: [
              const Text('Please verify your email'),
              TextButton(
                onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    await user?.sendEmailVerification();
                    //await Navigator.of(context).pushNamedAndRemoveUntil('/Login/', (route) => false);
                }, 
                child: const Text('Send verification email'))
            ]
      ),
    );
  }
}
